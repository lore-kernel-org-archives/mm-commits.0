Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7DBC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiCYWoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiCYWn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDBA20C185
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44EC2614A8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B0C004DD;
        Fri, 25 Mar 2022 22:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248138;
        bh=VGYKGHsyARIt1Y9wGSBAcvq/x5tPRS6ytzup0molZmY=;
        h=Date:To:From:Subject:From;
        b=d1CrFuYIN6OfldZ4nTKV2X/x42xQqhkjqaoM8PI8RdtA47XtF3QUJOcpE/Cdx8rQN
         Q/X25Lgw8HuaHAB3CiODeL9YtRsATync+NvVXIUqR1jjcy65HnTkNMX2NYSuOBjlLd
         Gxvu8v19wLzIOnY8kMHjKi9lHYB2WxQC2/AyME1w=
Date:   Fri, 25 Mar 2022 15:42:18 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, dan.carpenter@oracle.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch removed from -mm tree
Message-Id: <20220325224218.A08B0C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: reset pointer tags of vmapped stacks
has been removed from the -mm tree.  Its filename was
     kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: reset pointer tags of vmapped stacks

Once tag-based KASAN modes start tagging vmalloc() allocations, kernel
stacks start getting tagged if CONFIG_VMAP_STACK is enabled.

Reset the tag of kernel stack pointers after allocation in
arch_alloc_vmap_stack().

For SW_TAGS KASAN, when CONFIG_KASAN_STACK is enabled, the instrumentation
can't handle the SP register being tagged.

For HW_TAGS KASAN, there's no instrumentation-related issues.  However,
the impact of having a tagged SP register needs to be properly evaluated,
so keep it non-tagged for now.

Note, that the memory for the stack allocation still gets tagged to catch
vmalloc-into-stack out-of-bounds accesses.

[andreyknvl@google.com: fix case when a stack is retrieved from cached_stacks]
  Link: https://lkml.kernel.org/r/f50c5f96ef896d7936192c888b0c0a7674e33184.1644943792.git.andreyknvl@google.com
[dan.carpenter@oracle.com: remove unnecessary check in alloc_thread_stack_node()]
  Link: https://lkml.kernel.org/r/20220301080706.GB17208@kili
Link: https://lkml.kernel.org/r/698c5ab21743c796d46c15d075b9481825973e34.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmap_stack.h |    5 ++++-
 kernel/fork.c                       |   11 ++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/vmap_stack.h~kasan-arm64-reset-pointer-tags-of-vmapped-stacks
+++ a/arch/arm64/include/asm/vmap_stack.h
@@ -17,10 +17,13 @@
  */
 static inline unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node)
 {
+	void *p;
+
 	BUILD_BUG_ON(!IS_ENABLED(CONFIG_VMAP_STACK));
 
-	return __vmalloc_node(stack_size, THREAD_ALIGN, THREADINFO_GFP, node,
+	p = __vmalloc_node(stack_size, THREAD_ALIGN, THREADINFO_GFP, node,
 			__builtin_return_address(0));
+	return kasan_reset_tag(p);
 }
 
 #endif /* __ASM_VMAP_STACK_H */
--- a/kernel/fork.c~kasan-arm64-reset-pointer-tags-of-vmapped-stacks
+++ a/kernel/fork.c
@@ -286,11 +286,13 @@ static int alloc_thread_stack_node(struc
 		if (!s)
 			continue;
 
-		/* Mark stack accessible for KASAN. */
+		/* Reset stack metadata. */
 		kasan_unpoison_range(s->addr, THREAD_SIZE);
 
+		stack = kasan_reset_tag(s->addr);
+
 		/* Clear stale pointers from reused stack. */
-		memset(s->addr, 0, THREAD_SIZE);
+		memset(stack, 0, THREAD_SIZE);
 
 		if (memcg_charge_kernel_stack(s)) {
 			vfree(s->addr);
@@ -298,7 +300,7 @@ static int alloc_thread_stack_node(struc
 		}
 
 		tsk->stack_vm_area = s;
-		tsk->stack = s->addr;
+		tsk->stack = stack;
 		return 0;
 	}
 
@@ -326,8 +328,7 @@ static int alloc_thread_stack_node(struc
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm;
-	if (stack)
-		stack = kasan_reset_tag(stack);
+	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

