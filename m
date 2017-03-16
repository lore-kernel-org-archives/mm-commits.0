From: akpm@linux-foundation.org
Subject: + mm-remove-swap_-fix.patch added to -mm tree
Date: Thu, 16 Mar 2017 12:45:21 -0700
Message-ID: <58caeb51.DgcpvIFSBGgghCRn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdCPTpW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 15:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use false instead of SWAP_FAIL
has been added to the -mm tree.  Its filename is
     mm-remove-swap_-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-swap_-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-swap_-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: use false instead of SWAP_FAIL

There was mistake with git-rebase.  SWAP_FAIL was removed.  Use false.  It
could be folded into mm-make-ttus-return-boolean.patch.

Link: http://lkml.kernel.org/r/20170316053313.GA19241@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-remove-swap_-fix mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap_-fix
+++ a/mm/rmap.c
@@ -1419,7 +1419,7 @@ static bool try_to_unmap_one(struct page
 			 */
 			if (unlikely(PageSwapBacked(page) != PageSwapCache(page))) {
 				WARN_ON_ONCE(1);
-				ret = SWAP_FAIL;
+				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch

