From: akpm@linux-foundation.org
Subject: [merged] powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:30 -0700
Message-ID: <200903301905.n2UJ5UuW018672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757866AbZC3TJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, benh@kernel.crashing.org, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     powerpc/spufs: check file offset before calculating write size in fixed-sized files
has been removed from the -mm tree.  Its filename was
     powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/spufs: check file offset before calculating write size in fixed-sized files
From: Jeremy Kerr <jk@ozlabs.org>

Based on an original patch from Roel Kluin.

The write size calculated during regs and fpcr writes may currently
go negative. Because size is unsigned, this will wrap, and our
check for EFBIG will fail.

Instead, do the check for EFBIG before subtracting from size.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roel Kluin <roel.kluin@gmail.com>.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -568,9 +568,10 @@ spufs_regs_write(struct file *file, cons
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	int ret;
 
-	size = min_t(ssize_t, sizeof lscsa->gprs - *pos, size);
-	if (size <= 0)
+	if (*pos >= sizeof(lscsa->gprs))
 		return -EFBIG;
+
+	size = min_t(ssize_t, sizeof(lscsa->gprs) - *pos, size);
 	*pos += size;
 
 	ret = spu_acquire_saved(ctx);
@@ -623,10 +624,11 @@ spufs_fpcr_write(struct file *file, cons
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	int ret;
 
-	size = min_t(ssize_t, sizeof(lscsa->fpcr) - *pos, size);
-	if (size <= 0)
+	if (*pos >= sizeof(lscsa->fpcr))
 		return -EFBIG;
 
+	size = min_t(ssize_t, sizeof(lscsa->fpcr) - *pos, size);
+
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from jk@ozlabs.org are

linux-next.patch

