From: akpm@linux-foundation.org
Subject: [merged] gru-add-comments-raised-in-previous-code-reviews.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:11 -0800
Message-ID: <200912162040.nBGKeBNx013590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965002AbZLPUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add comments raised in previous code reviews
has been removed from the -mm tree.  Its filename was
     gru-add-comments-raised-in-previous-code-reviews.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add comments raised in previous code reviews
From: Jack Steiner <steiner@sgi.com>

Add comments from previous code reviews.  The comments help explain some
of the more esoteric aspects of the driver.

Move a free() to the other side of an unlock.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |    5 +++++
 drivers/misc/sgi-gru/grukservices.c |    4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-comments-raised-in-previous-code-reviews drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-comments-raised-in-previous-code-reviews
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -733,6 +733,11 @@ long gru_get_gseg_statistics(unsigned lo
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
+	/*
+	 * The library creates arrays of contexts for threaded programs.
+	 * If no gts exists in the array, the context has never been used & all
+	 * statistics are implicitly 0.
+	 */
 	gts = gru_find_lock_gts(req.gseg);
 	if (gts) {
 		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-add-comments-raised-in-previous-code-reviews drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-add-comments-raised-in-previous-code-reviews
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -200,13 +200,15 @@ static int gru_free_kernel_contexts(void
 		bs = gru_base[bid];
 		if (!bs)
 			continue;
+
+		/* Ignore busy contexts. Don't want to block here.  */
 		if (down_write_trylock(&bs->bs_kgts_sema)) {
 			kgts = bs->bs_kgts;
 			if (kgts && kgts->ts_gru)
 				gru_unload_context(kgts, 0);
-			kfree(kgts);
 			bs->bs_kgts = NULL;
 			up_write(&bs->bs_kgts_sema);
+			kfree(kgts);
 		} else {
 			ret++;
 		}
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

