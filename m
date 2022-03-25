Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76701C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiCYWoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiCYWn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E4520C183
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B27B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D217C340ED;
        Fri, 25 Mar 2022 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248136;
        bh=HgWOwHNZxyt/Ga5PhtL+3RBPhoaI1QHNTjUUCdHueI4=;
        h=Date:To:From:Subject:From;
        b=X2v6nCkNr9rVnt/efCpTn+x7fT2Q0cjT8VKllSKkXeep6b9KExv628wA2K82NtU8g
         Ahv95dBPPG9Y8s4ILMUFw5ANzFfHsRGTf8udvqxcrqfiu04+Xrmg1b29Bm7qJnaDcX
         aZIJ0ZMRhGGnW/kBFShRkIndsWNdoqTfIbcVO4J8=
Date:   Fri, 25 Mar 2022 15:42:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-vmalloc-reset-tags-in-vmalloc-functions.patch removed from -mm tree
Message-Id: <20220325224216.6D217C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, vmalloc: reset tags in vmalloc functions
has been removed from the -mm tree.  Its filename was
     kasan-vmalloc-reset-tags-in-vmalloc-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: reset tags in vmalloc functions

In preparation for adding vmalloc support to SW/HW_TAGS KASAN, reset
pointer tags in functions that use pointer values in range checks.

vread() is a special case here.  Despite the untagging of the addr pointer
in its prologue, the accesses performed by vread() are checked.

Instead of accessing the virtual mappings though addr directly, vread()
recovers the physical address via page_address(vmalloc_to_page()) and
acceses that.  And as page_address() recovers the pointer tag, the
accesses get checked.

Link: https://lkml.kernel.org/r/046003c5f683cacb0ba18e1079e9688bb3dca943.1643047180.git.andreyknvl@google.com
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

 mm/vmalloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~kasan-vmalloc-reset-tags-in-vmalloc-functions
+++ a/mm/vmalloc.c
@@ -74,7 +74,7 @@ static const bool vmap_allow_huge = fals
 
 bool is_vmalloc_addr(const void *x)
 {
-	unsigned long addr = (unsigned long)x;
+	unsigned long addr = (unsigned long)kasan_reset_tag(x);
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
@@ -631,7 +631,7 @@ int is_vmalloc_or_module_addr(const void
 	 * just put it in the vmalloc space.
 	 */
 #if defined(CONFIG_MODULES) && defined(MODULES_VADDR)
-	unsigned long addr = (unsigned long)x;
+	unsigned long addr = (unsigned long)kasan_reset_tag(x);
 	if (addr >= MODULES_VADDR && addr < MODULES_END)
 		return 1;
 #endif
@@ -795,6 +795,8 @@ static struct vmap_area *find_vmap_area_
 	struct vmap_area *va = NULL;
 	struct rb_node *n = vmap_area_root.rb_node;
 
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+
 	while (n) {
 		struct vmap_area *tmp;
 
@@ -816,6 +818,8 @@ static struct vmap_area *__find_vmap_are
 {
 	struct rb_node *n = vmap_area_root.rb_node;
 
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+
 	while (n) {
 		struct vmap_area *va;
 
@@ -2166,7 +2170,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 void vm_unmap_ram(const void *mem, unsigned int count)
 {
 	unsigned long size = (unsigned long)count << PAGE_SHIFT;
-	unsigned long addr = (unsigned long)mem;
+	unsigned long addr = (unsigned long)kasan_reset_tag(mem);
 	struct vmap_area *va;
 
 	might_sleep();
@@ -3424,6 +3428,8 @@ long vread(char *buf, char *addr, unsign
 	unsigned long buflen = count;
 	unsigned long n;
 
+	addr = kasan_reset_tag(addr);
+
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

