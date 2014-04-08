From: akpm@linux-foundation.org
Subject: [merged] mm-disable-split-page-table-lock-for-mmu.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:39:39 -0700
Message-ID: <53445e8b.GRe/KOaJvATOrPxa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaDHUjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kirill.shutemov@linux.intel.com

Subject: [merged] mm-disable-split-page-table-lock-for-mmu.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,u.kleine-koenig@pengutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:39:39 -0700


The patch titled
     Subject: mm: disable split page table lock for !MMU
has been removed from the -mm tree.  Its filename was
     mm-disable-split-page-table-lock-for-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

