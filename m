Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B13C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348871AbiCYBMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354793AbiCYBMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA97BD2D2
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081E161857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D277C340EC;
        Fri, 25 Mar 2022 01:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170668;
        bh=WB80sFaBxyAUXBG5EJJVF/0zD2Pwiyr+4hsi276rbCI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=AxSGhCLZoKYIKvIWV/SU2NGHBQOa+jFZJ1kcvW0yXhsJiVpQohyS4p0VNq2mki3gE
         Ty3DZx36eaoyVr7ufH0kErgJj233FZP3NQAWh8zROu+q4sHoNTa302Aaj6ng1Ri9h2
         083QdsYNQsvJOOpLm1ZESjvs8Zom6/TscQkxzCCM=
Date:   Thu, 24 Mar 2022 18:11:07 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 051/114] kasan, fork: reset pointer tags of vmapped stacks
Message-Id: <20220325011108.5D277C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
