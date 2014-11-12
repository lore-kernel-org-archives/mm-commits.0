From: akpm@linux-foundation.org
Subject: + mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch
 added to -mm tree
Date: Wed, 12 Nov 2014 13:17:55 -0800
Message-ID: <5463ce83.tvfh8R1WoWIF1D6T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:17:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix
has been added to the -mm tree.  Its filename is
     mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix

Return type should be 'unsigned long'.

Andrew, please fold this into the patch:

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~mm-fix-huge-zero-page-accounting-in-smaps-report-fix arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-fix-huge-zero-page-accounting-in-smaps-report-fix
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -667,7 +667,7 @@ static inline unsigned long pmd_pfn(pmd_
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline pmd_t pmd_dirty(pmd_t pmd)
+static inline unsigned long pmd_dirty(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-verify-compound-order-when-freeing-a-page.patch
thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

