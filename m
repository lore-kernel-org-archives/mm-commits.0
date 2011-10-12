From: akpm@google.com
Subject: + mm-huge_memory-fix-copying-user-highpage.patch added to -mm tree
Date: Wed, 12 Oct 2011 13:44:08 -0700
Message-ID: <201110122044.p9CKiAID005794@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JLUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2011 16:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com


The patch titled
     From: Hillf Danton <dhillf@gmail.com>
has been added to the -mm tree.  Its filename is
     mm-huge_memory-fix-copying-user-highpage.patch

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
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/huge_memory: fix copying user highpage

The THP copy-on-write handler falls back to regular-sized pages for a huge
page replacement upon allocation failure or if THP has been individually
disabled in the target VMA.  The loop responsible for copying page-sized
chunks accidentally uses multiples of PAGE_SHIFT instead of PAGE_SIZE as
the virtual address arg for copy_user_highpage().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memory-fix-copying-user-highpage mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-fix-copying-user-highpage
+++ a/mm/huge_memory.c
@@ -829,7 +829,7 @@ static int do_huge_pmd_wp_page_fallback(
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		copy_user_highpage(pages[i], page + i,
-				   haddr + PAGE_SHIFT*i, vma);
+				   haddr + PAGE_SIZE * i, vma);
 		__SetPageUptodate(pages[i]);
 		cond_resched();
 	}
_
Subject: From: Hillf Danton <dhillf@gmail.com>

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-huge_memory-fix-copying-user-highpage.patch

