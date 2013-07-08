From: akpm@linux-foundation.org
Subject: [merged] vmalloc-introduce-remap_vmalloc_range_partial.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:22 -0700
Message-ID: <51db1222.8Vog6RTHQM80SY/c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3GHTZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: [merged] vmalloc-introduce-remap_vmalloc_range_partial.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:22 -0700


The patch titled
     Subject: vmalloc: introduce remap_vmalloc_range_partial
has been removed from the -mm tree.  Its filename was
     vmalloc-introduce-remap_vmalloc_range_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmalloc: introduce remap_vmalloc_range_partial

We want to allocate ELF note segment buffer on the 2nd kernel in vmalloc
space and remap it to user-space in order to reduce the risk that memory
allocation fails on system with huge number of CPUs and so with huge ELF
note segment that exceeds 11-order block size.

Although there's already remap_vmalloc_range for the purpose of remapping
vmalloc memory to user-space, we need to specify user-space range via vma.
 Mmap on /proc/vmcore needs to remap range across multiple objects, so the
interface that requires vma to cover full range is problematic.

This patch introduces remap_vmalloc_range_partial that receives user-space
range as a pair of base address and size and can be used for mmap on
/proc/vmcore case.

remap_vmalloc_range is rewritten using remap_vmalloc_range_partial.

[akpm@linux-foundation.org: use PAGE_ALIGNED()]
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++
 mm/vmalloc.c            |   67 +++++++++++++++++++++++++-------------
 2 files changed, 49 insertions(+), 22 deletions(-)

diff -puN include/linux/vmalloc.h~vmalloc-introduce-remap_vmalloc_range_partial include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-introduce-remap_vmalloc_range_partial
+++ a/include/linux/vmalloc.h
@@ -82,6 +82,10 @@ extern void *vmap(struct page **pages, u
 			unsigned long flags, pgprot_t prot);
 extern void vunmap(const void *addr);
 
+extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
+				       unsigned long uaddr, void *kaddr,
+				       unsigned long size);
+
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 void vmalloc_sync_all(void);
diff -puN mm/vmalloc.c~vmalloc-introduce-remap_vmalloc_range_partial mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-introduce-remap_vmalloc_range_partial
+++ a/mm/vmalloc.c
@@ -1476,10 +1476,9 @@ static void __vunmap(const void *addr, i
 	if (!addr)
 		return;
 
-	if ((PAGE_SIZE-1) & (unsigned long)addr) {
-		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
+	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
+			addr));
 		return;
-	}
 
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
@@ -2148,42 +2147,43 @@ finished:
 }
 
 /**
- *	remap_vmalloc_range  -  map vmalloc pages to userspace
- *	@vma:		vma to cover (map full range of vma)
- *	@addr:		vmalloc memory
- *	@pgoff:		number of pages into addr before first page to map
+ *	remap_vmalloc_range_partial  -  map vmalloc pages to userspace
+ *	@vma:		vma to cover
+ *	@uaddr:		target user address to start at
+ *	@kaddr:		virtual address of vmalloc kernel memory
+ *	@size:		size of map area
  *
  *	Returns:	0 for success, -Exxx on failure
  *
- *	This function checks that addr is a valid vmalloc'ed area, and
- *	that it is big enough to cover the vma. Will return failure if
- *	that criteria isn't met.
+ *	This function checks that @kaddr is a valid vmalloc'ed area,
+ *	and that it is big enough to cover the range starting at
+ *	@uaddr in @vma. Will return failure if that criteria isn't
+ *	met.
  *
  *	Similar to remap_pfn_range() (see mm/memory.c)
  */
-int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
-						unsigned long pgoff)
+int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
+				void *kaddr, unsigned long size)
 {
 	struct vm_struct *area;
-	unsigned long uaddr = vma->vm_start;
-	unsigned long usize = vma->vm_end - vma->vm_start;
 
-	if ((PAGE_SIZE-1) & (unsigned long)addr)
+	size = PAGE_ALIGN(size);
+
+	if (!PAGE_ALIGNED(uaddr) || !PAGE_ALIGNED(kaddr))
 		return -EINVAL;
 
-	area = find_vm_area(addr);
+	area = find_vm_area(kaddr);
 	if (!area)
 		return -EINVAL;
 
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
-	if (usize + (pgoff << PAGE_SHIFT) > area->size - PAGE_SIZE)
+	if (kaddr + size > area->addr + area->size)
 		return -EINVAL;
 
-	addr += pgoff << PAGE_SHIFT;
 	do {
-		struct page *page = vmalloc_to_page(addr);
+		struct page *page = vmalloc_to_page(kaddr);
 		int ret;
 
 		ret = vm_insert_page(vma, uaddr, page);
@@ -2191,14 +2191,37 @@ int remap_vmalloc_range(struct vm_area_s
 			return ret;
 
 		uaddr += PAGE_SIZE;
-		addr += PAGE_SIZE;
-		usize -= PAGE_SIZE;
-	} while (usize > 0);
+		kaddr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	} while (size > 0);
 
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	return 0;
 }
+EXPORT_SYMBOL(remap_vmalloc_range_partial);
+
+/**
+ *	remap_vmalloc_range  -  map vmalloc pages to userspace
+ *	@vma:		vma to cover (map full range of vma)
+ *	@addr:		vmalloc memory
+ *	@pgoff:		number of pages into addr before first page to map
+ *
+ *	Returns:	0 for success, -Exxx on failure
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	that it is big enough to cover the vma. Will return failure if
+ *	that criteria isn't met.
+ *
+ *	Similar to remap_pfn_range() (see mm/memory.c)
+ */
+int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
+						unsigned long pgoff)
+{
+	return remap_vmalloc_range_partial(vma, vma->vm_start,
+					   addr + (pgoff << PAGE_SHIFT),
+					   vma->vm_end - vma->vm_start);
+}
 EXPORT_SYMBOL(remap_vmalloc_range);
 
 /*
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

origin.patch

