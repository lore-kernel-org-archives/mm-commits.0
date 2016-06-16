From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch removed from -mm
 tree
Date: Thu, 16 Jun 2016 15:03:40 -0700
Message-ID: <5763223c.XPZtJI0qfcfYNCrs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbcFPWDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, ebru.akagunduz@gmail.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch

This patch was dropped because it was folded into mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix

tweak comment text

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix
+++ a/mm/huge_memory.c
@@ -2486,8 +2486,8 @@ static void collapse_huge_page(struct mm
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	curr_allocstall = sum_vm_event(ALLOCSTALL);
 	/*
-	 * When system under pressure, don't swapin readahead.
-	 * So that avoid unnecessary resource consuming.
+	 * Don't perform swapin readahead when the system is under pressure,
+	 * to avoid unnecessary resource consumption.
 	 */
 	if (allocstall == curr_allocstall && swap != 0)
 		__collapse_huge_page_swapin(mm, vma, address, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

