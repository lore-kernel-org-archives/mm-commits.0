Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B570DC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF6661969
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhC1WFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhC1WF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9C9A6195E;
        Sun, 28 Mar 2021 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969127;
        bh=FfwK4gntE2sOnmYbohxMv+B9QFt3WpVNzWwmNnMCXpk=;
        h=Date:From:To:Subject:From;
        b=wo3hmRA0FT55iNXDe8lgAMCRe33rgJBXEz2kpDUqnYqJFLbP4llH7iIj2PJddAtD5
         pibZmf5Nl3xh9n3QwBSe7pZ+YPKa55n4DtTUEyPJRQoEcnGlIWs3ZtDlhUAmbN8Z02
         1F+bm2g4aq/n9+j8mBMMrZF+qnNDAxQl5KzKvvWE=
Date:   Sun, 28 Mar 2021 15:05:26 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  +
 mm-vmalloc-improve-allocation-failure-error-messages.patch added to -mm
 tree
Message-ID: <20210328220526.dcy4k9U0m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: improve allocation failure error messages
has been added to the -mm tree.  Its filename is
     mm-vmalloc-improve-allocation-failure-error-messages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-improve-allocation=
-failure-error-messages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-improve-allocation=
-failure-error-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: improve allocation failure error messages

There are several reasons why a vmalloc can fail, virtual space exhausted,
page array allocation failure, page allocation failure, and kernel page
table allocation failure.

Add distinct warning messages for the main causes of failure, with some
added information like page order or allocation size where applicable.

Link: https://lkml.kernel.org/r/20210322021806.892164-6-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-improve-allocation-failure-error-messages
+++ a/mm/vmalloc.c
@@ -2790,6 +2790,10 @@ static void *__vmalloc_area_node(struct
=20
 	if (!pages) {
 		free_vm_area(area);
+		warn_alloc(gfp_mask, NULL,
+			   "vmalloc size %lu allocation failure: "
+			   "page array size %lu allocation failed",
+			   area->nr_pages * PAGE_SIZE, array_size);
 		return NULL;
 	}
=20
@@ -2814,6 +2818,10 @@ static void *__vmalloc_area_node(struct
 			/* Successfully allocated i pages, free them in __vfree() */
 			area->nr_pages =3D i;
 			atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
+			warn_alloc(gfp_mask, NULL,
+				   "vmalloc size %lu allocation failure: "
+				   "page order %u allocation failed",
+				   area->nr_pages * PAGE_SIZE, page_order);
 			goto fail;
 		}
=20
@@ -2825,15 +2833,17 @@ static void *__vmalloc_area_node(struct
 	}
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
=20
-	if (vmap_pages_range(addr, addr + size, prot, pages, page_shift) < 0)
+	if (vmap_pages_range(addr, addr + size, prot, pages, page_shift) < 0) {
+		warn_alloc(gfp_mask, NULL,
+			   "vmalloc size %lu allocation failure: "
+			   "failed to map pages",
+			   area->nr_pages * PAGE_SIZE);
 		goto fail;
+	}
=20
 	return area->addr;
=20
 fail:
-	warn_alloc(gfp_mask, NULL,
-			  "vmalloc: allocation failure, allocated %ld of %ld bytes",
-			  (area->nr_pages*PAGE_SIZE), size);
 	__vfree(area->addr);
 	return NULL;
 }
@@ -2867,9 +2877,14 @@ void *__vmalloc_node_range(unsigned long
 	unsigned long real_align =3D align;
 	unsigned int shift =3D PAGE_SHIFT;
=20
-	if (!size || (size >> PAGE_SHIFT) > totalram_pages()) {
-		area =3D NULL;
-		goto fail;
+	if (WARN_ON_ONCE(!size))
+		return NULL;
+
+	if ((size >> PAGE_SHIFT) > totalram_pages()) {
+		warn_alloc(gfp_mask, NULL,
+			   "vmalloc size %lu allocation failure: "
+			   "exceeds total pages", real_size);
+		return NULL;
 	}
=20
 	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP) &&
@@ -2897,8 +2912,12 @@ again:
 	size =3D PAGE_ALIGN(size);
 	area =3D __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
 				vm_flags, start, end, node, gfp_mask, caller);
-	if (!area)
+	if (!area) {
+		warn_alloc(gfp_mask, NULL,
+			   "vmalloc size %lu allocation failure: "
+			   "vm_struct allocation failed", real_size);
 		goto fail;
+	}
=20
 	addr =3D __vmalloc_area_node(area, gfp_mask, prot, shift, node);
 	if (!addr)
@@ -2923,11 +2942,6 @@ fail:
 		goto again;
 	}
=20
-	if (!area) {
-		/* Warn for area allocation, page allocations already warn */
-		warn_alloc(gfp_mask, NULL,
-			  "vmalloc: allocation failure: %lu bytes", real_size);
-	}
 	return NULL;
 }
=20
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_pa=
ge.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_pa=
ge-fix.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch
mm-vmalloc-remove-map_kernel_range.patch
kernel-dma-remove-unnecessary-unmap_kernel_range.patch
powerpc-xive-remove-unnecessary-unmap_kernel_range.patch
mm-vmalloc-remove-unmap_kernel_range.patch
mm-vmalloc-improve-allocation-failure-error-messages.patch

