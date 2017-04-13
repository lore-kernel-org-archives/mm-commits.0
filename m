From: akpm@linux-foundation.org
Subject: [patch 05/11] thp: fix MADV_DONTNEED vs. MADV_FREE race
Date: Thu, 13 Apr 2017 14:56:26 -0700
Message-ID: <58eff40a.yb4Rxcllz8di/6UA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdDMV41 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, minchan@kernel.org, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix MADV_DONTNEED vs. MADV_FREE race

Both MADV_DONTNEED and MADV_FREE handled with down_read(mmap_sem).  It's
critical to not clear pmd intermittently while handling MADV_FREE to avoid
race with MADV_DONTNEED:

	CPU0:				CPU1:
				madvise_free_huge_pmd()
				 pmdp_huge_get_and_clear_full()
madvise_dontneed()
 zap_pmd_range()
  pmd_trans_huge(*pmd) == 0 (without ptl)
  // skip the pmd
				 set_pmd_at();
				 // pmd is re-established

It results in MADV_DONTNEED skipping the pmd, leaving it not cleared.  It
violates MADV_DONTNEED interface and can result is userspace misbehaviour.

Basically it's the same race as with numa balancing in change_huge_pmd(),
but a bit simpler to mitigate: we don't need to preserve dirty/young flags
here due to MADV_FREE functionality.

[kirill.shutemov@linux.intel.com: Urgh... Power is special again]
  Link: http://lkml.kernel.org/r/20170303102636.bhd2zhtpds4mt62a@black.fi.intel.com
Link: http://lkml.kernel.org/r/20170302151034.27829-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race
+++ a/mm/huge_memory.c
@@ -1568,8 +1568,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		deactivate_page(page);
 
 	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
-		orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
-			tlb->fullmm);
+		pmdp_invalidate(vma, addr, pmd);
 		orig_pmd = pmd_mkold(orig_pmd);
 		orig_pmd = pmd_mkclean(orig_pmd);
 
_
