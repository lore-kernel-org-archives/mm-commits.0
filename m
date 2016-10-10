From: akpm@linux-foundation.org
Subject: [merged] mm-pagewalk-fix-the-comment-for-test_walk.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:43:48 -0700
Message-ID: <57fc19a4.BB+a9icNwGUFjOFj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36639 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbcJJWns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: fix the comment for test_walk
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-the-comment-for-test_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: mm: pagewalk: fix the comment for test_walk

Modify the comment describing struct mm_walk->test_walk()s behaviour to
match the comment on walk_page_test() and the behaviour of
walk_page_vma().

Fixes: fafaa4264eba4 ("pagewalk: improve vma handling")
Link: http://lkml.kernel.org/r/1471622518-21980-1-git-send-email-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-pagewalk-fix-the-comment-for-test_walk include/linux/mm.h
--- a/include/linux/mm.h~mm-pagewalk-fix-the-comment-for-test_walk
+++ a/include/linux/mm.h
@@ -1197,10 +1197,10 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
  * @test_walk: caller specific callback function to determine whether
- *             we walk over the current vma or not. A positive returned
+ *             we walk over the current vma or not. Returning 0
  *             value means "do page table walk over the current vma,"
  *             and a negative one means "abort current page table walk
- *             right now." 0 means "skip the current vma."
+ *             right now." 1 means "skip the current vma."
  * @mm:        mm_struct representing the target process of page table walk
  * @vma:       vma currently walked (NULL if walking outside vmas)
  * @private:   private data for callbacks' usage
_

Patches currently in -mm which might be from james.morse@arm.com are


