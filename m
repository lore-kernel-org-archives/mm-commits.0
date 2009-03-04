From: akpm@linux-foundation.org
Subject: + powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:49:02 -0800
Message-ID: <200903042149.n24Ln3cj006578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbZCDVtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, benh@kernel.crashing.org, roel.kluin@gmail.com


The patch titled
     powerpc/spufs: check file offset before calculating write size in fixed-sized files
has been added to the -mm tree.  Its filename is
     powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch

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
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch

