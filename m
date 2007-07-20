From: akpm@linux-foundation.org
Subject: + spufs-remove-unused-file-argument-from-spufs_run_spu.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:51:13 -0700
Message-ID: <200707201851.l6KIpDKB010898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbXGTSvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbe-oss-dev@ml.breakpoint.cc, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, sebastian@breakpoint.cc


The patch titled
     spufs: remove unused file argument from spufs_run_spu()
has been added to the -mm tree.  Its filename is
     spufs-remove-unused-file-argument-from-spufs_run_spu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: remove unused file argument from spufs_run_spu()
From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>

The 'file' argument is unused in spufs_run_spu().  This change removes it.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/run.c      |    3 +--
 arch/powerpc/platforms/cell/spufs/spufs.h    |    3 +--
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/run.c~spufs-remove-unused-file-argument-from-spufs_run_spu arch/powerpc/platforms/cell/spufs/run.c
--- a/arch/powerpc/platforms/cell/spufs/run.c~spufs-remove-unused-file-argument-from-spufs_run_spu
+++ a/arch/powerpc/platforms/cell/spufs/run.c
@@ -297,8 +297,7 @@ static inline int spu_process_events(str
 	return ret;
 }
 
-long spufs_run_spu(struct file *file, struct spu_context *ctx,
-		   u32 *npc, u32 *event)
+long spufs_run_spu(struct spu_context *ctx, u32 *npc, u32 *event)
 {
 	int ret;
 	struct spu *spu;
diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~spufs-remove-unused-file-argument-from-spufs_run_spu arch/powerpc/platforms/cell/spufs/spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~spufs-remove-unused-file-argument-from-spufs_run_spu
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -188,8 +188,7 @@ extern struct tree_descr spufs_dir_conte
 extern struct tree_descr spufs_dir_nosched_contents[];
 
 /* system call implementation */
-long spufs_run_spu(struct file *file,
-		   struct spu_context *ctx, u32 *npc, u32 *status);
+long spufs_run_spu(struct spu_context *ctx, u32 *npc, u32 *status);
 long spufs_create(struct nameidata *nd,
 			 unsigned int flags, mode_t mode);
 extern const struct file_operations spufs_context_fops;
diff -puN arch/powerpc/platforms/cell/spufs/syscalls.c~spufs-remove-unused-file-argument-from-spufs_run_spu arch/powerpc/platforms/cell/spufs/syscalls.c
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c~spufs-remove-unused-file-argument-from-spufs_run_spu
+++ a/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -47,7 +47,7 @@ static long do_spu_run(struct file *filp
 		goto out;
 
 	i = SPUFS_I(filp->f_path.dentry->d_inode);
-	ret = spufs_run_spu(filp, i->i_ctx, &npc, &status);
+	ret = spufs_run_spu(i->i_ctx, &npc, &status);
 
 	if (put_user(npc, unpc))
 		ret = -EFAULT;
_

Patches currently in -mm which might be from cbe-oss-dev@ml.breakpoint.cc are

spufs-remove-unused-file-argument-from-spufs_run_spu.patch
