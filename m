Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C395C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39BBA2086A
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+XemWzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgKXAhm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgKXAhm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:37:42 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2235720757;
        Tue, 24 Nov 2020 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178260;
        bh=uehkWjTxzSqe/nMUoU32y3yuZCRcB8TF7NvtIYvZQiI=;
        h=Date:From:To:Subject:From;
        b=Z+XemWzVsJnP8cj0zjUJTtCY/6HWckbNS931o5TTUcqxsgT3diR097sEJ8N2iK27G
         z9hdEf/cINIRYTvOHNbqLYcXSHsJDbt3lf4xKi+hn7awPoiF2lvuaUkYh19kAuWFK5
         deXI6Mf/A/kyaCL53O/r0ltgpziiy2b5GhD6ncds=
Date:   Mon, 23 Nov 2020 16:37:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 kasan-add-documentation-for-hardware-tag-based-mode.patch added to -mm tree
Message-ID: <20201124003739.Tuy3kOMoT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add documentation for hardware tag-based mode
has been added to the -mm tree.  Its filename is
     kasan-add-documentation-for-hardware-tag-based-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-documentation-for-hardware-tag-based-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-documentation-for-hardware-tag-based-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add documentation for hardware tag-based mode

Add documentation for hardware tag-based KASAN mode and also add some
clarifications for software tag-based mode.

Link: https://lkml.kernel.org/r/20ed1d387685e89fc31be068f890f070ef9fd5d5.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   84 ++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 23 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-add-documentation-for-hardware-tag-based-mode
+++ a/Documentation/dev-tools/kasan.rst
@@ -5,12 +5,14 @@ Overview
 --------
 
 KernelAddressSANitizer (KASAN) is a dynamic memory error detector designed to
-find out-of-bound and use-after-free bugs. KASAN has two modes: generic KASAN
-(similar to userspace ASan) and software tag-based KASAN (similar to userspace
-HWASan).
-
-KASAN uses compile-time instrumentation to insert validity checks before every
-memory access, and therefore requires a compiler version that supports that.
+find out-of-bound and use-after-free bugs. KASAN has three modes:
+1. generic KASAN (similar to userspace ASan),
+2. software tag-based KASAN (similar to userspace HWASan),
+3. hardware tag-based KASAN (based on hardware memory tagging).
+
+Software KASAN modes (1 and 2) use compile-time instrumentation to insert
+validity checks before every memory access, and therefore require a compiler
+version that supports that.
 
 Generic KASAN is supported in both GCC and Clang. With GCC it requires version
 8.3.0 or later. Any supported Clang version is compatible, but detection of
@@ -19,7 +21,7 @@ out-of-bounds accesses for global variab
 Tag-based KASAN is only supported in Clang.
 
 Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
-and riscv architectures, and tag-based KASAN is supported only for arm64.
+and riscv architectures, and tag-based KASAN modes are supported only for arm64.
 
 Usage
 -----
@@ -28,14 +30,16 @@ To enable KASAN configure kernel with::
 
 	  CONFIG_KASAN = y
 
-and choose between CONFIG_KASAN_GENERIC (to enable generic KASAN) and
-CONFIG_KASAN_SW_TAGS (to enable software tag-based KASAN).
-
-You also need to choose between CONFIG_KASAN_OUTLINE and CONFIG_KASAN_INLINE.
-Outline and inline are compiler instrumentation types. The former produces
-smaller binary while the latter is 1.1 - 2 times faster.
+and choose between CONFIG_KASAN_GENERIC (to enable generic KASAN),
+CONFIG_KASAN_SW_TAGS (to enable software tag-based KASAN), and
+CONFIG_KASAN_HW_TAGS (to enable hardware tag-based KASAN).
+
+For software modes, you also need to choose between CONFIG_KASAN_OUTLINE and
+CONFIG_KASAN_INLINE. Outline and inline are compiler instrumentation types.
+The former produces smaller binary while the latter is 1.1 - 2 times faster.
 
-Both KASAN modes work with both SLUB and SLAB memory allocators.
+Both software KASAN modes work with both SLUB and SLAB memory allocators,
+hardware tag-based KASAN currently only support SLUB.
 For better bug detection and nicer reporting, enable CONFIG_STACKTRACE.
 
 To augment reports with last allocation and freeing stack of the physical page,
@@ -196,17 +200,24 @@ and the second to last.
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-Tag-based KASAN uses the Top Byte Ignore (TBI) feature of modern arm64 CPUs to
-store a pointer tag in the top byte of kernel pointers. Like generic KASAN it
-uses shadow memory to store memory tags associated with each 16-byte memory
+Software tag-based KASAN requires software memory tagging support in the form
+of HWASan-like compiler instrumentation (see HWASan documentation for details).
+
+Software tag-based KASAN is currently only implemented for arm64 architecture.
+
+Software tag-based KASAN uses the Top Byte Ignore (TBI) feature of arm64 CPUs
+to store a pointer tag in the top byte of kernel pointers. Like generic KASAN
+it uses shadow memory to store memory tags associated with each 16-byte memory
 cell (therefore it dedicates 1/16th of the kernel memory for shadow memory).
 
-On each memory allocation tag-based KASAN generates a random tag, tags the
-allocated memory with this tag, and embeds this tag into the returned pointer.
+On each memory allocation software tag-based KASAN generates a random tag, tags
+the allocated memory with this tag, and embeds this tag into the returned
+pointer.
+
 Software tag-based KASAN uses compile-time instrumentation to insert checks
 before each memory access. These checks make sure that tag of the memory that
 is being accessed is equal to tag of the pointer that is used to access this
-memory. In case of a tag mismatch tag-based KASAN prints a bug report.
+memory. In case of a tag mismatch software tag-based KASAN prints a bug report.
 
 Software tag-based KASAN also has two instrumentation modes (outline, that
 emits callbacks to check memory accesses; and inline, that performs the shadow
@@ -215,9 +226,36 @@ simply printed from the function that pe
 instrumentation a brk instruction is emitted by the compiler, and a dedicated
 brk handler is used to print bug reports.
 
-A potential expansion of this mode is a hardware tag-based mode, which would
-use hardware memory tagging support instead of compiler instrumentation and
-manual shadow memory manipulation.
+Software tag-based KASAN uses 0xFF as a match-all pointer tag (accesses through
+pointers with 0xFF pointer tag aren't checked). The value 0xFE is currently
+reserved to tag freed memory regions.
+
+Software tag-based KASAN currently only supports tagging of
+kmem_cache_alloc/kmalloc and page_alloc memory.
+
+Hardware tag-based KASAN
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Hardware tag-based KASAN is similar to the software mode in concept, but uses
+hardware memory tagging support instead of compiler instrumentation and
+shadow memory.
+
+Hardware tag-based KASAN is currently only implemented for arm64 architecture
+and based on both arm64 Memory Tagging Extension (MTE) introduced in ARMv8.5
+Instruction Set Architecture, and Top Byte Ignore (TBI).
+
+Special arm64 instructions are used to assign memory tags for each allocation.
+Same tags are assigned to pointers to those allocations. On every memory
+access, hardware makes sure that tag of the memory that is being accessed is
+equal to tag of the pointer that is used to access this memory. In case of a
+tag mismatch a fault is generated and a report is printed.
+
+Hardware tag-based KASAN uses 0xFF as a match-all pointer tag (accesses through
+pointers with 0xFF pointer tag aren't checked). The value 0xFE is currently
+reserved to tag freed memory regions.
+
+Hardware tag-based KASAN currently only supports tagging of
+kmem_cache_alloc/kmalloc and page_alloc memory.
 
 What memory accesses are sanitised by KASAN?
 --------------------------------------------
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_range.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_memory_per_shadow_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-open-code-kasan_unpoison_slab.patch
kasan-inline-unpoison_range-and-check_invalid_free.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-sanitize-objects-when-metadata-doesnt-fit.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

