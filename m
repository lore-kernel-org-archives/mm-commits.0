From: akpm@linux-foundation.org
Subject: - vmscan-set-try_to_release_pages-gfp_mask-to-0.patch removed from -mm tree
Date: Wed, 15 Oct 2008 19:53:41 -0700
Message-ID: <200810160253.m9G2rgN2013142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbYJPCxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 22:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: set try_to_release_page's gfp_mask to 0
has been removed from the -mm tree.  Its filename was
     vmscan-set-try_to_release_pages-gfp_mask-to-0.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: set try_to_release_page's gfp_mask to 0
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

shrink_page_list() passes a gfp_mask to try_to_release_page.  When
shrink_page_list is called from kswapd or buddy system, gfp_mask is set
and (gfp_mask & __GFP_WAIT) and (gfp_mask & __GFP_FS) check is positive. 
releasepage of jbd/jbd2(ext3/4, ocfs2) and XFS use this parameter.

If try_to_free_page fails due to bh busy in jbd/jbd2, jbd/jbd2 lets a
thread wait for committing transaction.  I think this has big performance
impacts for vmscan.  So I modified shrink_page_list not to pass gfp_mask
to try_to_release_page in ordered to improve vmscan performance.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-set-try_to_release_pages-gfp_mask-to-0 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-set-try_to_release_pages-gfp_mask-to-0
+++ a/mm/vmscan.c
@@ -663,7 +663,7 @@ static unsigned long shrink_page_list(st
 		 * Otherwise, leave the page on the LRU so it is swappable.
 		 */
 		if (PagePrivate(page)) {
-			if (!try_to_release_page(page, sc->gfp_mask))
+			if (!try_to_release_page(page, 0))
 				goto activate_locked;
 			if (!mapping && page_count(page) == 1) {
 				unlock_page(page);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

vmscan-set-try_to_release_pages-gfp_mask-to-0.patch

