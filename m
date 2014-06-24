From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
 added to -mm tree
Date: Tue, 24 Jun 2014 16:27:10 -0700
Message-ID: <53aa094e.0CCSEpU3JHyvM/9F%akpm__3913.17803082547$1403652443$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaFXX1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 19:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, catalin.marinas@arm.com, cov@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, msalter@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE,
the following is triggered at early boot:

  SMP: Total of 8 processors activated.
  devtmpfs: initialized
  Unable to handle kernel NULL pointer dereference at virtual address 00000008
  pgd = fffffe0000050000
  [00000008] *pgd=00000043fba00003, *pmd=00000043fba00003, *pte=00e0000078010407
  Internal error: Oops: 96000006 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc864k+ #44
  task: fffffe03bc040000 ti: fffffe03bc080000 task.ti: fffffe03bc080000
  PC is at __list_add+0x10/0xd4
  LR is at free_one_page+0x270/0x638
  ...
  Call trace:
  [<fffffe00003ee970>] __list_add+0x10/0xd4
  [<fffffe000019c478>] free_one_page+0x26c/0x638
  [<fffffe000019c8c8>] __free_pages_ok.part.52+0x84/0xbc
  [<fffffe000019d5e8>] __free_pages+0x74/0xbc
  [<fffffe0000c01350>] init_cma_reserved_pageblock+0xe8/0x104
  [<fffffe0000c24de0>] cma_init_reserved_areas+0x190/0x1e4
  [<fffffe0000090418>] do_one_initcall+0xc4/0x154
  [<fffffe0000bf0a50>] kernel_init_freeable+0x204/0x2a8
  [<fffffe00007520a0>] kernel_init+0xc/0xd4

This happens because init_cma_reserved_pageblock() calls __free_one_page()
with pageblock_order as page order but it is bigger than MAX_ORDER.  This
in turn causes accesses past zone->free_list[].

Fix the problem by changing init_cma_reserved_pageblock() such that it
splits pageblock into individual MAX_ORDER pages if pageblock is bigger
than a MAX_ORDER page.

In cases where !CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which is all
architectures expect for ia64, powerpc and tile at the moment, the
“pageblock_order > MAX_ORDER” condition will be optimised out since
both sides of the operator are constants.  In cases where pageblock size
is variable, the performance degradation should not be significant anyway
since init_cma_reserved_pageblock() is called only at boot time at most
MAX_CMA_AREAS times which by default is eight.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: Mark Salter <msalter@redhat.com>
Tested-by: Mark Salter <msalter@redhat.com>
Tested-by: Christopher Covington <cov@codeaurora.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order
+++ a/mm/page_alloc.c
@@ -816,9 +816,21 @@ void __init init_cma_reserved_pageblock(
 		set_page_count(p, 0);
 	} while (++p, --i);
 
-	set_page_refcounted(page);
 	set_pageblock_migratetype(page, MIGRATE_CMA);
-	__free_pages(page, pageblock_order);
+
+	if (pageblock_order >= MAX_ORDER) {
+		i = pageblock_nr_pages;
+		p = page;
+		do {
+			set_page_refcounted(p);
+			__free_pages(p, MAX_ORDER - 1);
+			p += MAX_ORDER_NR_PAGES;
+		} while (i -= MAX_ORDER_NR_PAGES);
+	} else {
+		set_page_refcounted(page);
+		__free_pages(page, pageblock_order);
+	}
+
 	adjust_managed_page_count(page, pageblock_nr_pages);
 }
 #endif
_

Patches currently in -mm which might be from mina86@mina86.com are

origin.patch
mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

