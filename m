Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E668C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357230AbiCYBNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357250AbiCYBNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91701BD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E84B8270B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E1FC340EC;
        Fri, 25 Mar 2022 01:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170698;
        bh=RyJAVSMEYSZuS2tRPXKdVcXhXAw5OR1haUkYUe+AGII=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WcdNqn3qwYLo7AgWRyDqCXPzDGlVsxQpIJZCVDQQE76V1ArvhAtQ2DD7SwSMABeHs
         Mn6g60/cBbVoIy5rBr/pgUyM3hg8HmTWx4tOVjIzv7vQOA3nZ5vKS8Lz1QZmoioFYt
         W8ocfcnN+DYIa7B86thPibbJOo5Ktwo1RDx9xQm4=
Date:   Thu, 24 Mar 2022 18:11:38 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 061/114] kasan, arm64: don't tag executable vmalloc allocations
Message-Id: <20220325011138.D8E1FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: don't tag executable vmalloc allocations

Besides asking vmalloc memory to be executable via the prot argument of
__vmalloc_node_range() (see the previous patch), the kernel can skip that
bit and instead mark memory as executable via set_memory_x().

Once tag-based KASAN modes start tagging vmalloc allocations, executing
code from such allocations will lead to the PC register getting a tag,
which is not tolerated by the kernel.

Generic kernel code typically allocates memory via module_alloc() if it
intends to mark memory as executable.  (On arm64 module_alloc() uses
__vmalloc_node_range() without setting the executable bit).

Thus, reset pointer tags of pointers returned from module_alloc().

However, on arm64 there's an exception: the eBPF subsystem.  Instead of
using module_alloc(), it uses vmalloc() (via bpf_jit_alloc_exec()) to
allocate its JIT region.

Thus, reset pointer tags of pointers returned from bpf_jit_alloc_exec().

Resetting tags for these pointers results in untagged pointers being
passed to set_memory_x().  This causes conflicts in arithmetic checks in
change_memory_common(), as vm_struct->addr pointer returned by
find_vm_area() is tagged.

Reset pointer tag of find_vm_area(addr)->addr in change_memory_common().

Link: https://lkml.kernel.org/r/b7b2595423340cd7d76b770e5d519acf3b72f0ab.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marco Elver <elver@google.com>
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

 arch/arm64/kernel/module.c    |    3 ++-
 arch/arm64/mm/pageattr.c      |    2 +-
 arch/arm64/net/bpf_jit_comp.c |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/module.c~kasan-arm64-dont-tag-executable-vmalloc-allocations
+++ a/arch/arm64/kernel/module.c
@@ -63,7 +63,8 @@ void *module_alloc(unsigned long size)
 		return NULL;
 	}
 
-	return p;
+	/* Memory is intended to be executable, reset the pointer tag. */
+	return kasan_reset_tag(p);
 }
 
 enum aarch64_reloc_op {
--- a/arch/arm64/mm/pageattr.c~kasan-arm64-dont-tag-executable-vmalloc-allocations
+++ a/arch/arm64/mm/pageattr.c
@@ -85,7 +85,7 @@ static int change_memory_common(unsigned
 	 */
 	area = find_vm_area((void *)addr);
 	if (!area ||
-	    end > (unsigned long)area->addr + area->size ||
+	    end > (unsigned long)kasan_reset_tag(area->addr) + area->size ||
 	    !(area->flags & VM_ALLOC))
 		return -EINVAL;
 
--- a/arch/arm64/net/bpf_jit_comp.c~kasan-arm64-dont-tag-executable-vmalloc-allocations
+++ a/arch/arm64/net/bpf_jit_comp.c
@@ -1304,7 +1304,8 @@ u64 bpf_jit_alloc_exec_limit(void)
 
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return vmalloc(size);
+	/* Memory is intended to be executable, reset the pointer tag. */
+	return kasan_reset_tag(vmalloc(size));
 }
 
 void bpf_jit_free_exec(void *addr)
_
