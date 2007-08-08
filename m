From: akpm@linux-foundation.org
Subject: + scsi-expose-an-support-to-user-space.patch added to -mm tree
Date: Wed, 08 Aug 2007 12:25:00 -0700
Message-ID: <200708081925.l78JP0JY026514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232AbXHHTZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     scsi: expose AN support to user space
has been added to the -mm tree.  Its filename is
     scsi-expose-an-support-to-user-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: expose AN support to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

If a scsi_device supports async notification for media change, then let user
space know this capability exists by creating a new sysfs entry
"media_change_notify", which will be 1 if it is supported, and 0 if not
supported.  Create a routine which allows scsi devices to send a uevent when
media change events occur.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c    |   83 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   |    1 
 drivers/scsi/scsi_sysfs.c  |   13 +++++
 include/scsi/scsi_device.h |   15 +++++-
 4 files changed, 111 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-expose-an-support-to-user-space drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-expose-an-support-to-user-space
+++ a/drivers/scsi/scsi_lib.c
@@ -64,6 +64,11 @@ static struct scsi_host_sg_pool scsi_sg_
 }; 	
 #undef SP
 
+/* must match scsi_device_event enum in scsi_device.h */
+static char * scsi_device_event_strings[] = {
+	"MEDIA_CHANGE=1",
+};
+
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -2007,6 +2012,84 @@ scsi_device_set_state(struct scsi_device
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
+ * 	scsi_device_set_event - Add a new Async event to the event list
+ *	@sdev: scsi_device event occurred on
+ *	@event: the scsi device event
+ *
+ * 	Add a new scsi_device_event_info struct to the scsi_device_event_list
+ * 	queue.  This may be called from interrupt context.
+ *
+ * 	Returns 0 if successful, -ENOMEM otherwise.
+ */
+static int
+scsi_device_set_event(struct scsi_device *sdev, enum scsi_device_event event)
+{
+	struct scsi_device_event_info *scsi_event;
+	unsigned long flags;
+
+	scsi_event = kzalloc(sizeof(*scsi_event), GFP_ATOMIC);
+	if (!scsi_event)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&scsi_event->link);
+	scsi_event->event = event;
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_add_tail(&scsi_event->link, &sdev->sdev_event_list);
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	return 0;
+}
+
+/**
+ * 	scsi_device_event_notify_thread - send a uevent for each scsi event
+ *	@work: work struct for scsi_device
+ *
+ * 	Traverse the queue of scsi device events, dequeue each event and
+ * 	send a uevent.  Frees event.  May not be called from interrupt.
+ */
+static void scsi_event_notify_thread(struct work_struct *work)
+{
+	struct scsi_device *sdev;
+	char *envp[] = { NULL, NULL };
+	struct list_head *tmp;
+	struct list_head *next;
+	struct scsi_device_event_info *sdev_event;
+	unsigned long flags;
+
+	sdev = container_of(work, struct scsi_device, ew.work);
+	list_for_each_safe(tmp, next, &sdev->sdev_event_list) {
+		sdev_event = list_entry(tmp, struct scsi_device_event_info,
+					link);
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_del(&sdev_event->link);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+		envp[0] = scsi_device_event_strings[sdev_event->event-1];
+		kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+		kfree(sdev_event);
+	}
+}
+
+/**
+ * 	scsi_device_event_notify - store event info and send an event
+ *	@sdev: scsi_device event occurred on
+ *	@event: the scsi device event
+ *
+ * 	Store the event information and then switch process context
+ * 	so that the event may be sent to user space.
+ * 	This may be called from interrupt context.
+ *
+ * 	Returns 0 if successful, -ENOMEM otherwise.
+ */
+int scsi_device_event_notify(struct scsi_device *sdev, enum scsi_device_event event)
+{
+	int rc;
+
+	rc = scsi_device_set_event(sdev, event);
+	if (!rc)
+		execute_in_process_context(scsi_event_notify_thread, &sdev->ew);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(scsi_device_event_notify);
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
diff -puN drivers/scsi/scsi_scan.c~scsi-expose-an-support-to-user-space drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-expose-an-support-to-user-space
+++ a/drivers/scsi/scsi_scan.c
@@ -253,6 +253,7 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
 	INIT_LIST_HEAD(&sdev->starved_entry);
+	INIT_LIST_HEAD(&sdev->sdev_event_list);
 	spin_lock_init(&sdev->list_lock);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
diff -puN drivers/scsi/scsi_sysfs.c~scsi-expose-an-support-to-user-space drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~scsi-expose-an-support-to-user-space
+++ a/drivers/scsi/scsi_sysfs.c
@@ -575,6 +575,18 @@ sdev_show_modalias(struct device *dev, s
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
+static ssize_t
+sdev_show_media_change_notify(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	if (sdev->media_change_notify)
+		return snprintf(buf, 20, "%d\n", 1);
+	else
+		return snprintf(buf, 20, "%d\n", 0);
+}
+static DEVICE_ATTR(media_change_notify, S_IRUGO, sdev_show_media_change_notify, NULL);
+
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,
@@ -594,6 +606,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_iodone_cnt,
 	&dev_attr_ioerr_cnt,
 	&dev_attr_modalias,
+	&dev_attr_media_change_notify,
 	NULL
 };
 
diff -puN include/scsi/scsi_device.h~scsi-expose-an-support-to-user-space include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-expose-an-support-to-user-space
+++ a/include/scsi/scsi_device.h
@@ -46,6 +46,16 @@ enum scsi_device_state {
 				 * to the scsi lld. */
 };
 
+/* must match scsi_device_event_strings in scsi_lib.c */
+enum scsi_device_event {
+	SDEV_MEDIA_CHANGE = 1,	/* media has changed */
+};
+
+struct scsi_device_event_info {
+	enum scsi_device_event event;
+	struct list_head link;
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -126,7 +136,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
-
+	unsigned media_change_notify:1; /* dev supports async media notify */
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
@@ -144,6 +154,7 @@ struct scsi_device {
 	struct execute_work	ew; /* used to get process context on put */
 
 	enum scsi_device_state sdev_state;
+	struct list_head	sdev_event_list;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 #define	to_scsi_device(d)	\
@@ -275,6 +286,8 @@ extern int scsi_test_unit_ready(struct s
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
+extern int scsi_device_event_notify(struct scsi_device *sdev,
+				enum scsi_device_event event);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
alpm-store-interrupt-value.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
