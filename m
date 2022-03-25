Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F478C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiCYWo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiCYWoH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E81209A63
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18AF5CE2BA2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B488C340ED;
        Fri, 25 Mar 2022 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248148;
        bh=DfkMpvQjo1/Y4wPrwHL6m/QhiLbred/3OVnIiqS9wAg=;
        h=Date:To:From:Subject:From;
        b=0EJoGX17pAB/Eu4ULS2ERWYkLcBSYBkP7nEdq+zo+oxu1Z/71rVu8MfQbo+AcQcnu
         XDt4hVpCWtc8WPOv2ZOYmCG/AEDzWtpIM1cfAxsCBFOhQzhoO6XU+PbnS/b/5s3X7G
         K4dOZR7hx+gH13T1aPoWXg1hfKbkgKX+mLGS/xkk=
Date:   Fri, 25 Mar 2022 15:42:27 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-arm64-dont-tag-executable-vmalloc-allocations.patch removed from -mm tree
Message-Id: <20220325224228.7B488C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: don't tag executable vmalloc allocations
has been removed from the -mm tree.  Its filename was
     kasan-arm64-dont-tag-executable-vmalloc-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

