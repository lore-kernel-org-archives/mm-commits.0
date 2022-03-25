Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB4C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353132AbiCYBMs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348871AbiCYBMk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4226BD2D0
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A48C7B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F12C340EC;
        Fri, 25 Mar 2022 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170665;
        bh=KQIM7u8S5bzgJDDRS+TbbA8lbuOXugv7CqGeHH4+RWc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=UTc9t1HdOR7EgghOe2xDBF3Z9KSF7UIw43pS70850DX4SW3fa3FALkuLggb70u+SM
         q/RAZB1FNjYRbHxvVMhaZ/grMrqsgue/i0xgEeFeFIvWPgoJbrpGPCpoI4dBWpFxiJ
         r1Mnp2pLtISOwPLLFxxTmeh661VYJQsLa2rX2QUE=
Date:   Thu, 24 Mar 2022 18:11:04 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 050/114] kasan, vmalloc: reset tags in vmalloc functions
Message-Id: <20220325011105.55F12C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
