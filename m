Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C69C352A2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D40E22D73
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgLOX7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbgLOXVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:21:00 -0500
Date:   Tue, 15 Dec 2020 15:19:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074399;
        bh=zWUOPoDAiBcJu6T8i2YA1xl5M1l21dY33n8gSKulw9U=;
        h=From:To:Subject:From;
        b=VTQIuXZNUCPE1vg5807XjJMpQ+wnaEYsiRo5/PaY2OAXArNJUh8HX+6rqI1NwJgti
         OiPBhp65TXQhzSiHMNmuKaqUdffESPjSOu9NxpM9IajtO50FYKtqkme/BBrrSivUnf
         Jgp1CKfE5x0YAYzb77Ut34AKW/+xcQF1NJoJZ6N0=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hsinhuiwu@gmail.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch removed from
 -mm tree
Message-ID: <20201215231959.8R__isc88%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c:__vmalloc_area_node(): avoid 32-bit overflow
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

