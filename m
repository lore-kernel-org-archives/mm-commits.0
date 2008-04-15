From: akpm@linux-foundation.org
Subject: + s390-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:23 -0700
Message-ID: <200804152356.m3FNuNtE022532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbYDOX4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     s390-use-non-racy-method-for-proc-entries-creation.patch

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
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

