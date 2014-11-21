From: akpm@linux-foundation.org
Subject: + x86-add-pmd_-for-thp.patch added to -mm tree
Date: Fri, 21 Nov 2014 15:50:14 -0800
Message-ID: <546fcfb6.MuHMs8oGP3MzLoCc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaKUXuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 18:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: add pmd_[dirty|mkclean] for THP
has been added to the -mm tree.  Its filename is
     x86-add-pmd_-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-pmd_-for-thp.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-pmd_-for-thp.patch

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
Subject: x86: add pmd_[dirty|mkclean] for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~x86-add-pmd_-for-thp arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-add-pmd_-for-thp
+++ a/arch/x86/include/asm/pgtable.h
@@ -109,6 +109,11 @@ static inline int pmd_young(pmd_t pmd)
 	return pmd_flags(pmd) & _PAGE_ACCESSED;
 }
 
+static inline int pmd_dirty(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_DIRTY;
+}
+
 static inline int pte_write(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_RW;
@@ -277,6 +282,11 @@ static inline pmd_t pmd_mkold(pmd_t pmd)
 	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
 }
 
+static inline pmd_t pmd_mkclean(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_DIRTY);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pmd_clear_flags(pmd, _PAGE_RW);
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

