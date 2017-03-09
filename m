From: akpm@linux-foundation.org
Subject: + mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
 added to -mm tree
Date: Thu, 09 Mar 2017 13:28:34 -0800
Message-ID: <58c1c902.Dnva7Gy6CTQhPLPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdCIV2f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mhocko@suse.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use VM_WARN_ON_ONCE as if condition
has been added to the -mm tree.  Its filename is
     mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch

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
Subject: mm: do not use VM_WARN_ON_ONCE as if condition

Sergey reported VM_WARN_ON_ONCE returns void with !CONFIG_DEBUG_VM
so we cannot use it as if's condition unlike WARN_ON.

This patch fixes it.

Link: http://lkml.kernel.org/r/20170309060226.GB854@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix mm/rmap.c
--- a/mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix
+++ a/mm/rmap.c
@@ -1413,12 +1413,11 @@ static int try_to_unmap_one(struct page
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
-			if (VM_WARN_ON_ONCE(PageSwapBacked(page) !=
-						PageSwapCache(page))) {
+			if (unlikely(PageSwapBacked(page) != PageSwapCache(page))) {
+				WARN_ON_ONCE(1);
 				ret = SWAP_FAIL;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
