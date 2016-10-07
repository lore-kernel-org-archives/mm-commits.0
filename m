From: akpm@linux-foundation.org
Subject: [patch 036/127] mm: pagewalk: fix the comment for test_walk
Date: Fri, 07 Oct 2016 16:58:36 -0700
Message-ID: <57f836ac.2UQzeLdWH3oBdM9m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39003 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbcJGX6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, james.morse@arm.com, n-horiguchi@ah.jp.nec.com

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
