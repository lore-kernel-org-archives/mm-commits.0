Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06A1C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8344F60E74
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhJJVjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhJJVjS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFDC60F22;
        Sun, 10 Oct 2021 21:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633901839;
        bh=EdM/UsKXtdYon5vk2ECalovjPJbkeptcesNUf+EsEps=;
        h=Date:From:To:Subject:From;
        b=tjgYq/zFcSYc4iYOI2B48pvXeU4GS6+KyN3Hmdr9Bc5D/8cjxGhnGDneJtQJSjGp7
         E92uDSLHHBCYqaBAgfOeOSLfLYgijKGcCp21LsTAeTIldvkG7aBAdbOZq6MOVmhswu
         UArhe/JR/CZU3/FuwkkuQutdqQenTEY5K1Q8Q5b0=
Date:   Sun, 10 Oct 2021 14:37:18 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  +
 vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch added
 to -mm tree
Message-ID: <20211010213718.yBhuyIo30%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: choose a better start address in vm_area_register_early()
has been added to the -mm tree.  Its filename is
     vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: vmalloc: choose a better start address in vm_area_register_early()

Percpu embedded first chunk allocator is the firstly option, but it could
fail on ARM64, eg,

  "percpu: max_distance=0x5fcfdc640000 too large for vmalloc space 0x781fefff0000"
  "percpu: max_distance=0x600000540000 too large for vmalloc space 0x7dffb7ff0000"
  "percpu: max_distance=0x5fff9adb0000 too large for vmalloc space 0x5dffb7ff0000"

then we could meet "WARNING: CPU: 15 PID: 461 at vmalloc.c:3087
pcpu_get_vm_areas+0x488/0x838" and the system cannot boot successfully.

Let's implement page mapping percpu first chunk allocator as a fallback to
the embedding allocator to increase the robustness of the system.

Also fix a crash when both NEED_PER_CPU_PAGE_FIRST_CHUNK and KASAN_VMALLOC
enabled.

Tested on ARM64 qemu with cmdline "percpu_alloc=page".


This patch (of 3):

There are some fixed locations in the vmalloc area be reserved in ARM(see
iotable_init()) and ARM64(see map_kernel()), but for
pcpu_page_first_chunk(), it calls vm_area_register_early() and choose
VMALLOC_START as the start address of vmap area which could be conflicted
with above address, then could trigger a BUG_ON in vm_area_add_early().

Let's choose a suit start address by traversing the vmlist.

Link: https://lkml.kernel.org/r/20210910053354.26721-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20210910053354.26721-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~vmalloc-choose-a-better-start-address-in-vm_area_register_early
+++ a/mm/vmalloc.c
@@ -2276,15 +2276,21 @@ void __init vm_area_add_early(struct vm_
  */
 void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 {
-	static size_t vm_init_off __initdata;
-	unsigned long addr;
+	unsigned long addr = ALIGN(VMALLOC_START, align);
+	struct vm_struct *cur, **p;
 
-	addr = ALIGN(VMALLOC_START + vm_init_off, align);
-	vm_init_off = PFN_ALIGN(addr + vm->size) - VMALLOC_START;
+	BUG_ON(vmap_initialized);
 
-	vm->addr = (void *)addr;
+	for (p = &vmlist; (cur = *p) != NULL; p = &cur->next) {
+		if ((unsigned long)cur->addr - addr >= vm->size)
+			break;
+		addr = ALIGN((unsigned long)cur->addr + cur->size, align);
+	}
 
-	vm_area_add_early(vm);
+	BUG_ON(addr > VMALLOC_END - vm->size);
+	vm->addr = (void *)addr;
+	vm->next = *p;
+	*p = vm;
 }
 
 static void vmap_init_free_space(void)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch
arm64-support-page-mapping-percpu-first-chunk-allocator.patch
kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch

