Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D98C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjBCGhz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjBCGgg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344CC8BDDE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2BF161D9B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16620C433D2;
        Fri,  3 Feb 2023 06:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406183;
        bh=iTMvLdPmTKKH/Fi4FoM4L+/owALzwqqFdX7qvyan8rE=;
        h=Date:To:From:Subject:From;
        b=jXdJZCdW/h/KAFvjZygtLEoX9dNtQWCb04XJNvmljRRJrXmNcuWHgvwOUknE2sb7r
         buof8rbPPawdjgdq5ojwH68dGIrQlVx7MXveRDNxvg58+h8KYDJv46Q3OXKCkmc7KK
         W9SbISDCX8LpCovom5k7iE2BVIbS3P096sH9rg88=
Date:   Thu, 02 Feb 2023 22:36:22 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        mingo@redhat.com, lkp@intel.com, elver@google.com,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-silence-wmissing-prototypes-warnings.patch removed from -mm tree
Message-Id: <20230203063623.16620C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: silence -Wmissing-prototypes warnings
has been removed from the -mm tree.  Its filename was
     kmsan-silence-wmissing-prototypes-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: silence -Wmissing-prototypes warnings
Date: Thu, 12 Jan 2023 11:31:47 +0100

When building the kernel with W=1, the compiler reports numerous warnings
about the missing prototypes for KMSAN instrumentation hooks.

Because these functions are not supposed to be called explicitly by the
kernel code (calls to them are emitted by the compiler), they do not have
to be declared in the headers.  Instead, we add forward declarations right
before the definitions to silence the warnings produced by
-Wmissing-prototypes.

Link: https://lkml.kernel.org/r/20230112103147.382416-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/lkml/202301020356.dFruA4I5-lkp@intel.com/T/
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmsan/instrumentation.c~kmsan-silence-wmissing-prototypes-warnings
+++ a/mm/kmsan/instrumentation.c
@@ -38,8 +38,16 @@ get_shadow_origin_ptr(void *addr, u64 si
 	return ret;
 }
 
+/*
+ * KMSAN instrumentation functions follow. They are not declared elsewhere in
+ * the kernel code, so they are preceded by prototypes, to silence
+ * -Wmissing-prototypes warnings.
+ */
+
 /* Get shadow and origin pointers for a memory load with non-standard size. */
 struct shadow_origin_ptr __msan_metadata_ptr_for_load_n(void *addr,
+							uintptr_t size);
+struct shadow_origin_ptr __msan_metadata_ptr_for_load_n(void *addr,
 							uintptr_t size)
 {
 	return get_shadow_origin_ptr(addr, size, /*store*/ false);
@@ -48,6 +56,8 @@ EXPORT_SYMBOL(__msan_metadata_ptr_for_lo
 
 /* Get shadow and origin pointers for a memory store with non-standard size. */
 struct shadow_origin_ptr __msan_metadata_ptr_for_store_n(void *addr,
+							 uintptr_t size);
+struct shadow_origin_ptr __msan_metadata_ptr_for_store_n(void *addr,
 							 uintptr_t size)
 {
 	return get_shadow_origin_ptr(addr, size, /*store*/ true);
@@ -60,12 +70,16 @@ EXPORT_SYMBOL(__msan_metadata_ptr_for_st
  */
 #define DECLARE_METADATA_PTR_GETTER(size)                                  \
 	struct shadow_origin_ptr __msan_metadata_ptr_for_load_##size(      \
+		void *addr);                                               \
+	struct shadow_origin_ptr __msan_metadata_ptr_for_load_##size(      \
 		void *addr)                                                \
 	{                                                                  \
 		return get_shadow_origin_ptr(addr, size, /*store*/ false); \
 	}                                                                  \
 	EXPORT_SYMBOL(__msan_metadata_ptr_for_load_##size);                \
 	struct shadow_origin_ptr __msan_metadata_ptr_for_store_##size(     \
+		void *addr);                                               \
+	struct shadow_origin_ptr __msan_metadata_ptr_for_store_##size(     \
 		void *addr)                                                \
 	{                                                                  \
 		return get_shadow_origin_ptr(addr, size, /*store*/ true);  \
@@ -86,6 +100,7 @@ DECLARE_METADATA_PTR_GETTER(8);
  * entering or leaving IRQ. We omit the check for kmsan_in_runtime() to ensure
  * the memory written to in these cases is also marked as initialized.
  */
+void __msan_instrument_asm_store(void *addr, uintptr_t size);
 void __msan_instrument_asm_store(void *addr, uintptr_t size)
 {
 	unsigned long ua_flags;
@@ -138,6 +153,7 @@ static inline void set_retval_metadata(u
 }
 
 /* Handle llvm.memmove intrinsic. */
+void *__msan_memmove(void *dst, const void *src, uintptr_t n);
 void *__msan_memmove(void *dst, const void *src, uintptr_t n)
 {
 	depot_stack_handle_t origin;
@@ -162,6 +178,7 @@ void *__msan_memmove(void *dst, const vo
 EXPORT_SYMBOL(__msan_memmove);
 
 /* Handle llvm.memcpy intrinsic. */
+void *__msan_memcpy(void *dst, const void *src, uintptr_t n);
 void *__msan_memcpy(void *dst, const void *src, uintptr_t n)
 {
 	depot_stack_handle_t origin;
@@ -188,6 +205,7 @@ void *__msan_memcpy(void *dst, const voi
 EXPORT_SYMBOL(__msan_memcpy);
 
 /* Handle llvm.memset intrinsic. */
+void *__msan_memset(void *dst, int c, uintptr_t n);
 void *__msan_memset(void *dst, int c, uintptr_t n)
 {
 	depot_stack_handle_t origin;
@@ -217,6 +235,7 @@ EXPORT_SYMBOL(__msan_memset);
  * uninitialized value to memory. When reporting an error, KMSAN unrolls and
  * prints the whole chain of stores that preceded the use of this value.
  */
+depot_stack_handle_t __msan_chain_origin(depot_stack_handle_t origin);
 depot_stack_handle_t __msan_chain_origin(depot_stack_handle_t origin)
 {
 	depot_stack_handle_t ret = 0;
@@ -237,6 +256,7 @@ depot_stack_handle_t __msan_chain_origin
 EXPORT_SYMBOL(__msan_chain_origin);
 
 /* Poison a local variable when entering a function. */
+void __msan_poison_alloca(void *address, uintptr_t size, char *descr);
 void __msan_poison_alloca(void *address, uintptr_t size, char *descr)
 {
 	depot_stack_handle_t handle;
@@ -272,6 +292,7 @@ void __msan_poison_alloca(void *address,
 EXPORT_SYMBOL(__msan_poison_alloca);
 
 /* Unpoison a local variable. */
+void __msan_unpoison_alloca(void *address, uintptr_t size);
 void __msan_unpoison_alloca(void *address, uintptr_t size)
 {
 	if (!kmsan_enabled || kmsan_in_runtime())
@@ -287,6 +308,7 @@ EXPORT_SYMBOL(__msan_unpoison_alloca);
  * Report that an uninitialized value with the given origin was used in a way
  * that constituted undefined behavior.
  */
+void __msan_warning(u32 origin);
 void __msan_warning(u32 origin)
 {
 	if (!kmsan_enabled || kmsan_in_runtime())
@@ -303,6 +325,7 @@ EXPORT_SYMBOL(__msan_warning);
  * At the beginning of an instrumented function, obtain the pointer to
  * `struct kmsan_context_state` holding the metadata for function parameters.
  */
+struct kmsan_context_state *__msan_get_context_state(void);
 struct kmsan_context_state *__msan_get_context_state(void)
 {
 	return &kmsan_get_context()->cstate;
_

Patches currently in -mm which might be from glider@google.com are

fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch
fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate.patch

