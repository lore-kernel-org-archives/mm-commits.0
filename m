Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A968C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81D7561482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3F7y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhD3F7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0506661459;
        Fri, 30 Apr 2021 05:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762345;
        bh=cE+WkZBD9r47q+6gaut99ideNZfV87pCaU6dNEB0Kv0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GigXsBkQl9L+/coQ3SakPPTvQPRBNzEgmREt2hsvoEwPhSZ6+ha/+4wZcc+WnoCNc
         KrueGIdAEc7kMGg198GO1EisvN6B2myc/jpOMCr9KPH+EsUIsDGpGc8oFTWrZZyWb/
         OFaVixTtouDJwrurDE8BWYecjDh2QuIqNiV48tqw=
Date:   Thu, 29 Apr 2021 22:59:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clg@kaod.org, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 114/178] mm/vmalloc: improve allocation failure
 error messages
Message-ID: <20210430055904.a3Rd5uQnv%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: improve allocation failure error messages

There are several reasons why a vmalloc can fail, virtual space exhausted,
page array allocation failure, page allocation failure, and kernel page
table allocation failure.

Add distinct warning messages for the main causes of failure, with some
added information like page order or allocation size where applicable.

[urezki@gmail.com: print correct vmalloc allocation size]
  Link: https://lkml.kernel.org/r/20210329193214.GA28602@pc638.lan
Link: https://lkml.kernel.org/r/20210322021806.892164-6-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
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
+			   nr_small_pages * PAGE_SIZE, array_size);
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
