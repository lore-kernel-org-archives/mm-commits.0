From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:39 -0700
Message-ID: <51dc9a8b.ROHclvzsUjlt7Tk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3GIXTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:39 -0700


The patch titled
     Subject: mm/vmalloc.c: rename VM_UNLIST to VM_UNINITIALIZED
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: rename VM_UNLIST to VM_UNINITIALIZED

VM_UNLIST was used to indicate that the vm_struct is not listed in vmlist.
 But after commit 4341fa4 ("mm, vmalloc: remove list management of vmlist
after initializing vmalloc"), the meaning of this flag changed.  It now
means the vm_struct is not fully initialized.  So renaming it to
VM_UNINITIALIZED seems more reasonable.

Also change clear_vm_unlist to clear_vm_uninitialized_flag.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   12 ++++++------
 mm/vmalloc.c            |   18 +++++++++---------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmallocc-rename-vm_unlist-to-vm_uninitialized include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmallocc-rename-vm_unlist-to-vm_uninitialized
+++ a/include/linux/vmalloc.h
@@ -10,12 +10,12 @@
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
 /* bits in flags of vmalloc's vm_struct below */
-#define VM_IOREMAP	0x00000001	/* ioremap() and friends */
-#define VM_ALLOC	0x00000002	/* vmalloc() */
-#define VM_MAP		0x00000004	/* vmap()ed pages */
-#define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
-#define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
-#define VM_UNLIST	0x00000020	/* vm_struct is not listed in vmlist */
+#define VM_IOREMAP		0x00000001	/* ioremap() and friends */
+#define VM_ALLOC		0x00000002	/* vmalloc() */
+#define VM_MAP			0x00000004	/* vmap()ed pages */
+#define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
+#define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
+#define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
diff -puN mm/vmalloc.c~mm-vmallocc-rename-vm_unlist-to-vm_uninitialized mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-rename-vm_unlist-to-vm_uninitialized
+++ a/mm/vmalloc.c
@@ -1289,15 +1289,15 @@ static void setup_vmalloc_vm(struct vm_s
 	spin_unlock(&vmap_area_lock);
 }
 
-static void clear_vm_unlist(struct vm_struct *vm)
+static void clear_vm_uninitialized_flag(struct vm_struct *vm)
 {
 	/*
-	 * Before removing VM_UNLIST,
+	 * Before removing VM_UNINITIALIZED,
 	 * we should make sure that vm has proper values.
 	 * Pair with smp_rmb() in show_numa_info().
 	 */
 	smp_wmb();
-	vm->flags &= ~VM_UNLIST;
+	vm->flags &= ~VM_UNINITIALIZED;
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
+	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED,
 				  start, end, node, gfp_mask, caller);
 	if (!area)
 		goto fail;
@@ -1645,11 +1645,11 @@ void *__vmalloc_node_range(unsigned long
 		goto fail;
 
 	/*
-	 * In this function, newly allocated vm_struct has VM_UNLIST flag.
-	 * It means that vm_struct is not fully initialized.
+	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
+	 * flag. It means that vm_struct is not fully initialized.
 	 * Now, it is fully initialized, so remove this flag here.
 	 */
-	clear_vm_unlist(area);
+	clear_vm_uninitialized_flag(area);
 
 	/*
 	 * A ref_count = 3 is needed because the vm_struct and vmap_area
@@ -2569,9 +2569,9 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
-		/* Pair with smp_wmb() in clear_vm_unlist() */
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 		smp_rmb();
-		if (v->flags & VM_UNLIST)
+		if (v->flags & VM_UNINITIALIZED)
 			return;
 
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

