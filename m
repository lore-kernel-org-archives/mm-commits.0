Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7549C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCBBE6023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhGFTQB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EC46117A;
        Tue,  6 Jul 2021 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598801;
        bh=OUhb4CUAT0OTLSdaNRcdf7YzsC6eI59hbEWROCOZ688=;
        h=Date:From:To:Subject:From;
        b=dq/x3gyjlxLnDgOwC1ABOB/ICF53v/Omd+FheBlTgzy36wpr1/PDRoSewGlIjOAHo
         T33bGp4qKPPFazd+zRENj2MY6Im5coHvNbLRMgTZxj/3ETLUdzX1iuhKgczbTh+ZWk
         P1Kt4ZVpBUXbr39YySVM65QW5/KvsJFiNEEfRzAM=
Date:   Tue, 06 Jul 2021 12:13:21 -0700
From:   akpm@linux-foundation.org
To:     hch@infradead.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-vmalloc-remove-quoted-string-split-across-lines.patch removed from -mm
 tree
Message-ID: <20210706191321.feIFoyxq9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove quoted strings split across lines
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-quoted-string-split-across-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: remove quoted strings split across lines

A checkpatch.pl script complains on splitting a text across lines.  It is
because if a user wants to find an entire string he or she will not
succeeded.

<snip>
WARNING: quoted string split across lines
+               "vmalloc size %lu allocation failure: "
+               "page order %u allocation failed",

total: 0 errors, 1 warnings, 10 lines checked
<snip>

Link: https://lkml.kernel.org/r/20210521204359.19943-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-quoted-string-split-across-lines
+++ a/mm/vmalloc.c
@@ -2784,9 +2784,8 @@ static void *__vmalloc_area_node(struct
 
 	if (!area->pages) {
 		warn_alloc(gfp_mask, NULL,
-			   "vmalloc size %lu allocation failure: "
-			   "page array size %lu allocation failed",
-			   nr_small_pages * PAGE_SIZE, array_size);
+			"vmalloc error: size %lu, failed to allocated page array size %lu",
+			nr_small_pages * PAGE_SIZE, array_size);
 		free_vm_area(area);
 		return NULL;
 	}
@@ -2831,17 +2830,15 @@ static void *__vmalloc_area_node(struct
 	 */
 	if (area->nr_pages != nr_small_pages) {
 		warn_alloc(gfp_mask, NULL,
-			"vmalloc size %lu allocation failure: "
-			"page order %u allocation failed",
+			"vmalloc error: size %lu, page order %u, failed to allocate pages",
 			area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
 	}
 
 	if (vmap_pages_range(addr, addr + size, prot, area->pages, page_shift) < 0) {
 		warn_alloc(gfp_mask, NULL,
-			   "vmalloc size %lu allocation failure: "
-			   "failed to map pages",
-			   area->nr_pages * PAGE_SIZE);
+			"vmalloc error: size %lu, failed to map pages",
+			area->nr_pages * PAGE_SIZE);
 		goto fail;
 	}
 
@@ -2886,8 +2883,8 @@ void *__vmalloc_node_range(unsigned long
 
 	if ((size >> PAGE_SHIFT) > totalram_pages()) {
 		warn_alloc(gfp_mask, NULL,
-			   "vmalloc size %lu allocation failure: "
-			   "exceeds total pages", real_size);
+			"vmalloc error: size %lu, exceeds total pages",
+			real_size);
 		return NULL;
 	}
 
@@ -2918,8 +2915,8 @@ again:
 				  gfp_mask, caller);
 	if (!area) {
 		warn_alloc(gfp_mask, NULL,
-			   "vmalloc size %lu allocation failure: "
-			   "vm_struct allocation failed", real_size);
+			"vmalloc error: size %lu, vm_struct allocation failed",
+			real_size);
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are


