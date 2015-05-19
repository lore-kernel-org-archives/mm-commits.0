From: akpm@linux-foundation.org
Subject: + powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5.patch
 added to -mm tree
Date: Tue, 19 May 2015 15:21:07 -0700
Message-ID: <555bb753.iwkQTBh5Gt8MfQi2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbbESWVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 18:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5
has been added to the -mm tree.  Its filename is
     powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5

Fix VM_BUG_ON on x86.

The default implementation of pmdp_collapse_flush used the hugepage
variant and hence can be called on pmd_t pointing to pgtable.  This
resulting in us hitting VM_BUG_ON in pmdp_clear_flush.  Update powerpc/mm:
Use generic version of pmdp_clear_flush to handle this.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    8 ++++++++
 include/asm-generic/pgtable.h   |    7 ++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN arch/s390/include/asm/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5 arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5
+++ a/arch/s390/include/asm/pgtable.h
@@ -1548,6 +1548,14 @@ static inline void pmdp_set_wrprotect(st
 	}
 }
 
+static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	return pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+}
+#define pmdp_collapse_flush pmdp_collapse_flush
+
 #define pfn_pmd(pfn, pgprot)	mk_pmd_phys(__pa((pfn) << PAGE_SHIFT), (pgprot))
 #define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
 
diff -puN include/asm-generic/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5
+++ a/include/asm-generic/pgtable.h
@@ -195,7 +195,12 @@ static inline pmd_t pmdp_collapse_flush(
 					unsigned long address,
 					pmd_t *pmdp)
 {
-	return pmdp_clear_flush(vma, address, pmdp);
+	pmd_t pmd;
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_trans_huge(*pmdp));
+	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	return pmd;
 }
 #define pmdp_collapse_flush pmdp_collapse_flush
 #else
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush-v5.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
mm-clarify-that-the-function-operates-on-hugepage-pte-v5.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch

