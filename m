Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB6EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiCYWoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiCYWn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D73320C182
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28138614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EE7C004DD;
        Fri, 25 Mar 2022 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248137;
        bh=bxBcAtedRMVkLmIfKBq21fjEHF31WAp+Rrgp+j8lo0I=;
        h=Date:To:From:Subject:From;
        b=VKOfxsUK8bk9NUOVOryntBXtZcRmaGFlzJ8WYL/rEjUp1gv9Lzdas50bamwtI5PrB
         +gqPAJcE3LULeIfP5q4w+et6sCdGTqJ5HY90VNQZoXujyTv7QA2BFIvwqSwE8HUeo6
         ylxTFKtZyEzppqVP/wrH7hpL2MHHAeEkQrhwTPcU=
Date:   Fri, 25 Mar 2022 15:42:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch removed from -mm tree
Message-Id: <20220325224217.82EE7C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, fork: reset pointer tags of vmapped stacks
has been removed from the -mm tree.  Its filename was
     kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, fork: reset pointer tags of vmapped stacks

Once tag-based KASAN modes start tagging vmalloc() allocations, kernel
stacks start getting tagged if CONFIG_VMAP_STACK is enabled.

Reset the tag of kernel stack pointers after allocation in
alloc_thread_stack_node().

For SW_TAGS KASAN, when CONFIG_KASAN_STACK is enabled, the instrumentation
can't handle the SP register being tagged.

For HW_TAGS KASAN, there's no instrumentation-related issues.  However,
the impact of having a tagged SP register needs to be properly evaluated,
so keep it non-tagged for now.

Note, that the memory for the stack allocation still gets tagged to catch
vmalloc-into-stack out-of-bounds accesses.

Link: https://lkml.kernel.org/r/c6c96f012371ecd80e1936509ebcd3b07a5956f7.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/fork.c~kasan-fork-reset-pointer-tags-of-vmapped-stacks
+++ a/kernel/fork.c
@@ -326,6 +326,8 @@ static int alloc_thread_stack_node(struc
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm;
+	if (stack)
+		stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

