From: akpm@linux-foundation.org
Subject: + mmc_test-move-files-from-sysfs-to-debugfs.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:35:08 -0700
Message-ID: <201009102335.o8ANZ8ZB009481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab0IJXfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, adrian.hunter@nokia.com, cjb@laptop.org, ext-andriy.shevchenko@nokia.com, greg@kroah.com


The patch titled
     mmc_test: move files from sysfs to debugfs
has been added to the -mm tree.  Its filename is
     mmc_test-move-files-from-sysfs-to-debugfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_test: move files from sysfs to debugfs
From: Andy Shevchenko <andy.shevchenko@gmail.com>

As proposed by Greg it is more logical to keep files for the mmc_test
driver under debugfs.

Additionally this patch brings seq_file API for show() method.  It allows
to write unlimited data to the file.

Example of usage:
  # mount -t debugfs none /sys/kernel/debug
  # modprobe mmc_test
    [  581.395843] mmc_test mmc0:0001: Card claimed for testing.
  # echo 25 > /sys/kernel/debug/mmc0/mmc0\:0001/test
    [  604.568542] mmc0: Starting tests of card mmc0:0001...
    [  604.582733] mmc0: Test case 25. Best-case read performance into scattered pages...
    [  604.923553] mmc0: Transfer of 8192 sectors (4096 KiB) took 0.124664314 seconds (33644 kB/s, 32856 KiB/s)
    [  604.933227] mmc0: Result: OK
    [  604.936248] mmc0: Tests completed.
  # cat /sys/kernel/debug/mmc0/mmc0\:0001/test
    Test 25: 0
    1 8192 0.124664314 33644784

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg KH <greg@kroah.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |  142 +++++++++++++++++++++++++---------
 1 file changed, 107 insertions(+), 35 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-move-files-from-sysfs-to-debugfs drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-move-files-from-sysfs-to-debugfs
+++ a/drivers/mmc/card/mmc_test.c
@@ -19,6 +19,10 @@
 #include <linux/swap.h>		/* For nr_free_buffer_pages() */
 #include <linux/list.h>
 
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
+#include <linux/seq_file.h>
+
 #define RESULT_OK		0
 #define RESULT_FAIL		1
 #define RESULT_UNSUP_HOST	2
@@ -106,6 +110,18 @@ struct mmc_test_general_result {
 };
 
 /**
+ * struct mmc_test_dbgfs_file - debugfs related file.
+ * @link: double-linked list
+ * @card: card under test
+ * @file: file created under debugfs
+ */
+struct mmc_test_dbgfs_file {
+	struct list_head link;
+	struct mmc_card *card;
+	struct dentry *file;
+};
+
+/**
  * struct mmc_test_card - test information.
  * @card: card under test
  * @scratch: transfer buffer
@@ -2037,14 +2053,12 @@ static void mmc_test_free_result(struct 
 	mutex_unlock(&mmc_test_lock);
 }
 
-static ssize_t mmc_test_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static LIST_HEAD(mmc_test_file_test);
+
+static int mtf_test_show(struct seq_file *sf, void *data)
 {
-	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_general_result *gr;
-	char *p = buf;
-	size_t len = PAGE_SIZE;
-	int ret;
 
 	mutex_lock(&mmc_test_lock);
 
@@ -2054,49 +2068,44 @@ static ssize_t mmc_test_show(struct devi
 		if (gr->card != card)
 			continue;
 
-		ret = snprintf(p, len, "Test %d: %d\n", gr->testcase + 1,
-			gr->result);
-		if (ret < 0)
-			goto err;
-		if (ret >= len) {
-			ret = -ENOBUFS;
-			goto err;
-		}
-		p += ret;
-		len -= ret;
+		seq_printf(sf, "Test %d: %d\n", gr->testcase + 1, gr->result);
 
 		list_for_each_entry(tr, &gr->tr_lst, link) {
-			ret = snprintf(p, len, "%u %d %lu.%09lu %u\n",
+			seq_printf(sf, "%u %d %lu.%09lu %u\n",
 				tr->count, tr->sectors,
 				(unsigned long)tr->ts.tv_sec,
 				(unsigned long)tr->ts.tv_nsec,
 				tr->rate);
-			if (ret < 0)
-				goto err;
-			if (ret >= len) {
-				ret = -ENOBUFS;
-				goto err;
-			}
-			p += ret;
-			len -= ret;
 		}
 	}
 
-	ret = PAGE_SIZE - len;
-err:
 	mutex_unlock(&mmc_test_lock);
 
-	return ret;
+	return 0;
+}
+
+static int mtf_test_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mtf_test_show, inode->i_private);
 }
 
-static ssize_t mmc_test_store(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t mtf_test_write(struct file *file, const char __user *buf,
+	size_t count, loff_t *pos)
 {
-	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct seq_file *sf = (struct seq_file *)file->private_data;
+	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_card *test;
+	char lbuf[12];
 	long testcase;
 
-	if (strict_strtol(buf, 10, &testcase))
+	if (count >= sizeof(lbuf))
+		return -EINVAL;
+
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+	lbuf[count] = '\0';
+
+	if (strict_strtol(lbuf, 10, &testcase))
 		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
@@ -2135,7 +2144,69 @@ static ssize_t mmc_test_store(struct dev
 	return count;
 }
 
-static DEVICE_ATTR(test, S_IWUSR | S_IRUGO, mmc_test_show, mmc_test_store);
+static const struct file_operations mmc_test_fops_test = {
+	.open		= mtf_test_open,
+	.read		= seq_read,
+	.write		= mtf_test_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void mmc_test_free_file_test(struct mmc_card *card)
+{
+	struct mmc_test_dbgfs_file *df, *dfs;
+
+	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry_safe(df, dfs, &mmc_test_file_test, link) {
+		if (card && df->card != card)
+			continue;
+		debugfs_remove(df->file);
+		list_del(&df->link);
+		kfree(df);
+	}
+
+	mutex_unlock(&mmc_test_lock);
+}
+
+static int mmc_test_register_file_test(struct mmc_card *card)
+{
+	struct dentry *file = NULL;
+	struct mmc_test_dbgfs_file *df;
+	int ret = 0;
+
+	mutex_lock(&mmc_test_lock);
+
+	if (card->debugfs_root)
+		file = debugfs_create_file("test", S_IWUSR | S_IRUGO,
+			card->debugfs_root, card, &mmc_test_fops_test);
+
+	if (IS_ERR_OR_NULL(file)) {
+		dev_err(&card->dev,
+			"Can't create file. Perhaps debugfs is disabled.\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	df = kmalloc(sizeof(struct mmc_test_dbgfs_file), GFP_KERNEL);
+	if (!df) {
+		debugfs_remove(file);
+		dev_err(&card->dev,
+			"Can't allocate memory for internal usage.\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	df->card = card;
+	df->file = file;
+
+	list_add(&df->link, &mmc_test_file_test);
+
+err:
+	mutex_unlock(&mmc_test_lock);
+
+	return ret;
+}
 
 static int mmc_test_probe(struct mmc_card *card)
 {
@@ -2144,7 +2215,7 @@ static int mmc_test_probe(struct mmc_car
 	if (!mmc_card_mmc(card) && !mmc_card_sd(card))
 		return -ENODEV;
 
-	ret = device_create_file(&card->dev, &dev_attr_test);
+	ret = mmc_test_register_file_test(card);
 	if (ret)
 		return ret;
 
@@ -2156,7 +2227,7 @@ static int mmc_test_probe(struct mmc_car
 static void mmc_test_remove(struct mmc_card *card)
 {
 	mmc_test_free_result(card);
-	device_remove_file(&card->dev, &dev_attr_test);
+	mmc_test_free_file_test(card);
 }
 
 static struct mmc_driver mmc_driver = {
@@ -2176,6 +2247,7 @@ static void __exit mmc_test_exit(void)
 {
 	/* Clear stalled data if card is still plugged */
 	mmc_test_free_result(NULL);
+	mmc_test_free_file_test(NULL);
 
 	mmc_unregister_driver(&mmc_driver);
 }
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-bitmapc-use-hex_to_bin.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch
mmc_test-use-api-to-check-card-type.patch
mmc_test-change-simple_strtol-to-strict_strtol.patch
mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch
mmc_test-move-files-from-sysfs-to-debugfs.patch

