Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6698C61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 25 Jan 2023 21:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbjAYVqv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 16:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbjAYVqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 16:46:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685105618C
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 13:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21F5DB81BF8
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 21:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80CCC4339B;
        Wed, 25 Jan 2023 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674683167;
        bh=L38RygLWWQDl7EWKgy5vbpYqNbFSW7kvIoAhbkvyh28=;
        h=Date:To:From:Subject:From;
        b=QqJ91ksWQKJxMAhhFcLtvWgGu0p5Q+OVCfHYBS+McWAckHg4dapsBfcxdHg8a0XPb
         6muRFGGVXxDllFnl4ULNNSMdS+xKvKobxYk/hReFEZuA4etq/lcMuU2uBlwcNggZND
         V+xgOQhtp5fbud3KN6KiPVMGrR1UrylwcjMg6fvA=
Date:   Wed, 25 Jan 2023 13:46:07 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, luto@kernel.org,
        hch@infradead.org, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch removed from -mm tree
Message-Id: <20230125214607.B80CCC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fork, vmalloc: KASAN-poison backing pages of vmapped stacks
has been removed from the -mm tree.  Its filename was
     fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: fork, vmalloc: KASAN-poison backing pages of vmapped stacks
Date: Tue, 17 Jan 2023 17:35:43 +0100

KASAN (except in HW_TAGS mode) tracks memory state based on virtual
addresses.  The mappings of kernel stack pages in the linear mapping are
currently marked as fully accessible.

Since stack corruption issues can cause some very gnarly errors, let's be
extra careful and tell KASAN to forbid accesses to stack memory through
the linear mapping.

Link: https://lkml.kernel.org/r/20230117163543.1049025-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/vmalloc.h~fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks
+++ a/include/linux/vmalloc.h
@@ -298,4 +298,10 @@ bool vmalloc_dump_obj(void *object);
 static inline bool vmalloc_dump_obj(void *object) { return false; }
 #endif
 
+#if defined(CONFIG_MMU) && (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
+void vmalloc_poison_backing_pages(const void *addr);
+#else
+static inline void vmalloc_poison_backing_pages(const void *addr) {}
+#endif
+
 #endif /* _LINUX_VMALLOC_H */
--- a/kernel/fork.c~fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks
+++ a/kernel/fork.c
@@ -321,6 +321,16 @@ static int alloc_thread_stack_node(struc
 		vfree(stack);
 		return -ENOMEM;
 	}
+
+	/*
+	 * A virtually-allocated stack's memory should only be accessed through
+	 * the vmalloc area, not through the linear mapping.
+	 * Inform KASAN that all accesses through the linear mapping should be
+	 * reported (instead of permitting all accesses through the linear
+	 * mapping).
+	 */
+	vmalloc_poison_backing_pages(stack);
+
 	/*
 	 * We can't call find_vm_area() in interrupt context, and
 	 * free_thread_stack() can be called in interrupt context,
--- a/mm/vmalloc.c~fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks
+++ a/mm/vmalloc.c
@@ -4147,6 +4147,30 @@ void pcpu_free_vm_areas(struct vm_struct
 }
 #endif	/* CONFIG_SMP */
 
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+/*
+ * Poison the KASAN shadow for the linear mapping of the pages used as stack
+ * memory.
+ * NOTE: This makes no sense in HW_TAGS mode because HW_TAGS marks physical
+ * memory, not virtual memory.
+ */
+void vmalloc_poison_backing_pages(const void *addr)
+{
+	struct vm_struct *area;
+	int i;
+
+	if (WARN(!PAGE_ALIGNED(addr), "bad address (%p)\n", addr))
+		return;
+
+	area = find_vm_area(addr);
+	if (WARN(!area, "nonexistent vm area (%p)\n", addr))
+		return;
+
+	for (i = 0; i < area->nr_pages; i++)
+		kasan_poison_pages(area->pages[i], 0, false);
+}
+#endif
+
 #ifdef CONFIG_PRINTK
 bool vmalloc_dump_obj(void *object)
 {
_

Patches currently in -mm which might be from jannh@google.com are

mm-khugepaged-fix-anon_vma-race.patch

