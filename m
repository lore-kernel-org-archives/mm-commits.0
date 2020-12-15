Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF27C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6490522CB1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgLODKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgLODKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:10:35 -0500
Date:   Mon, 14 Dec 2020 19:08:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001723;
        bh=UiQquleYUZ78Frrc0uEvTTVR5t818FWXwyPi2+PqCWE=;
        h=From:To:Subject:In-Reply-To:From;
        b=VIaVR6kg4k7aY534TQdVueTuOAgPz4zhjLvo35B2kS+I9ltxepCNXfX+iceH0wzm5
         UEQMML4DCWWgYLHeiR1NByoaAH34+pBexflEYJ9a9NtG5ul9oZDZGMXnrrEYddbyHB
         336oFtctBg4C8ZHbGVdGrQQpZxhKMTmtOIei7jBg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hsinhuiwu@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 093/200] mm/vmalloc.c:__vmalloc_area_node(): avoid
 32-bit overflow
Message-ID: <20201215030843.2BX1hIxoS%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmalloc.c:__vmalloc_area_node(): avoid 32-bit overflow

With a machine with 3 TB (more than 2 TB memory).  If you use vmalloc to
allocate > 2 TB memory, the array_size below will be overflowed.

The array_size is an unsigned int and can only be used to allocate less
than 2 TB memory.  If you pass 2*1028*1028*1024*1024 = 2 * 2^40 in the
argument of vmalloc.  The array_size will become 2*2^31 = 2^32.  The 2^32
cannot be store with a 32 bit integer.

The fix is to change the type of array_size to unsigned long.

[akpm@linux-foundation.org: rework for current mainline]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=210023
Reported-by: <hsinhuiwu@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow
+++ a/mm/vmalloc.c
@@ -2461,9 +2461,11 @@ static void *__vmalloc_area_node(struct
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 	unsigned int nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
-	unsigned int array_size = nr_pages * sizeof(struct page *), i;
+	unsigned long array_size;
+	unsigned int i;
 	struct page **pages;
 
+	array_size = (unsigned long)nr_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
_
