Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58643C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiCYWoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiCYWoM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A57E20C186
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47C13B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02262C340ED;
        Fri, 25 Mar 2022 22:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248155;
        bh=uCnysLNWD+wHsJelLpsl1LSanDrUxNQuNT+AhaxFcP4=;
        h=Date:To:From:Subject:From;
        b=rKJCO6Pre4JRC81p+hGrx9/AC0ZXr/xUruxFc9Ol9gzMbX6UxhpPIenYnP+K0iAyU
         SyrkLJ1MYGqxZrQ/xYdsSVlimUvGsv7cs1qRhLkTW1cDJKPRC0d/mQDGyk/h7VjN/A
         q3godemid+2FXUZW/+uikBbtkspi6kypby9bSOOo=
Date:   Fri, 25 Mar 2022 15:42:34 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-documentation-updates.patch removed from -mm tree
Message-Id: <20220325224235.02262C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: documentation updates
has been removed from the -mm tree.  Its filename was
     kasan-documentation-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: documentation updates

Update KASAN documentation:

- Bump Clang version requirement for HW_TAGS as ARM64_MTE depends on
  AS_HAS_LSE_ATOMICS as of commit 2decad92f4731 ("arm64: mte: Ensure
  TIF_MTE_ASYNC_FAULT is set atomically"), which requires Clang 12.
- Add description of the new kasan.vmalloc command line flag.
- Mention that SW_TAGS and HW_TAGS modes now support vmalloc tagging.
- Explicitly say that the "Shadow memory" section is only applicable
  to software KASAN modes.
- Mention that shadow-based KASAN_VMALLOC is supported on arm64.

Link: https://lkml.kernel.org/r/a61189128fa3f9fbcfd9884ff653d401864b8e74.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 Documentation/dev-tools/kasan.rst |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-documentation-updates
+++ a/Documentation/dev-tools/kasan.rst
@@ -30,7 +30,7 @@ Software tag-based KASAN mode is only su
 
 The hardware KASAN mode (#3) relies on hardware to perform the checks but
 still requires a compiler version that supports memory tagging instructions.
-This mode is supported in GCC 10+ and Clang 11+.
+This mode is supported in GCC 10+ and Clang 12+.
 
 Both software KASAN modes work with SLUB and SLAB memory allocators,
 while the hardware tag-based KASAN currently only supports SLUB.
@@ -206,6 +206,9 @@ additional boot parameters that allow di
   Asymmetric mode: a bad access is detected synchronously on reads and
   asynchronously on writes.
 
+- ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
+  allocations (default: ``on``).
+
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
   traces collection (default: ``on``).
 
@@ -279,8 +282,8 @@ Software tag-based KASAN uses 0xFF as a
 pointers with the 0xFF pointer tag are not checked). The value 0xFE is currently
 reserved to tag freed memory regions.
 
-Software tag-based KASAN currently only supports tagging of slab and page_alloc
-memory.
+Software tag-based KASAN currently only supports tagging of slab, page_alloc,
+and vmalloc memory.
 
 Hardware tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -303,8 +306,8 @@ Hardware tag-based KASAN uses 0xFF as a
 pointers with the 0xFF pointer tag are not checked). The value 0xFE is currently
 reserved to tag freed memory regions.
 
-Hardware tag-based KASAN currently only supports tagging of slab and page_alloc
-memory.
+Hardware tag-based KASAN currently only supports tagging of slab, page_alloc,
+and VM_ALLOC-based vmalloc memory.
 
 If the hardware does not support MTE (pre ARMv8.5), hardware tag-based KASAN
 will not be enabled. In this case, all KASAN boot parameters are ignored.
@@ -319,6 +322,8 @@ checking gets disabled.
 Shadow memory
 -------------
 
+The contents of this section are only applicable to software KASAN modes.
+
 The kernel maps memory in several different parts of the address space.
 The range of kernel virtual addresses is large: there is not enough real
 memory to support a real shadow region for every address that could be
@@ -349,7 +354,7 @@ CONFIG_KASAN_VMALLOC
 
 With ``CONFIG_KASAN_VMALLOC``, KASAN can cover vmalloc space at the
 cost of greater memory usage. Currently, this is supported on x86,
-riscv, s390, and powerpc.
+arm64, riscv, s390, and powerpc.
 
 This works by hooking into vmalloc and vmap and dynamically
 allocating real shadow memory to back the mappings.
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

