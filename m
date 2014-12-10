From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:17:34 -0800
Message-ID: <5488d48e.DHKCaoM708qR2lom%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaLJXRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch

This patch was dropped because it was folded into mm-fix-huge-zero-page-accounting-in-smaps-report.patch

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

origin.patch
mm-verify-compound-order-when-freeing-a-page.patch
thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch

