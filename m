Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC8EC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3BE361463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD3F4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3F4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 697BB6145D;
        Fri, 30 Apr 2021 05:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762112;
        bh=OKK5pQVSNMMbAs7vOJpdEv9yRXMiToy9D/a6gMX6LvU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0Q0JwSxGVUpDVdYigBHJHRhN4n0ExS9K4HwAwfb/fZJb2DXDE7FpPVW29MMtEdJgi
         LAUJ0GsN+yhRMn4R2OjWZAouTA1Y60YPSvOWwD022Jq+tfNCI4tVya9qNFvCFeFz+u
         ffKdCN9WQMEZJ+hBLhShrXSd0MJPKEAGtxuGinnc=
Date:   Thu, 29 Apr 2021 22:55:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 039/178] mm: page_poison: print page info when
 corruption is caught
Message-ID: <20210430055512.z1ThP17xP%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_poison: print page info when corruption is caught

When page_poison detects page corruption it's useful to see who freed a
page recently to have a guess where write-after-free corruption happens.

After this change corruption report has extra page data.
Example report from real corruption (includes only page_pwner part):

    pagealloc: memory corruption
    e00000014cd61d10: 11 00 00 00 00 00 00 00 30 1d d2 ff ff 0f 00 60  ........0......`
    e00000014cd61d20: b0 1d d2 ff ff 0f 00 60 90 fe 1c 00 08 00 00 20  .......`.......
    ...
    CPU: 1 PID: 220402 Comm: cc1plus Not tainted 5.12.0-rc5-00107-g9720c6f59ecf #245
    Hardware name: hp server rx3600, BIOS 04.03 04/08/2008
    ...
    Call Trace:
     [<a000000100015210>] show_stack+0x90/0xc0
     [<a000000101163390>] dump_stack+0x150/0x1c0
     [<a0000001003f1e90>] __kernel_unpoison_pages+0x410/0x440
     [<a0000001003c2460>] get_page_from_freelist+0x1460/0x2ca0
     [<a0000001003c6be0>] __alloc_pages_nodemask+0x3c0/0x660
     [<a0000001003ed690>] alloc_pages_vma+0xb0/0x500
     [<a00000010037deb0>] __handle_mm_fault+0x1230/0x1fe0
     [<a00000010037ef70>] handle_mm_fault+0x310/0x4e0
     [<a00000010005dc70>] ia64_do_page_fault+0x1f0/0xb80
     [<a00000010000ca00>] ia64_leave_kernel+0x0/0x270
    page_owner tracks the page as freed
    page allocated via order 0, migratetype Movable,
      gfp_mask 0x100dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO), pid 37, ts 8173444098740
     __reset_page_owner+0x40/0x200
     free_pcp_prepare+0x4d0/0x600
     free_unref_page+0x20/0x1c0
     __put_page+0x110/0x1a0
     migrate_pages+0x16d0/0x1dc0
     compact_zone+0xfc0/0x1aa0
     proactive_compact_node+0xd0/0x1e0
     kcompactd+0x550/0x600
     kthread+0x2c0/0x2e0
     call_payload+0x50/0x80

Here we can see that page was freed by page migration but something
managed to write to it afterwards.

[slyfox@gentoo.org: s/dump_page_owner/dump_page/, per Vlastimil]
  Link: https://lkml.kernel.org/r/20210407230800.1086854-1-slyfox@gentoo.org
Link: https://lkml.kernel.org/r/20210404141735.2152984-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_poison.c~mm-page_poison-print-page-owner-info-when-corruption-is-caught
+++ a/mm/page_poison.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/mmdebug.h>
 #include <linux/highmem.h>
 #include <linux/page_ext.h>
 #include <linux/poison.h>
@@ -45,7 +46,7 @@ static bool single_bit_flip(unsigned cha
 	return error && !(error & (error - 1));
 }
 
-static void check_poison_mem(unsigned char *mem, size_t bytes)
+static void check_poison_mem(struct page *page, unsigned char *mem, size_t bytes)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
 	unsigned char *start;
@@ -70,6 +71,7 @@ static void check_poison_mem(unsigned ch
 	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
 			end - start + 1, 1);
 	dump_stack();
+	dump_page(page, "pagealloc: corrupted page details");
 }
 
 static void unpoison_page(struct page *page)
@@ -83,7 +85,7 @@ static void unpoison_page(struct page *p
 	 * that is freed to buddy. Thus no extra check is done to
 	 * see if a page was poisoned.
 	 */
-	check_poison_mem(kasan_reset_tag(addr), PAGE_SIZE);
+	check_poison_mem(page, kasan_reset_tag(addr), PAGE_SIZE);
 	kasan_enable_current();
 	kunmap_atomic(addr);
 }
_
