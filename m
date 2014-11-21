From: akpm@linux-foundation.org
Subject: + powerpc-add-pmd_-for-thp.patch added to -mm tree
Date: Fri, 21 Nov 2014 15:50:18 -0800
Message-ID: <546fcfba.UBI9/N83gvhqyWUO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaKUXuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 18:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add pmd_[dirty|mkclean] for THP
has been added to the -mm tree.  Its filename is
     powerpc-add-pmd_-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-pmd_-for-thp.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-pmd_-for-thp.patch

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
Subject: powerpc: add pmd_[dirty|mkclean] for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc64.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-add-pmd_-for-thp arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-add-pmd_-for-thp
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -469,9 +469,11 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_pfn(pmd)		pte_pfn(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
+#define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
+#define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
mm-support-madvisemadv_free.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
zram-implement-rw_page-operation-of-zram-fix-2.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zram-implement-rw_page-operation-of-zram-fix-3.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

