From: akpm@linux-foundation.org
Subject: + w1-be-able-to-manually-add-and-remove-slaves.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:09 -0700
Message-ID: <200807310316.m6V3G90e001149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730AbYGaDSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: be able to manually add and remove slaves
has been added to the -mm tree.  Its filename is
     w1-be-able-to-manually-add-and-remove-slaves.patch

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
Subject: W1: be able to manually add and remove slaves
From: David Fries <david@fries.net>

sysfs entries were added to manually add and remove slave devices.  This
is useful if the automatic bus searching is disabled, and the device ids
are already known.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |  137 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 136 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1.c~w1-be-able-to-manually-add-and-remove-slaves drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-be-able-to-manually-add-and-remove-slaves
+++ a/drivers/w1/w1.c
@@ -56,6 +56,8 @@ module_param_named(slave_ttl, w1_max_sla
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
 
+static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn);
+
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -357,7 +359,8 @@ static ssize_t w1_master_attribute_show_
 	return count;
 }
 
-static ssize_t w1_master_attribute_show_slaves(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t w1_master_attribute_show_slaves(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
 	struct w1_master *md = dev_to_w1_master(dev);
 	int c = PAGE_SIZE;
@@ -382,6 +385,134 @@ static ssize_t w1_master_attribute_show_
 	return PAGE_SIZE - c;
 }
 
+static ssize_t w1_master_attribute_show_add(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c = PAGE_SIZE;
+	c -= snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to add slave\n");
+	return PAGE_SIZE - c;
+}
+
+static int w1_atoreg_num(struct device *dev, const char *buf, size_t count,
+	struct w1_reg_num *rn)
+{
+	unsigned int family;
+	u64 id;
+	int i;
+	u64 rn64_le;
+	/* The CRC value isn't read from the user because the sysfs directory
+	 * doesn't include it and most messages from the bus search don't
+	 * print it either.  It would be unreasonable for the user to then
+	 * provide it.
+	 */
+	const char *error_msg = "bad slave string format, expecting "
+		"ff-dddddddddddd\n";
+
+	if (buf[2] != '-') {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	i = sscanf(buf, "%02x-%012llx", &family, &id);
+	if (i != 2) {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	rn->family = family;
+	rn->id = id;
+
+	rn64_le = cpu_to_le64(*(u64 *)rn);
+	rn->crc = w1_calc_crc8((u8 *)&rn64_le, 7);
+
+	#if 0
+	dev_info(dev, "With CRC device is %02x.%012llx.%02x.\n",
+		  rn->family, (unsigned long long)rn->id, rn->crc);
+	#endif
+
+	return 0;
+}
+
+/* Searches the slaves in the w1_master and returns a pointer or NULL.
+ * Note: must hold the mutex
+ */
+static struct w1_slave *w1_slave_search_device(struct w1_master *dev,
+	struct w1_reg_num *rn)
+{
+	struct w1_slave *sl;
+	list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
+		if (sl->reg_num.family == rn->family &&
+				sl->reg_num.id == rn->id &&
+				sl->reg_num.crc == rn->crc) {
+			return sl;
+		}
+	}
+	return NULL;
+}
+
+static ssize_t w1_master_attribute_store_add(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md = dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result = count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl = w1_slave_search_device(md, &rn);
+	/* It would be nice to do a targeted search one the one-wire bus
+	 * for the new device to see if it is out there or not.  But the
+	 * current search doesn't support that.
+	 */
+	if (sl) {
+		dev_info(dev, "Device %s already exists\n", sl->name);
+		result = -EINVAL;
+	} else {
+		w1_attach_slave_device(md, &rn);
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
+static ssize_t w1_master_attribute_show_remove(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c = PAGE_SIZE;
+	c -= snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to remove slave\n");
+	return PAGE_SIZE - c;
+}
+
+static ssize_t w1_master_attribute_store_remove(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md = dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result = count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl = w1_slave_search_device(md, &rn);
+	if (sl) {
+		w1_slave_detach(sl);
+	} else {
+		dev_info(dev, "Device %02x-%012llx doesn't exists\n", rn.family,
+			(unsigned long long)rn.id);
+		result = -EINVAL;
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
 #define W1_MASTER_ATTR_RO(_name, _mode)				\
 	struct device_attribute w1_master_attribute_##_name =	\
 		__ATTR(w1_master_##_name, _mode,		\
@@ -402,6 +533,8 @@ static W1_MASTER_ATTR_RO(timeout, S_IRUG
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
 static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
 static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUGO);
 
 static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_name.attr,
@@ -413,6 +546,8 @@ static struct attribute *w1_master_defau
 	&w1_master_attribute_pointer.attr,
 	&w1_master_attribute_search.attr,
 	&w1_master_attribute_pullup.attr,
+	&w1_master_attribute_add.attr,
+	&w1_master_attribute_remove.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from david@fries.net are

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

