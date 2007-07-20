From: akpm@linux-foundation.org
Subject: + spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:50:51 -0700
Message-ID: <200707201850.l6KIopU4010856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632AbXGTSvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     spufs: make signal-notification files readonly for NOSCHED contexts
has been added to the -mm tree.  Its filename is
     spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: make signal-notification files readonly for NOSCHED contexts
From: Jeremy Kerr <jk@ozlabs.org>

Reading from the signal{1,2} files requires a spu_acquire_saved, so make these
files write-only for contexts created with SPU_CREATE_NOSCHED.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-make-signal-notification-files-readonly-for-nosched-contexts arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-make-signal-notification-files-readonly-for-nosched-contexts
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -934,6 +934,13 @@ static const struct file_operations spuf
 	.mmap = spufs_signal1_mmap,
 };
 
+static const struct file_operations spufs_signal1_nosched_fops = {
+	.open = spufs_signal1_open,
+	.release = spufs_signal1_release,
+	.write = spufs_signal1_write,
+	.mmap = spufs_signal1_mmap,
+};
+
 static int spufs_signal2_open(struct inode *inode, struct file *file)
 {
 	struct spufs_inode_info *i = SPUFS_I(inode);
@@ -1062,6 +1069,13 @@ static const struct file_operations spuf
 	.mmap = spufs_signal2_mmap,
 };
 
+static const struct file_operations spufs_signal2_nosched_fops = {
+	.open = spufs_signal2_open,
+	.release = spufs_signal2_release,
+	.write = spufs_signal2_write,
+	.mmap = spufs_signal2_mmap,
+};
+
 static void spufs_signal1_type_set(void *data, u64 val)
 {
 	struct spu_context *ctx = data;
@@ -2184,8 +2198,8 @@ struct tree_descr spufs_dir_nosched_cont
 	{ "mbox_stat", &spufs_mbox_stat_fops, 0444, },
 	{ "ibox_stat", &spufs_ibox_stat_fops, 0444, },
 	{ "wbox_stat", &spufs_wbox_stat_fops, 0444, },
-	{ "signal1", &spufs_signal1_fops, 0666, },
-	{ "signal2", &spufs_signal2_fops, 0666, },
+	{ "signal1", &spufs_signal1_nosched_fops, 0222, },
+	{ "signal2", &spufs_signal2_nosched_fops, 0222, },
 	{ "signal1_type", &spufs_signal1_type, 0666, },
 	{ "signal2_type", &spufs_signal2_type, 0666, },
 	{ "mss", &spufs_mss_fops, 0666, },
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch
spufs-avoid-unexpectedly-restaring-mfc-during-context-save.patch
spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch
spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts.patch
spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch
spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch
spufs-fix-array-size-of-channel-index.patch
spufs-remove-needless-context-save-restore-code.patch
spufs-fix-decr_status-meanings.patch
spufs-fix-read-and-write-for-decr_status-file.patch
spufs-limit-saving-mfc_cntl-bits.patch
spufs-dont-halt-decrementer-at-restore-step-47.patch
spufs-change-decrementer-restore-timing.patch
spufs-remove-unused-file-argument-from-spufs_run_spu.patch
spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch
