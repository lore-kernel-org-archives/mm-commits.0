From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
 removed from -mm tree
Date: Thu, 16 Jun 2016 15:05:08 -0700
Message-ID: <57632294.RV53fQh1inyGeY4y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbcFPWFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch

This patch was dropped because it was folded into mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix

update comment to match new code

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix
+++ a/mm/huge_memory.c
@@ -2512,8 +2512,8 @@ static void collapse_huge_page(struct mm
 	if (allocstall == curr_allocstall && swap != 0) {
 		/*
 		 * __collapse_huge_page_swapin always returns with mmap_sem
-		 * locked. If it fails, release mmap_sem and jump directly
-		 * label out. Continuing to collapse causes inconsistency.
+		 * locked.  If it fails, release mmap_sem and jump directly
+		 * out.  Continuing to collapse causes inconsistency.
 		 */
 		if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
 			mem_cgroup_cancel_charge(new_page, memcg, true);
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
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch
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

