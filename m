From: akpm@linux-foundation.org
Subject: [folded-merged] thp-fix-madv_dontneed-vs-madv_free-race-fix.patch removed from -mm tree
Date: Thu, 13 Apr 2017 14:52:24 -0700
Message-ID: <58eff318.f+Sul/d/uKLuqGYs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdDMVw0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, minchan@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-fix-madv_dontneed-vs-madv_free-race-fix
has been removed from the -mm tree.  Its filename was
     thp-fix-madv_dontneed-vs-madv_free-race-fix.patch

This patch was dropped because it was folded into thp-fix-madv_dontneed-vs-madv_free-race.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-fix-madv_dontneed-vs-madv_free-race-fix

Urgh... Power is special again.

Link: http://lkml.kernel.org/r/20170303102636.bhd2zhtpds4mt62a@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-madv_dontneed-vs-madv_free-race-fix
+++ a/mm/huge_memory.c
@@ -1568,6 +1568,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		deactivate_page(page);
 
 	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
+		pmdp_invalidate(vma, addr, pmd);
 		orig_pmd = pmd_mkold(orig_pmd);
 		orig_pmd = pmd_mkclean(orig_pmd);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
mm-drop-unused-pmdp_huge_get_and_clear_notify.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

