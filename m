From: akpm@linux-foundation.org
Subject: - spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:47 -0700
Message-ID: <200707230934.l6N9YlUS016423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759463AbXGWJpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: make signal-notification files readonly for NOSCHED contexts
has been removed from the -mm tree.  Its filename was
     spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-make-signal-notification-files-readonly-for-nosched-contexts arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-make-signal-notification-files-readonly-for-nosched-contexts
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -941,6 +941,13 @@ static const struct file_operations spuf
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
@@ -1076,6 +1083,13 @@ static const struct file_operations spuf
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
@@ -2177,8 +2191,8 @@ struct tree_descr spufs_dir_contents[] =
 	{ "mbox_stat", &spufs_mbox_stat_fops, 0444, },
 	{ "ibox_stat", &spufs_ibox_stat_fops, 0444, },
 	{ "wbox_stat", &spufs_wbox_stat_fops, 0444, },
-	{ "signal1", &spufs_signal1_fops, 0666, },
-	{ "signal2", &spufs_signal2_fops, 0666, },
+	{ "signal1", &spufs_signal1_nosched_fops, 0222, },
+	{ "signal2", &spufs_signal2_nosched_fops, 0222, },
 	{ "signal1_type", &spufs_signal1_type, 0666, },
 	{ "signal2_type", &spufs_signal2_type, 0666, },
 	{ "cntl", &spufs_cntl_fops,  0666, },
_

Patches currently in -mm which might be from jk@ozlabs.org are
