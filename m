From: akpm@linux-foundation.org
Subject: + mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc.patch added to -mm tree
Date: Thu, 14 Mar 2013 16:20:51 -0700
Message-ID: <20130314232051.A1E7D5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39272 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3CNXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 19:20:53 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so286484ghb.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 16:20:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com


The patch titled
     Subject: mm, vmalloc: remove list management of vmlist after initializing vmalloc
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: remove list management of vmlist after initializing vmalloc

Now, there is no need to maintain vmlist after initializing vmalloc.
So remove related code and data structure.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   52 +++++++++++--------------------------------------
 1 file changed, 12 insertions(+), 40 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc
+++ a/mm/vmalloc.c
@@ -273,10 +273,6 @@ static unsigned long cached_align;
 
 static unsigned long vmap_area_pcpu_hole;
 
-/*** Old vmalloc interfaces ***/
-static DEFINE_RWLOCK(vmlist_lock);
-static struct vm_struct *vmlist;
-
 static struct vmap_area *__find_vmap_area(unsigned long addr)
 {
 	struct rb_node *n = vmap_area_root.rb_node;
@@ -318,7 +314,7 @@ static void __insert_vmap_area(struct vm
 	rb_link_node(&va->rb_node, parent, p);
 	rb_insert_color(&va->rb_node, &vmap_area_root);
 
-	/* address-sort this list so it is usable like the vmlist */
+	/* address-sort this list */
 	tmp = rb_prev(&va->rb_node);
 	if (tmp) {
 		struct vmap_area *prev;
@@ -1130,6 +1126,7 @@ void *vm_map_ram(struct page **pages, un
 }
 EXPORT_SYMBOL(vm_map_ram);
 
+static struct vm_struct *vmlist __initdata;
 /**
  * vm_area_add_early - add vmap area early during boot
  * @vm: vm_struct to add
@@ -1301,10 +1298,8 @@ static void setup_vmalloc_vm(struct vm_s
 	spin_unlock(&vmap_area_lock);
 }
 
-static void insert_vmalloc_vmlist(struct vm_struct *vm)
+static void clear_vm_unlist(struct vm_struct *vm)
 {
-	struct vm_struct *tmp, **p;
-
 	/*
 	 * Before removing VM_UNLIST,
 	 * we should make sure that vm has proper values.
@@ -1312,22 +1307,13 @@ static void insert_vmalloc_vmlist(struct
 	 */
 	smp_wmb();
 	vm->flags &= ~VM_UNLIST;
-
-	write_lock(&vmlist_lock);
-	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
-		if (tmp->addr >= vm->addr)
-			break;
-	}
-	vm->next = *p;
-	*p = vm;
-	write_unlock(&vmlist_lock);
 }
 
 static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 			      unsigned long flags, const void *caller)
 {
 	setup_vmalloc_vm(vm, va, flags, caller);
-	insert_vmalloc_vmlist(vm);
+	clear_vm_unlist(vm);
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
@@ -1370,10 +1356,9 @@ static struct vm_struct *__get_vm_area_n
 
 	/*
 	 * When this function is called from __vmalloc_node_range,
-	 * we do not add vm_struct to vmlist here to avoid
-	 * accessing uninitialized members of vm_struct such as
-	 * pages and nr_pages fields. They will be set later.
-	 * To distinguish it from others, we use a VM_UNLIST flag.
+	 * we add VM_UNLIST flag to avoid accessing uninitialized
+	 * members of vm_struct such as pages and nr_pages fields.
+	 * They will be set later.
 	 */
 	if (flags & VM_UNLIST)
 		setup_vmalloc_vm(area, va, flags, caller);
@@ -1462,20 +1447,6 @@ struct vm_struct *remove_vm_area(const v
 		va->flags &= ~VM_VM_AREA;
 		spin_unlock(&vmap_area_lock);
 
-		if (!(vm->flags & VM_UNLIST)) {
-			struct vm_struct *tmp, **p;
-			/*
-			 * remove from list and disallow access to
-			 * this vm_struct before unmap. (address range
-			 * confliction is maintained by vmap.)
-			 */
-			write_lock(&vmlist_lock);
-			for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
-				;
-			*p = tmp->next;
-			write_unlock(&vmlist_lock);
-		}
-
 		vmap_debug_free_range(va->va_start, va->va_end);
 		free_unmap_vmap_area(va);
 		vm->size -= PAGE_SIZE;
@@ -1695,10 +1666,11 @@ void *__vmalloc_node_range(unsigned long
 		return NULL;
 
 	/*
-	 * In this function, newly allocated vm_struct is not added
-	 * to vmlist at __get_vm_area_node(). so, it is added here.
+	 * In this function, newly allocated vm_struct has VM_UNLIST flag.
+	 * It means that vm_struct is not fully initialized.
+	 * Now, it is fully initialized, so remove this flag here.
 	 */
-	insert_vmalloc_vmlist(area);
+	clear_vm_unlist(area);
 
 	/*
 	 * A ref_count = 3 is needed because the vm_struct and vmap_area
@@ -2594,7 +2566,7 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
-		/* Pair with smp_wmb() in insert_vmalloc_vmlist() */
+		/* Pair with smp_wmb() in clear_vm_unlist() */
 		smp_rmb();
 		if (v->flags & VM_UNLIST)
 			return;
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area.patch
mm-vmalloc-move-get_vmalloc_info-to-vmallocc.patch
mm-vmalloc-protect-va-vm-by-vmap_area_lock.patch
mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite.patch
mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info.patch
mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo.patch
mm-vmalloc-export-vmap_area_list-instead-of-vmlist.patch
mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc.patch

