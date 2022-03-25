Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D416FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiCYWoM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiCYWn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFE220A97A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C06BFCE2BA1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3F2C004DD;
        Fri, 25 Mar 2022 22:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248133;
        bh=MryigdsAP0u/Xp2pBPlcXhwgThprijygFNdu/kzntws=;
        h=Date:To:From:Subject:From;
        b=XsKsKsnoUhtvcxtVJqBkndeBv4tS0o0EgYsc2cQuYnPy/BXC7cc3yG3wBg+3tZh32
         reI//AcnhqTY2rVHz6V2EwSQVGeblu2xm55V9Rn9Z9OyZYcfMKl0nCv2K41DkMEbwm
         KFg+0Tpx6BayTg7dD2JEZG7NgUB1C6cEGe76Tn2Y=
Date:   Fri, 25 Mar 2022 15:42:12 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-vmalloc-drop-outdated-vm_kasan-comment.patch removed from -mm tree
Message-Id: <20220325224213.2E3F2C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, vmalloc: drop outdated VM_KASAN comment
has been removed from the -mm tree.  Its filename was
     kasan-vmalloc-drop-outdated-vm_kasan-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: drop outdated VM_KASAN comment

The comment about VM_KASAN in include/linux/vmalloc.c is outdated. 
VM_KASAN is currently only used to mark vm_areas allocated for kernel
modules when CONFIG_KASAN_VMALLOC is disabled.

Drop the comment.

Link: https://lkml.kernel.org/r/780395afea83a147b3b5acc36cf2e38f7f8479f9.1643047180.git.andreyknvl@google.com
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

 include/linux/vmalloc.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/vmalloc.h~kasan-vmalloc-drop-outdated-vm_kasan-comment
+++ a/include/linux/vmalloc.h
@@ -35,17 +35,6 @@ struct notifier_block;		/* in notifier.h
 #define VM_DEFER_KMEMLEAK	0
 #endif
 
-/*
- * VM_KASAN is used slightly differently depending on CONFIG_KASAN_VMALLOC.
- *
- * If IS_ENABLED(CONFIG_KASAN_VMALLOC), VM_KASAN is set on a vm_struct after
- * shadow memory has been mapped. It's used to handle allocation errors so that
- * we don't try to poison shadow on free if it was never allocated.
- *
- * Otherwise, VM_KASAN is set for kasan_module_alloc() allocations and used to
- * determine which allocations need the module shadow freed.
- */
-
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

