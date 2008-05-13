From: akpm@linux-foundation.org
Subject: - fix-misuses-of-bdevname.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:14 -0700
Message-ID: <200805132134.m4DLYEc0000902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760778AbYEMVex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, axboe@kernel.dk, sct@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix misuses of bdevname()
has been removed from the -mm tree.  Its filename was
     fix-misuses-of-bdevname.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix misuses of bdevname()
From: Jean Delvare <khali@linux-fr.org>

bdevname() fills the buffer that it is given as a parameter, so calling
strcpy() or snprintf() on the returned value is redundant (and probably not
guaranteed to work - I don't think strcpy and snprintf support overlapping
buffers.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blktrace.c     |    2 +-
 block/compat_ioctl.c |    2 +-
 fs/ext4/mballoc.c    |    6 ++----
 fs/jbd2/journal.c    |    4 ++--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff -puN block/blktrace.c~fix-misuses-of-bdevname block/blktrace.c
--- a/block/blktrace.c~fix-misuses-of-bdevname
+++ a/block/blktrace.c
@@ -476,7 +476,7 @@ int blk_trace_ioctl(struct block_device 
 
 	switch (cmd) {
 	case BLKTRACESETUP:
-		strcpy(b, bdevname(bdev, b));
+		bdevname(bdev, b);
 		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
 		break;
 	case BLKTRACESTART:
diff -puN block/compat_ioctl.c~fix-misuses-of-bdevname block/compat_ioctl.c
--- a/block/compat_ioctl.c~fix-misuses-of-bdevname
+++ a/block/compat_ioctl.c
@@ -555,7 +555,7 @@ static int compat_blk_trace_setup(struct
 	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
 		return -EFAULT;
 
-	strcpy(b, bdevname(bdev, b));
+	bdevname(bdev, b);
 
 	buts = (struct blk_user_trace_setup) {
 		.act_mask = cbuts.act_mask,
diff -puN fs/ext4/mballoc.c~fix-misuses-of-bdevname fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~fix-misuses-of-bdevname
+++ a/fs/ext4/mballoc.c
@@ -2639,8 +2639,7 @@ static int ext4_mb_init_per_dev_proc(str
 	struct proc_dir_entry *proc;
 	char devname[64];
 
-	snprintf(devname, sizeof(devname) - 1, "%s",
-		bdevname(sb->s_bdev, devname));
+	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
@@ -2674,8 +2673,7 @@ static int ext4_mb_destroy_per_dev_proc(
 	if (sbi->s_mb_proc == NULL)
 		return -EINVAL;
 
-	snprintf(devname, sizeof(devname) - 1, "%s",
-		bdevname(sb->s_bdev, devname));
+	bdevname(sb->s_bdev, devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
diff -puN fs/jbd2/journal.c~fix-misuses-of-bdevname fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~fix-misuses-of-bdevname
+++ a/fs/jbd2/journal.c
@@ -901,7 +901,7 @@ static void jbd2_stats_proc_init(journal
 {
 	char name[BDEVNAME_SIZE];
 
-	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
+	bdevname(journal->j_dev, name);
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
 		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
@@ -915,7 +915,7 @@ static void jbd2_stats_proc_exit(journal
 {
 	char name[BDEVNAME_SIZE];
 
-	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
+	bdevname(journal->j_dev, name);
 	remove_proc_entry("info", journal->j_proc_entry);
 	remove_proc_entry("history", journal->j_proc_entry);
 	remove_proc_entry(name, proc_jbd2_stats);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-gfs2-nmw.patch

