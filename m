From: akpm@linux-foundation.org
Subject: + updates-for-the-memstick-driver.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:09:51 -0800
Message-ID: <200801270509.m0R59mOd030782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYA0FJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:09:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: updates for the memstick driver
has been added to the -mm tree.  Its filename is
     updates-for-the-memstick-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: updates for the memstick driver
From: Alex Dubov <oakad@yahoo.com>

* Mark shared inline functions as static

* Use member-at-a-time assignment for protocol structures

* Comments for publicly exported functions

* Use end_queued_request to end unhandled block layer requests

* Use sysfs attribute group to export MSPro attributes

* Fix includes

* Use scnprintf instead of snprintf where string length matters

* Remove spurious get_device/put_device in probe method


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   91 ++++-
 drivers/memstick/core/mspro_block.c |  422 ++++++++++++--------------
 include/linux/memstick.h            |   10 
 3 files changed, 288 insertions(+), 235 deletions(-)

diff -puN drivers/memstick/core/memstick.c~updates-for-the-memstick-driver drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~updates-for-the-memstick-driver
+++ a/drivers/memstick/core/memstick.c
@@ -12,11 +12,10 @@
  *
  */
 
-#include <linux/tifm.h>
 #include <linux/memstick.h>
 #include <linux/idr.h>
-#include <linux/scatterlist.h>
 #include <linux/fs.h>
+#include <linux/delay.h>
 
 #define DRIVER_NAME "memstick"
 #define DRIVER_VERSION "0.2"
@@ -86,13 +85,11 @@ static int memstick_device_probe(struct 
 						   driver);
 	int rc = -ENODEV;
 
-	get_device(dev);
 	if (dev->driver && drv->probe) {
 		rc = drv->probe(card);
 		if (!rc)
-			return 0;
+			get_device(dev);
 	}
-	put_device(dev);
 	return rc;
 }
 
@@ -205,12 +202,26 @@ static int memstick_dummy_check(struct m
 	return 0;
 }
 
+/**
+ * memstick_detect_change - schedule media detection on memstick host
+ * @host - host to use
+ */
 void memstick_detect_change(struct memstick_host *host)
 {
 	queue_work(workqueue, &host->media_checker);
 }
 EXPORT_SYMBOL(memstick_detect_change);
 
+/**
+ * memstick_next_req - called by host driver to obtain next request to process
+ * @host - host to use
+ * @mrq - pointer to stick the request to
+ *
+ * Host calls this function from idle state (*mrq == NULL) or after finishing
+ * previous request (*mrq should point to it). If previous request was
+ * unsuccessful, it is retried for predetermined number of times. Return value
+ * of 0 means that new request was assigned to the host.
+ */
 int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
 {
 	int rc = -ENXIO;
@@ -233,6 +244,10 @@ int memstick_next_req(struct memstick_ho
 }
 EXPORT_SYMBOL(memstick_next_req);
 
+/**
+ * memstick_new_req - notify the host that some requests are pending
+ * @host - host to use
+ */
 void memstick_new_req(struct memstick_host *host)
 {
 	host->retries = cmd_retries;
@@ -240,6 +255,12 @@ void memstick_new_req(struct memstick_ho
 }
 EXPORT_SYMBOL(memstick_new_req);
 
+/**
+ * memstick_init_req_sg - set request fields needed for bulk data transfer
+ * @mrq - request to use
+ * @tpc - memstick Transport Protocol Command
+ * @sg - TPC argument
+ */
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 			  struct scatterlist *sg)
 {
@@ -261,6 +282,17 @@ void memstick_init_req_sg(struct memstic
 }
 EXPORT_SYMBOL(memstick_init_req_sg);
 
+/**
+ * memstick_init_req - set request fields needed for short data transfer
+ * @mrq - request to use
+ * @tpc - memstick Transport Protocol Command
+ * @buf - TPC argument buffer
+ * @length - TPC argument size
+ *
+ * The intended use of this function (transfer of data items several bytes
+ * in size) allows us to just copy the value between request structure and
+ * user supplied buffer.
+ */
 void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 		       void *buf, size_t length)
 {
@@ -285,6 +317,13 @@ void memstick_init_req(struct memstick_r
 }
 EXPORT_SYMBOL(memstick_init_req);
 
+/*
+ * Functions prefixed with "h_" are protocol callbacks. They can be called from
+ * interrupt context. Return value of 0 means that request processing is still
+ * ongoing, while special error value of -EAGAIN means that current request is
+ * finished (and request processor should come back some time later).
+ */
+
 static int h_memstick_read_dev_id(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
@@ -298,12 +337,10 @@ static int h_memstick_read_dev_id(struct
 	} else {
 		if (!(*mrq)->error) {
 			memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
-			card->id = (struct memstick_device_id){
-				.match_flags = MEMSTICK_MATCH_ALL,
-				.type = id_reg.type,
-				.category = id_reg.category,
-				.class = id_reg.class
-			};
+			card->id.match_flags = MEMSTICK_MATCH_ALL;
+			card->id.type = id_reg.type;
+			card->id.category = id_reg.category;
+			card->id.class = id_reg.class;
 		}
 		complete(&card->mrq_complete);
 		return -EAGAIN;
@@ -325,6 +362,11 @@ static int h_memstick_set_rw_addr(struct
 	}
 }
 
+/**
+ * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
+ *                        complete
+ * @card - media device to use
+ */
 int memstick_set_rw_addr(struct memstick_dev *card)
 {
 	card->next_request = h_memstick_set_rw_addr;
@@ -351,12 +393,10 @@ static struct memstick_dev *memstick_all
 		card->dev.release = memstick_free_card;
 		card->check = memstick_dummy_check;
 
-		card->reg_addr = (struct ms_register_addr){
-			offsetof(struct ms_register, id),
-			sizeof(id_reg),
-			offsetof(struct ms_register, id),
-			sizeof(id_reg)
-		};
+		card->reg_addr.r_offset = offsetof(struct ms_register, id);
+		card->reg_addr.r_length = sizeof(id_reg);
+		card->reg_addr.w_offset = offsetof(struct ms_register, id);
+		card->reg_addr.w_length = sizeof(id_reg);
 
 		init_completion(&card->mrq_complete);
 
@@ -433,6 +473,11 @@ static void memstick_check(struct work_s
 	dev_dbg(host->cdev.dev, "memstick_check finished\n");
 }
 
+/**
+ * memstick_alloc_host - allocate a memstick_host structure
+ * @extra: size of the user private data to allocate
+ * @dev: parent device of the host
+ */
 struct memstick_host *memstick_alloc_host(unsigned int extra,
 					  struct device *dev)
 {
@@ -450,6 +495,10 @@ struct memstick_host *memstick_alloc_hos
 }
 EXPORT_SYMBOL(memstick_alloc_host);
 
+/**
+ * memstick_add_host - start request processing on memstick host
+ * @host - host to use
+ */
 int memstick_add_host(struct memstick_host *host)
 {
 	int rc;
@@ -480,6 +529,10 @@ int memstick_add_host(struct memstick_ho
 }
 EXPORT_SYMBOL(memstick_add_host);
 
+/**
+ * memstick_remove_host - stop request processing on memstick host
+ * @host - host to use
+ */
 void memstick_remove_host(struct memstick_host *host)
 {
 	flush_workqueue(workqueue);
@@ -497,6 +550,10 @@ void memstick_remove_host(struct memstic
 }
 EXPORT_SYMBOL(memstick_remove_host);
 
+/**
+ * memstick_free_host - free memstick host
+ * @host - host to use
+ */
 void memstick_free_host(struct memstick_host *host)
 {
 	mutex_destroy(&host->lock);
diff -puN drivers/memstick/core/mspro_block.c~updates-for-the-memstick-driver drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~updates-for-the-memstick-driver
+++ a/drivers/memstick/core/mspro_block.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/scatterlist.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/kthread.h>
@@ -44,10 +43,10 @@ enum {
 
 struct mspro_sys_attr {
 	size_t                  size;
-	unsigned char           *data;
+	void                    *data;
 	unsigned char           id;
 	char                    name[32];
-	struct device_attribute sys_attr;
+	struct device_attribute dev_attr;
 };
 
 struct mspro_attr_entry {
@@ -144,8 +143,7 @@ struct mspro_block_data {
 	int                   (*mrq_handler)(struct memstick_dev *card,
 					     struct memstick_request **mrq);
 
-	unsigned char         attr_count;
-	struct mspro_sys_attr *attributes;
+	struct attribute_group attr_group;
 
 	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
 	unsigned int          seg_count;
@@ -229,6 +227,13 @@ static struct block_device_operations ms
 
 /*** Information ***/
 
+static struct mspro_sys_attr *mspro_from_sysfs_attr(struct attribute *attr)
+{
+	struct device_attribute *dev_attr
+		= container_of(attr, struct device_attribute, attr);
+	return container_of(dev_attr, struct mspro_sys_attr, dev_attr);
+}
+
 static const char *mspro_block_attr_name(unsigned char tag)
 {
 	switch (tag) {
@@ -261,20 +266,20 @@ static ssize_t mspro_block_attr_show_def
 					     struct device_attribute *attr,
 					     char *buffer)
 {
-	struct mspro_sys_attr *x_attr = container_of(attr,
+	struct mspro_sys_attr *s_attr = container_of(attr,
 						     struct mspro_sys_attr,
-						     sys_attr);
+						     dev_attr);
 
 	ssize_t cnt, rc = 0;
 
-	for (cnt = 0; cnt < x_attr->size; cnt++) {
+	for (cnt = 0; cnt < s_attr->size; cnt++) {
 		if (cnt && !(cnt % 16)) {
 			if (PAGE_SIZE - rc)
 				buffer[rc++] = '\n';
 		}
 
-		rc += snprintf(buffer + rc, PAGE_SIZE - rc, "%02x ",
-			       x_attr->data[cnt]);
+		rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "%02x ",
+				((unsigned char *)s_attr->data)[cnt]);
 	}
 	return rc;
 }
@@ -285,63 +290,66 @@ static ssize_t mspro_block_attr_show_sys
 {
 	struct mspro_sys_attr *x_attr = container_of(attr,
 						     struct mspro_sys_attr,
-						     sys_attr);
-	struct mspro_sys_info *x_sys = (struct mspro_sys_info *)x_attr->data;
+						     dev_attr);
+	struct mspro_sys_info *x_sys = x_attr->data;
 	ssize_t rc = 0;
 
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
-		       x_sys->class);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block size: %x\n",
-		       be16_to_cpu(x_sys->block_size));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block count: %x\n",
-		       be16_to_cpu(x_sys->block_count));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "user block count: %x\n",
-		       be16_to_cpu(x_sys->user_block_count));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
-		       be16_to_cpu(x_sys->page_size));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
-		       "%d %04u-%02u-%02u %02u:%02u:%02u\n",
-		       x_sys->assembly_date[0],
-		       be16_to_cpu(*(unsigned short *)&x_sys->assembly_date[1]),
-		       x_sys->assembly_date[3], x_sys->assembly_date[4],
-		       x_sys->assembly_date[5], x_sys->assembly_date[6],
-		       x_sys->assembly_date[7]);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "serial number: %x\n",
-		       be32_to_cpu(x_sys->serial_number));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly maker code: %x\n",
-		       x_sys->assembly_maker_code);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly model code: "
-		       "%02x%02x%02x\n", x_sys->assembly_model_code[0],
-		       x_sys->assembly_model_code[1],
-		       x_sys->assembly_model_code[2]);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory maker code: %x\n",
-		       be16_to_cpu(x_sys->memory_maker_code));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory model code: %x\n",
-		       be16_to_cpu(x_sys->memory_model_code));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vcc: %x\n",
-		       x_sys->vcc);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vpp: %x\n",
-		       x_sys->vpp);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller number: %x\n",
-		       be16_to_cpu(x_sys->controller_number));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller function: %x\n",
-		       be16_to_cpu(x_sys->controller_function));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
-		       be16_to_cpu(x_sys->start_sector));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "unit size: %x\n",
-		       be16_to_cpu(x_sys->unit_size));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "sub class: %x\n",
-		       x_sys->ms_sub_class);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "interface type: %x\n",
-		       x_sys->interface_type);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller code: %x\n",
-		       be16_to_cpu(x_sys->controller_code));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "format type: %x\n",
-		       x_sys->format_type);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "device type: %x\n",
-		       x_sys->device_type);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "mspro id: %s\n",
-		       x_sys->mspro_id);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
+			x_sys->class);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "block size: %x\n",
+			be16_to_cpu(x_sys->block_size));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "block count: %x\n",
+			be16_to_cpu(x_sys->block_count));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "user block count: %x\n",
+			be16_to_cpu(x_sys->user_block_count));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
+			be16_to_cpu(x_sys->page_size));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
+			"%d %04u-%02u-%02u %02u:%02u:%02u\n",
+			x_sys->assembly_date[0],
+			be16_to_cpu(*(unsigned short *)
+				    &x_sys->assembly_date[1]),
+			x_sys->assembly_date[3], x_sys->assembly_date[4],
+			x_sys->assembly_date[5], x_sys->assembly_date[6],
+			x_sys->assembly_date[7]);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "serial number: %x\n",
+			be32_to_cpu(x_sys->serial_number));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc,
+			"assembly maker code: %x\n",
+			x_sys->assembly_maker_code);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly model code: "
+			"%02x%02x%02x\n", x_sys->assembly_model_code[0],
+			x_sys->assembly_model_code[1],
+			x_sys->assembly_model_code[2]);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "memory maker code: %x\n",
+			be16_to_cpu(x_sys->memory_maker_code));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "memory model code: %x\n",
+			be16_to_cpu(x_sys->memory_model_code));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "vcc: %x\n",
+			x_sys->vcc);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "vpp: %x\n",
+			x_sys->vpp);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "controller number: %x\n",
+			be16_to_cpu(x_sys->controller_number));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc,
+			"controller function: %x\n",
+			be16_to_cpu(x_sys->controller_function));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
+			be16_to_cpu(x_sys->start_sector));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "unit size: %x\n",
+			be16_to_cpu(x_sys->unit_size));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "sub class: %x\n",
+			x_sys->ms_sub_class);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "interface type: %x\n",
+			x_sys->interface_type);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "controller code: %x\n",
+			be16_to_cpu(x_sys->controller_code));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "format type: %x\n",
+			x_sys->format_type);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "device type: %x\n",
+			x_sys->device_type);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "mspro id: %s\n",
+			x_sys->mspro_id);
 	return rc;
 }
 
@@ -349,11 +357,11 @@ static ssize_t mspro_block_attr_show_mod
 					       struct device_attribute *attr,
 					       char *buffer)
 {
-	struct mspro_sys_attr *x_attr = container_of(attr,
+	struct mspro_sys_attr *s_attr = container_of(attr,
 						     struct mspro_sys_attr,
-						     sys_attr);
+						     dev_attr);
 
-	return snprintf(buffer, PAGE_SIZE, "%s", x_attr->data);
+	return scnprintf(buffer, PAGE_SIZE, "%s", (char *)s_attr->data);
 }
 
 static ssize_t mspro_block_attr_show_mbr(struct device *dev,
@@ -362,31 +370,31 @@ static ssize_t mspro_block_attr_show_mbr
 {
 	struct mspro_sys_attr *x_attr = container_of(attr,
 						     struct mspro_sys_attr,
-						     sys_attr);
-	struct mspro_mbr *x_mbr = (struct mspro_mbr *)x_attr->data;
+						     dev_attr);
+	struct mspro_mbr *x_mbr = x_attr->data;
 	ssize_t rc = 0;
 
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "boot partition: %x\n",
-		       x_mbr->boot_partition);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start head: %x\n",
-		       x_mbr->start_head);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
-		       x_mbr->start_sector);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start cylinder: %x\n",
-		       x_mbr->start_cylinder);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "partition type: %x\n",
-		       x_mbr->partition_type);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end head: %x\n",
-		       x_mbr->end_head);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end sector: %x\n",
-		       x_mbr->end_sector);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end cylinder: %x\n",
-		       x_mbr->end_cylinder);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sectors: %x\n",
-		       x_mbr->start_sectors);
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc,
-		       "sectors per partition: %x\n",
-		       x_mbr->sectors_per_partition);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "boot partition: %x\n",
+			x_mbr->boot_partition);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start head: %x\n",
+			x_mbr->start_head);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
+			x_mbr->start_sector);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start cylinder: %x\n",
+			x_mbr->start_cylinder);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "partition type: %x\n",
+			x_mbr->partition_type);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "end head: %x\n",
+			x_mbr->end_head);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "end sector: %x\n",
+			x_mbr->end_sector);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "end cylinder: %x\n",
+			x_mbr->end_cylinder);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start sectors: %x\n",
+			x_mbr->start_sectors);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc,
+			"sectors per partition: %x\n",
+			x_mbr->sectors_per_partition);
 	return rc;
 }
 
@@ -396,20 +404,20 @@ static ssize_t mspro_block_attr_show_dev
 {
 	struct mspro_sys_attr *x_attr = container_of(attr,
 						     struct mspro_sys_attr,
-						     sys_attr);
-	struct mspro_devinfo *x_devinfo = (struct mspro_devinfo *)x_attr->data;
+						     dev_attr);
+	struct mspro_devinfo *x_devinfo = x_attr->data;
 	ssize_t rc = 0;
 
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "cylinders: %x\n",
-		       be16_to_cpu(x_devinfo->cylinders));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "heads: %x\n",
-		       be16_to_cpu(x_devinfo->heads));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "bytes per track: %x\n",
-		       be16_to_cpu(x_devinfo->bytes_per_track));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "bytes per sector: %x\n",
-		       be16_to_cpu(x_devinfo->bytes_per_sector));
-	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "sectors per track: %x\n",
-		       be16_to_cpu(x_devinfo->sectors_per_track));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "cylinders: %x\n",
+			be16_to_cpu(x_devinfo->cylinders));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "heads: %x\n",
+			be16_to_cpu(x_devinfo->heads));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "bytes per track: %x\n",
+			be16_to_cpu(x_devinfo->bytes_per_track));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "bytes per sector: %x\n",
+			be16_to_cpu(x_devinfo->bytes_per_sector));
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "sectors per track: %x\n",
+			be16_to_cpu(x_devinfo->sectors_per_track));
 	return rc;
 }
 
@@ -429,39 +437,15 @@ static sysfs_show_t mspro_block_attr_sho
 	}
 }
 
-static int mspro_block_sysfs_register(struct memstick_dev *card)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int cnt, rc = 0;
-
-	for (cnt = 0; cnt < msb->attr_count; cnt++) {
-		rc = device_create_file(&card->dev,
-					&msb->attributes[cnt].sys_attr);
-
-		if (rc) {
-			if (cnt) {
-				for (cnt--; cnt >= 0; cnt--)
-					device_remove_file(&card->dev,
-							   &msb->attributes[cnt]
-								.sys_attr);
-			}
-			break;
-		}
-	}
-	return rc;
-}
-
-static void mspro_block_sysfs_unregister(struct memstick_dev *card)
-{
-	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	int cnt;
-
-	for (cnt = 0; cnt < msb->attr_count; cnt++)
-		device_remove_file(&card->dev, &msb->attributes[cnt].sys_attr);
-}
-
 /*** Protocol handlers ***/
 
+/*
+ * Functions prefixed with "h_" are protocol callbacks. They can be called from
+ * interrupt context. Return value of 0 means that request processing is still
+ * ongoing, while special error value of -EAGAIN means that current request is
+ * finished (and request processor should come back some time later).
+ */
+
 static int h_mspro_block_req_init(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
@@ -642,12 +626,10 @@ static void mspro_block_process_request(
 
 			t_sec = req->sector;
 			sector_div(t_sec, msb->page_size >> 9);
-			param = (struct mspro_param_register) {
-				.system = msb->system,
-				.data_count = cpu_to_be16(page_count),
-				.data_address = cpu_to_be32((uint32_t)t_sec),
-				.cmd_param = 0
-			};
+			param.system = msb->system;
+			param.data_count = cpu_to_be16(page_count);
+			param.data_address = cpu_to_be32((uint32_t)t_sec);
+			param.cmd_param = 0;
 
 			msb->data_dir = rq_data_dir(req);
 			msb->transfer_cmd = msb->data_dir == READ
@@ -755,17 +737,12 @@ static void mspro_block_request(struct r
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct request *req = NULL;
 
-	if (!msb->q_thread) {
-		for (req = elv_next_request(q); req;
-		     req = elv_next_request(q)) {
-			while (end_that_request_chunk(req, -ENODEV,
-						      req->current_nr_sectors
-						      << 9)) {}
-			end_that_request_last(req, -ENODEV);
-		}
-	} else {
+	if (msb->q_thread) {
 		msb->has_request = 1;
 		wake_up_all(&msb->q_wait);
+	} else {
+		while ((req = elv_next_request(q)) != NULL)
+			end_queued_request(req, -ENODEV);
 	}
 }
 
@@ -821,6 +798,10 @@ static int mspro_block_switch_to_paralle
 	return 0;
 }
 
+/* Memory allocated for attributes by this function should be freed by
+ * mspro_block_data_clear, no matter if the initialization process succeded
+ * or failed.
+ */
 static int mspro_block_read_attributes(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -831,8 +812,9 @@ static int mspro_block_read_attributes(s
 		.cmd_param = 0
 	};
 	struct mspro_attribute *attr = NULL;
+	struct mspro_sys_attr *s_attr = NULL;
 	unsigned char *buffer = NULL;
-	int cnt, rc;
+	int cnt, rc, attr_count;
 	unsigned int addr;
 	unsigned short page_count;
 
@@ -868,18 +850,18 @@ static int mspro_block_read_attributes(s
 	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
 		printk(KERN_WARNING "%s: way too many attribute entries\n",
 		       card->dev.bus_id);
-		msb->attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
+		attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
 	} else
-		msb->attr_count = attr->count;
+		attr_count = attr->count;
 
-	msb->attributes = kzalloc(msb->attr_count
-				  * sizeof(struct mspro_sys_attr),
-				  GFP_KERNEL);
-	if (!msb->attributes) {
-		msb->attr_count = 0;
+	msb->attr_group.attrs = kzalloc((attr_count + 1)
+					* sizeof(struct attribute),
+					GFP_KERNEL);
+	if (!msb->attr_group.attrs) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
+	msb->attr_group.name = "media_attributes";
 
 	buffer = kmalloc(msb->page_size, GFP_KERNEL);
 	if (!buffer) {
@@ -889,40 +871,37 @@ static int mspro_block_read_attributes(s
 	memcpy(buffer, (char *)attr, msb->page_size);
 	page_count = 1;
 
-	for (cnt = 0; cnt < msb->attr_count; cnt++) {
+	for (cnt = 0; cnt < attr_count; ++cnt) {
+		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
+		if (!s_attr) {
+			rc = -ENOMEM;
+			goto out_free_buffer;
+		}
+
+		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
 		addr = be32_to_cpu(attr->entries[cnt].address);
 		rc = be32_to_cpu(attr->entries[cnt].size);
 		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
 			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
-		msb->attributes[cnt].id = attr->entries[cnt].id;
-		if (mspro_block_attr_name(attr->entries[cnt].id))
-			snprintf(msb->attributes[cnt].name,
-				 sizeof(msb->attributes[cnt].name), "%s",
+		s_attr->id = attr->entries[cnt].id;
+		if (mspro_block_attr_name(s_attr->id))
+			snprintf(s_attr->name, sizeof(s_attr->name), "%s",
 				 mspro_block_attr_name(attr->entries[cnt].id));
 		else
-			snprintf(msb->attributes[cnt].name,
-				 sizeof(msb->attributes[cnt].name),
-				 "attr_x%02x",
-				 attr->entries[cnt].id);
-
-		msb->attributes[cnt].sys_attr
-			= (struct device_attribute){
-				.attr = {
-					.name = msb->attributes[cnt].name,
-					.mode = S_IRUGO,
-					.owner = THIS_MODULE
-				},
-				.show = mspro_block_attr_show(
-						msb->attributes[cnt].id),
-				.store = NULL
-			};
+			snprintf(s_attr->name, sizeof(s_attr->name),
+				 "attr_x%02x", attr->entries[cnt].id);
+
+		s_attr->dev_attr.attr.name = s_attr->name;
+		s_attr->dev_attr.attr.mode = S_IRUGO;
+		s_attr->dev_attr.attr.owner = THIS_MODULE;
+		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
 
 		if (!rc)
 			continue;
 
-		msb->attributes[cnt].size = rc;
-		msb->attributes[cnt].data = kmalloc(rc, GFP_KERNEL);
-		if (!msb->attributes[cnt].data) {
+		s_attr->size = rc;
+		s_attr->data = kmalloc(rc, GFP_KERNEL);
+		if (!s_attr->data) {
 			rc = -ENOMEM;
 			goto out_free_buffer;
 		}
@@ -931,8 +910,7 @@ static int mspro_block_read_attributes(s
 		     == be32_to_cpu(param.data_address))
 		    && (((addr + rc - 1) / msb->page_size)
 			== be32_to_cpu(param.data_address))) {
-			memcpy(msb->attributes[cnt].data,
-			       buffer + addr % msb->page_size,
+			memcpy(s_attr->data, buffer + addr % msb->page_size,
 			       rc);
 			continue;
 		}
@@ -948,12 +926,10 @@ static int mspro_block_read_attributes(s
 			}
 		}
 
-		param = (struct mspro_param_register){
-			.system = msb->system,
-			.data_count = cpu_to_be16((rc / msb->page_size) + 1),
-			.data_address = cpu_to_be32(addr / msb->page_size),
-			.cmd_param = 0
-		};
+		param.system = msb->system;
+		param.data_count = cpu_to_be16((rc / msb->page_size) + 1);
+		param.data_address = cpu_to_be32(addr / msb->page_size);
+		param.cmd_param = 0;
 
 		sg_init_one(&msb->req_sg[0], buffer,
 			    be16_to_cpu(param.data_count) * msb->page_size);
@@ -978,9 +954,7 @@ static int mspro_block_read_attributes(s
 			goto out_free_buffer;
 		}
 
-		memcpy(msb->attributes[cnt].data,
-		       buffer + addr % msb->page_size,
-		       rc);
+		memcpy(s_attr->data, buffer + addr % msb->page_size, rc);
 	}
 
 	rc = 0;
@@ -998,12 +972,10 @@ static int mspro_block_init_card(struct 
 	int rc = 0;
 
 	msb->system = 0x80;
-	card->reg_addr = (struct ms_register_addr){
-		offsetof(struct mspro_register, status),
-		sizeof(struct ms_status_register),
-		offsetof(struct mspro_register, param),
-		sizeof(struct mspro_param_register)
-	};
+	card->reg_addr.r_offset = offsetof(struct mspro_register, status);
+	card->reg_addr.r_length = sizeof(struct ms_status_register);
+	card->reg_addr.w_offset = offsetof(struct mspro_register, param);
+	card->reg_addr.w_length = sizeof(struct mspro_param_register);
 
 	if (memstick_set_rw_addr(card))
 		return -EIO;
@@ -1046,6 +1018,7 @@ static int mspro_block_init_disk(struct 
 	struct memstick_host *host = card->host;
 	struct mspro_devinfo *dev_info = NULL;
 	struct mspro_sys_info *sys_info = NULL;
+	struct mspro_sys_attr *s_attr = NULL;
 	int rc, disk_id;
 	u64 limit = BLK_BOUNCE_HIGH;
 	unsigned long capacity;
@@ -1053,13 +1026,13 @@ static int mspro_block_init_disk(struct 
 	if (host->cdev.dev->dma_mask && *(host->cdev.dev->dma_mask))
 		limit = *(host->cdev.dev->dma_mask);
 
-	for (rc = 0; rc < msb->attr_count; rc++) {
-		if (msb->attributes[rc].id == MSPRO_BLOCK_ID_DEVINFO)
-			dev_info = (struct mspro_devinfo *)msb->attributes[rc]
-							       .data;
-		if (msb->attributes[rc].id == MSPRO_BLOCK_ID_SYSINFO)
-			sys_info = (struct mspro_sys_info *)msb->attributes[rc]
-								.data;
+	for (rc = 0; msb->attr_group.attrs[rc]; ++rc) {
+		s_attr = mspro_from_sysfs_attr(msb->attr_group.attrs[rc]);
+
+		if (s_attr->id == MSPRO_BLOCK_ID_DEVINFO)
+			dev_info = s_attr->data;
+		else if (s_attr->id == MSPRO_BLOCK_ID_SYSINFO)
+			sys_info = s_attr->data;
 	}
 
 	if (!dev_info || !sys_info)
@@ -1150,11 +1123,18 @@ out_release_id:
 static void mspro_block_data_clear(struct mspro_block_data *msb)
 {
 	int cnt;
+	struct mspro_sys_attr *s_attr;
 
-	for (cnt = 0; cnt < msb->attr_count; cnt++)
-		kfree(msb->attributes[cnt].data);
+	if (msb->attr_group.attrs) {
+		for (cnt = 0; msb->attr_group.attrs[cnt]; ++cnt) {
+			s_attr = mspro_from_sysfs_attr(msb->attr_group
+							   .attrs[cnt]);
+			kfree(s_attr->data);
+			kfree(s_attr);
+		}
+		kfree(msb->attr_group.attrs);
+	}
 
-	kfree(msb->attributes);
 	msb->card = NULL;
 }
 
@@ -1181,7 +1161,7 @@ static int mspro_block_probe(struct mems
 	if (rc)
 		goto out_free;
 
-	rc = mspro_block_sysfs_register(card);
+	rc = sysfs_create_group(&card->dev.kobj, &msb->attr_group);
 	if (rc)
 		goto out_free;
 
@@ -1191,7 +1171,7 @@ static int mspro_block_probe(struct mems
 		return 0;
 	}
 
-	mspro_block_sysfs_unregister(card);
+	sysfs_remove_group(&card->dev.kobj, &msb->attr_group);
 out_free:
 	memstick_set_drvdata(card, NULL);
 	mspro_block_data_clear(msb);
@@ -1223,7 +1203,7 @@ static void mspro_block_remove(struct me
 
 	blk_cleanup_queue(msb->queue);
 
-	mspro_block_sysfs_unregister(card);
+	sysfs_remove_group(&card->dev.kobj, &msb->attr_group);
 
 	mutex_lock(&mspro_block_disk_lock);
 	mspro_block_data_clear(msb);
@@ -1264,6 +1244,7 @@ static int mspro_block_resume(struct mem
 
 	struct mspro_block_data *new_msb;
 	struct memstick_host *host = card->host;
+	struct mspro_sys_attr s_attr, r_attr;
 	unsigned char cnt;
 
 	mutex_lock(&host->lock);
@@ -1278,13 +1259,18 @@ static int mspro_block_resume(struct mem
 	if (mspro_block_init_card(card))
 		goto out_free;
 
-	for (cnt = 0; cnt < new_msb->attr_count; cnt++) {
-		if (new_msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO
-		    && cnt < msb->attr_count
-		    && msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO) {
-			if (memcmp(new_msb->attributes[cnt].data,
-				   msb->attributes[cnt].data,
-				   msb->attributes[cnt].size))
+	for (cnt = 0; new_msb->attr_group.attrs[cnt]
+		      && msb->attr_group.attrs[cnt]; ++cnt) {
+		s_attr = container_of(new_msb->attr_group.attrs[cnt],
+				      struct mspro_sys_attr,
+				      dev_attr);
+		r_attr = container_of(msb->attr_group.attrs[cnt],
+				      struct mspro_sys_attr,
+				      dev_attr);
+
+		if (s_attr->id == MSPRO_BLOCK_ID_SYSINFO
+		    && r_attr->id == s_attr->id) {
+			if (memcmp(s_attr->data, r_attr->data, s_attr->size))
 				break;
 
 			memstick_set_drvdata(card, msb);
diff -puN include/linux/memstick.h~updates-for-the-memstick-driver include/linux/memstick.h
--- a/include/linux/memstick.h~updates-for-the-memstick-driver
+++ a/include/linux/memstick.h
@@ -13,6 +13,10 @@
 #define _MEMSTICK_H
 
 #include <linux/workqueue.h>
+#include <linux/scatterlist.h>
+#include <linux/device.h>
+
+/*** Hardware based structures ***/
 
 struct ms_status_register {
 	unsigned char reserved;
@@ -151,6 +155,8 @@ enum {
 */
 };
 
+/*** Driver structures and functions ***/
+
 #define MEMSTICK_PART_SHIFT 3
 
 enum memstick_param { MEMSTICK_POWER = 1, MEMSTICK_INTERFACE };
@@ -212,7 +218,9 @@ struct memstick_dev {
 	struct completion        mrq_complete;
 	struct memstick_request  current_mrq;
 
+	/* Check that media driver is still willing to operate the device. */
 	int                      (*check)(struct memstick_dev *card);
+	/* Get next request from the media driver.                         */
 	int                      (*next_request)(struct memstick_dev *card,
 						 struct memstick_request **mrq);
 
@@ -232,7 +240,9 @@ struct memstick_host {
 	struct memstick_dev *card;
 	unsigned int        retries;
 
+	/* Notify the host that some requests are pending. */
 	void                (*request)(struct memstick_host *host);
+	/* Set host IO parameters (power, clock, etc).     */
 	void                (*set_param)(struct memstick_host *host,
 					 enum memstick_param param,
 					 int value);
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-initial-commit-for-sony-memorystick-support.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
updates-for-the-memstick-driver.patch
