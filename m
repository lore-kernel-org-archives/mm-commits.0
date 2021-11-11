Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D716C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8825761247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhKKCqU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A12F461208;
        Thu, 11 Nov 2021 02:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598611;
        bh=w5c/OC0Gzmr+WiOYrvN3ruL/1w72ohf6U6ny0/nexEs=;
        h=Date:From:To:Subject:From;
        b=UdMaHSUC6Ptn48L9aEkPztkERlxIXfaIxzAGzUDOTIszY6KNI4Xm5yohWDyug+s23
         KkHTeIkcQ6KhJLM/NmEGMLkoVTDUlYDcA3NrJPk2t3OquW1t7Gs1pFWf/jUIvnG2jG
         dM6Zwrc3Z24p+04Tb1TZPtu+vXYnH51T1myvnwqw=
Date:   Wed, 10 Nov 2021 18:43:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged]
 vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch
 removed from -mm tree
Message-ID: <20211111024330.LgB9QPih-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: choose a better start address in vm_area_register_early()
has been removed from the -mm tree.  Its filename was
     vmalloc-choose-a-better-start-address-in-vm_area_register_early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
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


