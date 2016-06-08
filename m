From: akpm@linux-foundation.org
Subject: + thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch added
 to -mm tree
Date: Wed, 08 Jun 2016 14:58:12 -0700
Message-ID: <575894f4.4NQK26HKMXICtjIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933433AbcFHV6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 17:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-extract-khugepaged-from-mm-huge_memoryc-fix-2
has been added to the -mm tree.  Its filename is
     thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-extract-khugepaged-from-mm-huge_memoryc-fix-2

still struggling with merge issues...

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/khugepaged.c~thp-extract-khugepaged-from-mm-huge_memoryc-fix-2 mm/khugepaged.c
--- a/mm/khugepaged.c~thp-extract-khugepaged-from-mm-huge_memoryc-fix-2
+++ a/mm/khugepaged.c
@@ -692,6 +692,12 @@ static bool khugepaged_scan_abort(int ni
 	return false;
 }
 
+/* Defrag for khugepaged will enter direct reclaim/compaction if necessary */
+static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
+{
+	return GFP_TRANSHUGE | (khugepaged_defrag() ? __GFP_DIRECT_RECLAIM : 0);
+}
+
 #ifdef CONFIG_NUMA
 
 static int khugepaged_find_target_node(void)
@@ -762,12 +768,6 @@ khugepaged_alloc_page(struct page **hpag
 	return *hpage;
 }
 
-/* Defrag for khugepaged will enter direct reclaim/compaction if necessary */
-static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
-{
-	return GFP_TRANSHUGE | (khugepaged_defrag() ? __GFP_DIRECT_RECLAIM : 0);
-}
-
 #else
 
 static int khugepaged_find_target_node(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

