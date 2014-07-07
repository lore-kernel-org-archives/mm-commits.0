From: akpm@linux-foundation.org
Subject: + mm-vmallocc-clean-up-map_vm_area-third-argument.patch added to
 -mm tree
Date: Mon, 07 Jul 2014 13:50:06 -0700
Message-ID: <53bb07fe.FYNKmt17QAkGrjCs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:61119 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:50:07 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1050271pab.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:50:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaowang@redhat.com, gregkh@linuxfoundation.org, minchan@kernel.org, ngupta@vflare.org, rusty@rustcorp.com.au, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: clean up map_vm_area third argument
has been added to the -mm tree.  Its filename is
     mm-vmallocc-clean-up-map_vm_area-third-argument.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-clean-up-map_vm_area-third-argument.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-clean-up-map_vm_area-third-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: mm/vmalloc.c: clean up map_vm_area third argument

Currently map_vm_area() takes (struct page *** pages) as third argument,
and after mapping, it moves (*pages) to point to (*pages +
nr_mappped_pages).

It looks like this kind of increment is useless to its caller these days. 
The callers don't care about the increments and actually they're trying to
avoid this by passing another copy to map_vm_area().

The caller can always guarantee all the pages can be mapped into vm_area
as specified in first argument and the caller only cares about whether
map_vm_area() fails or not.

This patch cleans up the pointer movement in map_vm_area() and updates
its callers accordingly.

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c            |    7 ++-----
 drivers/staging/android/binder.c |    4 +---
 include/linux/vmalloc.h          |    2 +-
 mm/vmalloc.c                     |   14 +++++---------
 mm/zsmalloc.c                    |    2 +-
 5 files changed, 10 insertions(+), 19 deletions(-)

diff -puN drivers/lguest/core.c~mm-vmallocc-clean-up-map_vm_area-third-argument drivers/lguest/core.c
--- a/drivers/lguest/core.c~mm-vmallocc-clean-up-map_vm_area-third-argument
+++ a/drivers/lguest/core.c
@@ -42,7 +42,6 @@ DEFINE_MUTEX(lguest_lock);
 static __init int map_switcher(void)
 {
 	int i, err;
-	struct page **pagep;
 
 	/*
 	 * Map the Switcher in to high memory.
@@ -110,11 +109,9 @@ static __init int map_switcher(void)
 	 * This code actually sets up the pages we've allocated to appear at
 	 * switcher_addr.  map_vm_area() takes the vma we allocated above, the
 	 * kind of pages we're mapping (kernel pages), and a pointer to our
-	 * array of struct pages.  It increments that pointer, but we don't
-	 * care.
+	 * array of struct pages.
 	 */
-	pagep = lg_switcher_pages;
-	err = map_vm_area(switcher_vma, PAGE_KERNEL_EXEC, &pagep);
+	err = map_vm_area(switcher_vma, PAGE_KERNEL_EXEC, lg_switcher_pages);
 	if (err) {
 		printk("lguest: map_vm_area failed: %i\n", err);
 		goto free_vma;
diff -puN drivers/staging/android/binder.c~mm-vmallocc-clean-up-map_vm_area-third-argument drivers/staging/android/binder.c
--- a/drivers/staging/android/binder.c~mm-vmallocc-clean-up-map_vm_area-third-argument
+++ a/drivers/staging/android/binder.c
@@ -586,7 +586,6 @@ static int binder_update_page_range(stru
 
 	for (page_addr = start; page_addr < end; page_addr += PAGE_SIZE) {
 		int ret;
-		struct page **page_array_ptr;
 
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 
@@ -599,8 +598,7 @@ static int binder_update_page_range(stru
 		}
 		tmp_area.addr = page_addr;
 		tmp_area.size = PAGE_SIZE + PAGE_SIZE /* guard page? */;
-		page_array_ptr = page;
-		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
+		ret = map_vm_area(&tmp_area, PAGE_KERNEL, page);
 		if (ret) {
 			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
 			       proc->pid, page_addr);
diff -puN include/linux/vmalloc.h~mm-vmallocc-clean-up-map_vm_area-third-argument include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmallocc-clean-up-map_vm_area-third-argument
+++ a/include/linux/vmalloc.h
@@ -113,7 +113,7 @@ extern struct vm_struct *remove_vm_area(
 extern struct vm_struct *find_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
-			struct page ***pages);
+			struct page **pages);
 #ifdef CONFIG_MMU
 extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
 				    pgprot_t prot, struct page **pages);
diff -puN mm/vmalloc.c~mm-vmallocc-clean-up-map_vm_area-third-argument mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-clean-up-map_vm_area-third-argument
+++ a/mm/vmalloc.c
@@ -1270,19 +1270,15 @@ void unmap_kernel_range(unsigned long ad
 }
 EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
-int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
+int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page **pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
-	err = vmap_page_range(addr, end, prot, *pages);
-	if (err > 0) {
-		*pages += err;
-		err = 0;
-	}
+	err = vmap_page_range(addr, end, prot, pages);
 
-	return err;
+	return err > 0 ? 0 : err;
 }
 EXPORT_SYMBOL_GPL(map_vm_area);
 
@@ -1548,7 +1544,7 @@ void *vmap(struct page **pages, unsigned
 	if (!area)
 		return NULL;
 
-	if (map_vm_area(area, prot, &pages)) {
+	if (map_vm_area(area, prot, pages)) {
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -1606,7 +1602,7 @@ static void *__vmalloc_area_node(struct
 			cond_resched();
 	}
 
-	if (map_vm_area(area, prot, &pages))
+	if (map_vm_area(area, prot, pages))
 		goto fail;
 	return area->addr;
 
diff -puN mm/zsmalloc.c~mm-vmallocc-clean-up-map_vm_area-third-argument mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-vmallocc-clean-up-map_vm_area-third-argument
+++ a/mm/zsmalloc.c
@@ -690,7 +690,7 @@ static inline void __zs_cpu_down(struct
 static inline void *__zs_map_object(struct mapping_area *area,
 				struct page *pages[2], int off, int size)
 {
-	BUG_ON(map_vm_area(area->vm, PAGE_KERNEL, &pages));
+	BUG_ON(map_vm_area(area->vm, PAGE_KERNEL, pages));
 	area->vm_addr = area->vm->addr;
 	return area->vm_addr + off;
 }
_

Patches currently in -mm which might be from chaowang@redhat.com are

mm-vmallocc-clean-up-map_vm_area-third-argument.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch

