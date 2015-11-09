From: akpm@linux-foundation.org
Subject: + hugetlb-trivial-comment-fix.patch added to -mm tree
Date: Mon, 09 Nov 2015 13:06:30 -0800
Message-ID: <56410ad6.1If/UhnM63HU4nKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbbKIVGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:06:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: trivial comment fix
has been added to the -mm tree.  Its filename is
     hugetlb-trivial-comment-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-trivial-comment-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-trivial-comment-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: trivial comment fix

Recently alloc_buddy_huge_page() was renamed to __alloc_buddy_huge_page(),
so let's sync comments.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-trivial-comment-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-trivial-comment-fix
+++ a/mm/hugetlb.c
@@ -2138,7 +2138,7 @@ static unsigned long set_max_huge_pages(
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with alloc_buddy_huge_page() here and be unable
+	 * We might race with __alloc_buddy_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -2180,7 +2180,7 @@ static unsigned long set_max_huge_pages(
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * alloc_buddy_huge_page() is checking the global counter,
+	 * __alloc_buddy_huge_page() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hugetlb-trivial-comment-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

