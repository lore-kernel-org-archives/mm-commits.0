From: akpm@linux-foundation.org
Subject: + mm-disable-split-page-table-lock-for-mmu.patch added to -mm
 tree
Date: Wed, 26 Feb 2014 16:05:54 -0800
Message-ID: <530e8162.k/HY2v6RHRm/T+ga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaB0AFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 19:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kirill.shutemov@linux.intel.com

Subject: + mm-disable-split-page-table-lock-for-mmu.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 16:05:54 -0800


The patch titled
     Subject: mm: disable split page table lock for !MMU
has been added to the -mm tree.  Its filename is
     mm-disable-split-page-table-lock-for-mmu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-split-page-table-lock-for-mmu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-disable-split-page-table-lock-for-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: disable split page table lock for !MMU

There's no reason to enable split page table lock if don't have page
tables.

It also triggers build error at least on ARM since we don't define
pmd_page() for !MMU.

In file included from arch/arm/kernel/asm-offsets.c:14:0:
include/linux/mm.h: In function 'pte_lockptr':
include/linux/mm.h:1392:2: error: implicit declaration of function 'pmd_page' [-Werror=implicit-function-declaration]
include/linux/mm.h:1392:2: warning: passing argument 1 of 'ptlock_ptr' makes pointer from integer without a cast [enabled by default]
include/linux/mm.h:1384:27: note: expected 'struct page *' but argument is of type 'int'

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-disable-split-page-table-lock-for-mmu mm/Kconfig
--- a/mm/Kconfig~mm-disable-split-page-table-lock-for-mmu
+++ a/mm/Kconfig
@@ -216,6 +216,7 @@ config PAGEFLAGS_EXTENDED
 #
 config SPLIT_PTLOCK_CPUS
 	int
+	default "999999" if !MMU
 	default "999999" if ARM && !CPU_CACHE_VIPT
 	default "999999" if PARISC && !PA20
 	default "4"
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch

