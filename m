From: akpm@linux-foundation.org
Subject: - s390-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:09 -0700
Message-ID: <200804300547.m3U5l9NG029679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760519AbYD3GMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     s390-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd_proc.c |   10 +++++-----
 drivers/s390/char/tape_proc.c  |    7 +++----
 drivers/s390/cio/blacklist.c   |    7 ++-----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/s390/block/dasd_proc.c~s390-use-non-racy-method-for-proc-entries-creation drivers/s390/block/dasd_proc.c
--- a/drivers/s390/block/dasd_proc.c~s390-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/s390/block/dasd_proc.c
@@ -157,6 +157,7 @@ static int dasd_devices_open(struct inod
 }
 
 static const struct file_operations dasd_devices_file_ops = {
+	.owner		= THIS_MODULE,
 	.open		= dasd_devices_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -315,13 +316,12 @@ dasd_proc_init(void)
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
 	dasd_proc_root_entry->owner = THIS_MODULE;
-	dasd_devices_entry = create_proc_entry("devices",
-					       S_IFREG | S_IRUGO | S_IWUSR,
-					       dasd_proc_root_entry);
+	dasd_devices_entry = proc_create("devices",
+					 S_IFREG | S_IRUGO | S_IWUSR,
+					 dasd_proc_root_entry,
+					 &dasd_devices_file_ops);
 	if (!dasd_devices_entry)
 		goto out_nodevices;
-	dasd_devices_entry->proc_fops = &dasd_devices_file_ops;
-	dasd_devices_entry->owner = THIS_MODULE;
 	dasd_statistics_entry = create_proc_entry("statistics",
 						  S_IFREG | S_IRUGO | S_IWUSR,
 						  dasd_proc_root_entry);
diff -puN drivers/s390/char/tape_proc.c~s390-use-non-racy-method-for-proc-entries-creation drivers/s390/char/tape_proc.c
--- a/drivers/s390/char/tape_proc.c~s390-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/s390/char/tape_proc.c
@@ -111,6 +111,7 @@ static int tape_proc_open(struct inode *
 
 static const struct file_operations tape_proc_ops =
 {
+	.owner		= THIS_MODULE,
 	.open		= tape_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -124,14 +125,12 @@ void
 tape_proc_init(void)
 {
 	tape_proc_devices =
-		create_proc_entry ("tapedevices", S_IFREG | S_IRUGO | S_IWUSR,
-				   NULL);
+		proc_create("tapedevices", S_IFREG | S_IRUGO | S_IWUSR, NULL,
+			    &tape_proc_ops);
 	if (tape_proc_devices == NULL) {
 		PRINT_WARN("tape: Cannot register procfs entry tapedevices\n");
 		return;
 	}
-	tape_proc_devices->proc_fops = &tape_proc_ops;
-	tape_proc_devices->owner = THIS_MODULE;
 }
 
 /*
diff -puN drivers/s390/cio/blacklist.c~s390-use-non-racy-method-for-proc-entries-creation drivers/s390/cio/blacklist.c
--- a/drivers/s390/cio/blacklist.c~s390-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/s390/cio/blacklist.c
@@ -374,13 +374,10 @@ cio_ignore_proc_init (void)
 {
 	struct proc_dir_entry *entry;
 
-	entry = create_proc_entry ("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR,
-				   NULL);
+	entry = proc_create("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR, NULL,
+			    &cio_ignore_proc_fops);
 	if (!entry)
 		return -ENOENT;
-
-	entry->proc_fops = &cio_ignore_proc_fops;
