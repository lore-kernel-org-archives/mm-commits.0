Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBEEC49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C41613C1
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhFYBl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFYBl4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87739610A7;
        Fri, 25 Jun 2021 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585177;
        bh=qNRWwmLoYS3kZCaETqO8Y730fcFmkKuvlenhQznR+o4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ol0n2R9oEu7M1y+031ToGAwuEiKQL4tJN8bjtB6KIXGMMw7O86woBrzL/kqqKcV2r
         nvH9CxhBNKDZCuvm3P36rjFENSboz8ON59ejGO5f9MQFGA2l/9eR3ssfoEF2NcJJ+Y
         jeiS+W9uGZ9NJfChm1pQjfhzWibvOPRuZr4tF0jc=
Date:   Thu, 24 Jun 2021 18:39:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        cohuck@redhat.com, david@redhat.com, hch@infradead.org,
        imbrenda@linux.ibm.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 12/24] mm/vmalloc: add vmalloc_no_huge
Message-ID: <20210625013936.vemOJ1E0d%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: mm/vmalloc: add vmalloc_no_huge

Patch series "mm: add vmalloc_no_huge and use it", v4.

Add vmalloc_no_huge() and export it, so modules can allocate memory with
small pages.

Use the newly added vmalloc_no_huge() in KVM on s390 to get around a
hardware limitation.


This patch (of 2):

Commit 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") added
support for hugepage vmalloc mappings, it also added the flag
VM_NO_HUGE_VMAP for __vmalloc_node_range to request the allocation to be
performed with 0-order non-huge pages.  This flag is not accessible when
calling vmalloc, the only option is to call directly __vmalloc_node_range,
which is not exported.

This means that a module can't vmalloc memory with small pages.

Case in point: KVM on s390x needs to vmalloc a large area, and it needs to
be mapped with non-huge pages, because of a hardware limitation.

This patch adds the function vmalloc_no_huge, which works like vmalloc,
but it is guaranteed to always back the mapping using small pages.  This
new function is exported, therefore it is usable by modules.

[akpm@linux-foundation.org: whitespace fixes, per Christoph]
Link: https://lkml.kernel.org/r/20210614132357.10202-1-imbrenda@linux.ibm.com
Link: https://lkml.kernel.org/r/20210614132357.10202-2-imbrenda@linux.ibm.com
Fixes: 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") 
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/vmalloc.h~mm-vmalloc-add-vmalloc_no_huge
+++ a/include/linux/vmalloc.h
@@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsign
 			const void *caller);
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
+void *vmalloc_no_huge(unsigned long size);
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
--- a/mm/vmalloc.c~mm-vmalloc-add-vmalloc_no_huge
+++ a/mm/vmalloc.c
@@ -2999,6 +2999,23 @@ void *vmalloc(unsigned long size)
 EXPORT_SYMBOL(vmalloc);
 
 /**
+ * vmalloc_no_huge - allocate virtually contiguous memory using small pages
+ * @size:    allocation size
+ *
+ * Allocate enough non-huge pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+void *vmalloc_no_huge(unsigned long size)
+{
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
+				    GFP_KERNEL, PAGE_KERNEL, VM_NO_HUGE_VMAP,
+				    NUMA_NO_NODE, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(vmalloc_no_huge);
+
+/**
  * vzalloc - allocate virtually contiguous memory with zero fill
  * @size:    allocation size
  *
_
