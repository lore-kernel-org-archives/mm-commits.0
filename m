Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B352EC00A5A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 00:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjARAdI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjARAcv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 19:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6A72B60D
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 15:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14367B81A1D
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 23:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB48C433D2;
        Tue, 17 Jan 2023 23:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673999953;
        bh=2/F3ILzmcilqCLd1IlV1/+xo95WDiXBtXVt3KVJCYWE=;
        h=Date:To:From:Subject:From;
        b=Lj7nDmQDMoDuZyE6fSJcWY0EKb2QF0RnEJE/T4vDUhuftxbzxbXP8jA8Ts44B88LC
         9x5aM1KkWFxTSMPFaLlf/0G+IHunvcIDMlPZ+Zc0V1hzvvE4QIb3Q8XhZ/2V+1mxk1
         9EWtwFweiGOld3RNtM5TDudlxGZ7Xoc+dyxdL0r0=
Date:   Tue, 17 Jan 2023 15:59:12 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, luto@kernel.org,
        hch@infradead.org, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch added to mm-unstable branch
Message-Id: <20230117235913.ACB48C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork, vmalloc: KASAN-poison backing pages of vmapped stacks
has been added to the -mm mm-unstable branch.  Its filename is
     fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
fork-vmalloc-kasan-poison-backing-pages-of-vmapped-stacks.patch

