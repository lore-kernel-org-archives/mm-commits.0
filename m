From: akpm@linux-foundation.org
Subject: [nacked] ramoops-add-debugfs-entry.patch removed from -mm tree
Date: Tue, 26 Jul 2011 14:23:14 -0700
Message-ID: <201107262123.p6QLNFBI009854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab1GZVXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 17:23:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergiu@chromium.org, Artem.Bityutskiy@nokia.com, darwish.07@gmail.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ramoops: add debugfs entry
has been removed from the -mm tree.  Its filename was
     ramoops-add-debugfs-entry.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramoops: add debugfs entry
From: Sergiu Iordache <sergiu@chromium.org>

While ramoops writes to ram, accessing the dump requires using /dev/mem
and knowing the memory location (or a similar solution).  This patch
provides a debugfs interface through which the respective memory area can
be easily accessed.

The entry added is /sys/kernel/debug/ramoops/next

The entry returns a dump of size record_size each time, skipping invalid
dumps.  When it reaches the end of the memory area reserved for dumps it
returns an empty record and resets the current record count.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |  113 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 2 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-add-debugfs-entry drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-add-debugfs-entry
+++ a/drivers/char/ramoops.c
@@ -30,9 +30,13 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/ramoops.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
+#define RAMOOPS_DIR "ramoops"
+#define RAMOOPS_NEXT "next"
 
 static ulong record_size = MIN_MEM_SIZE;
 module_param(record_size, ulong, 0400);
@@ -61,12 +65,81 @@ static struct ramoops_context {
 	unsigned long size;
 	unsigned long record_size;
 	int dump_oops;
+	int current_entry;
 	int count;
 	int max_count;
 } oops_cxt;
 
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
+static DEFINE_MUTEX(ramoops_mutex);
+
+/* Debugfs entries for ramoops */
+static struct dentry *ramoops_dir, *ramoops_next_entry;
+
+/*
+ * Entry to have access to the memory logged by ramoops. The way the data
+ * is returned is as follows:
+ * Data records are checked one by one for the existence of the header.
+ * If a valid record is found data is returned from it, otherwise it is
+ * skipped.
+ * Once all the records are checked the next call after the last record
+ * will return an empty buffer and the counter is reset.
+ */
+static ssize_t ramoops_read_next(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+
+	mutex_lock(&ramoops_mutex);
+
+	/* Do this check here so it returns an empty file once it resets */
+	if (cxt->current_entry >= cxt->max_count) {
+		cxt->current_entry = 0;
+		count = 0;
+		goto out;
+	}
+
+	/* Check to see if the current dump is valid */
+	while (cxt->current_entry < cxt->max_count
+		&& memcmp(cxt->virt_addr + cxt->record_size *
+			  cxt->current_entry, RAMOOPS_KERNMSG_HDR,
+			  strlen(RAMOOPS_KERNMSG_HDR)))
+		cxt->current_entry++;
+
+	/* In case a dump was not found return 0 */
+	if (cxt->current_entry >= cxt->max_count) {
+		count = 0;
+		goto out;
+	}
+
+	/* Otherwise proceed as normal to return the data */
+	if (*ppos + count > cxt->record_size)
+		count = cxt->record_size - *ppos;
+	if (*ppos > cxt->record_size) {
+		count = 0;
+		cxt->current_entry++;
+		goto out;
+	}
+	if (copy_to_user(buf, cxt->virt_addr + cxt->record_size *
+			 cxt->current_entry + *ppos, count)) {
+		count = -EFAULT;
+		goto out;
+	}
+	*ppos += count;
+
+	/* completed reading this part, go to the next one */
+	if (*ppos == cxt->record_size)
+		cxt->current_entry++;
+
+out:
+	mutex_unlock(&ramoops_mutex);
+	return count;
+}
+
+static const struct file_operations ramoops_next_fops = {
+	.read = ramoops_read_next,
+};
 
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
@@ -88,6 +161,7 @@ static void ramoops_do_dump(struct kmsg_
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
+	mutex_lock(&ramoops_mutex);
 	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
 	buf_orig = buf;
 
@@ -109,6 +183,7 @@ static void ramoops_do_dump(struct kmsg_
 	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
 
 	cxt->count = (cxt->count + 1) % cxt->max_count;
+	mutex_unlock(&ramoops_mutex);
 }
 
 static int __init ramoops_probe(struct platform_device *pdev)
@@ -127,8 +202,8 @@ static int __init ramoops_probe(struct p
 	rounddown_pow_of_two(pdata->record_size);
 
 	/* Check for the minimum memory size */
-	if (pdata->mem_size < MIN_MEM_SIZE &&
-			pdata->record_size < MIN_MEM_SIZE) {
+	if (pdata->mem_size < MIN_MEM_SIZE
+	    && pdata->record_size < MIN_MEM_SIZE) {
 		pr_err("memory size too small, minium is %lu\n", MIN_MEM_SIZE);
 		goto fail3;
 	}
@@ -144,6 +219,7 @@ static int __init ramoops_probe(struct p
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
+	cxt->current_entry = 0;
 	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
@@ -165,6 +241,30 @@ static int __init ramoops_probe(struct p
 		goto fail1;
 	}
 
+	/* Initialize debugfs entry so the memory can be easily accessed */
+	ramoops_dir = debugfs_create_dir(RAMOOPS_DIR, NULL);
+	if (ramoops_dir == NULL) {
+		err = -ENOMEM;
+		pr_err("debugfs directory entry creation failed\n");
+		goto out;
+	}
+
+	/*
+	 * This interface exposes the next valid entry from ramoops, starting
+	 * from the start of memory area. Once there are no more entries it
+	 * returns an empty buffer. Reading the entry again afterwards starts
+	 * from the begining.
+	 */
+	ramoops_next_entry = debugfs_create_file(RAMOOPS_NEXT, 0444,
+					ramoops_dir, NULL, &ramoops_next_fops);
+
+	if (ramoops_next_entry == NULL) {
+		err = -ENOMEM;
+		pr_err("debugfs next entry creation failed\n");
+		goto no_ramoops_next;
+	}
+
+
 	return 0;
 
 fail1:
@@ -173,6 +273,11 @@ fail2:
 	release_mem_region(cxt->phys_addr, cxt->size);
 fail3:
 	return err;
+
+no_ramoops_next:
+	debugfs_remove(ramoops_dir);
+out:
+	return err;
 }
 
 static int __exit ramoops_remove(struct platform_device *pdev)
@@ -230,6 +335,10 @@ static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
 	kfree(dummy_data);
+
+	/* Clean up debugfs entries */
+	debugfs_remove(ramoops_next_entry);
+	debugfs_remove(ramoops_dir);
 }
 
 module_init(ramoops_init);
_

Patches currently in -mm which might be from sergiu@chromium.org are

ramoops-move-dump_oops-into-platform-data.patch
ramoops-make-record_size-a-module-parameter.patch

