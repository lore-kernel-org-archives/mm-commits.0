From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:12 -0700
Message-ID: <53bae2c0.HnT2QOf5RiJkkn2o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44437 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGGSLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:14 -0400
Received: by mail-qa0-f74.google.com with SMTP id w8so657973qac.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, catalin.marinas@arm.com, cov@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, msalter@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix CMA area initialisation when pagebloc=
k > MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order=
=2Epatch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Michal Nazarewicz <mina86@mina86.com>
Subject: mm: page_alloc: fix CMA area initialisation when pageblock > M=
AX_ORDER

With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE,
the following is triggered at early boot:

  SMP: Total of 8 processors activated.
  devtmpfs: initialized
  Unable to handle kernel NULL pointer dereference at virtual address 0=
0000008
  pgd =3D fffffe0000050000
  [00000008] *pgd=3D00000043fba00003, *pmd=3D00000043fba00003, *pte=3D0=
0e0000078010407
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

This happens because init_cma_reserved_pageblock() calls __free_one_pag=
e()
with pageblock_order as page order but it is bigger than MAX_ORDER.  Th=
is
in turn causes accesses past zone->free_list[].

=46ix the problem by changing init_cma_reserved_pageblock() such that i=
t
splits pageblock into individual MAX_ORDER pages if pageblock is bigger
than a MAX_ORDER page.

In cases where !CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which is all
architectures expect for ia64, powerpc and tile at the moment, the
=E2=80=9Cpageblock_order > MAX_ORDER=E2=80=9D condition will be optimis=
ed out since
both sides of the operator are constants.  In cases where pageblock siz=
e
is variable, the performance degradation should not be significant anyw=
ay
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

diff -puN mm/page_alloc.c~mm-page_alloc-fix-cma-area-initialisation-whe=
n-pageblock-max_order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-cma-area-initialisation-when-pa=
geblock-max_order
+++ a/mm/page_alloc.c
@@ -816,9 +816,21 @@ void __init init_cma_reserved_pageblock(
 		set_page_count(p, 0);
 	} while (++p, --i);
=20
-	set_page_refcounted(page);
 	set_pageblock_migratetype(page, MIGRATE_CMA);
-	__free_pages(page, pageblock_order);
+
+	if (pageblock_order >=3D MAX_ORDER) {
+		i =3D pageblock_nr_pages;
+		p =3D page;
+		do {
+			set_page_refcounted(p);
+			__free_pages(p, MAX_ORDER - 1);
+			p +=3D MAX_ORDER_NR_PAGES;
+		} while (i -=3D MAX_ORDER_NR_PAGES);
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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
