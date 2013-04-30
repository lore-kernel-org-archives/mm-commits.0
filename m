From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-export-vmap_area_list-instead-of-vmlist.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:37 -0700
Message-ID: <20130430184737.9C9B45A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41607 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628Ab3D3Srj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:39 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so84874qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: export vmap_area_list, instead of vmlist
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-export-vmap_area_list-instead-of-vmlist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: export vmap_area_list, instead of vmlist

Although our intention is to unexport internal structure entirely, but
there is one exception for kexec.  kexec dumps address of vmlist and
makedumpfile uses this information.

We are about to remove vmlist, then another way to retrieve information of
vmalloc layer is needed for makedumpfile.  For this purpose, we export
vmap_area_list, instead of vmlist.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 +--
 kernel/kexec.c          |    2 +-
 mm/nommu.c              |    3 +--
 mm/vmalloc.c            |   11 ++++++-----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-export-vmap_area_list-instead-of-vmlist include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-export-vmap_area_list-instead-of-vmlist
+++ a/include/linux/vmalloc.h
@@ -130,8 +130,7 @@ extern long vwrite(char *buf, char *addr
 /*
  *	Internals.  Dont't use..
  */
-extern rwlock_t vmlist_lock;
-extern struct vm_struct *vmlist;
+extern struct list_head vmap_area_list;
 extern __init void vm_area_add_early(struct vm_struct *vm);
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
diff -puN kernel/kexec.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist kernel/kexec.c
--- a/kernel/kexec.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist
+++ a/kernel/kexec.c
@@ -1577,7 +1577,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(swapper_pg_dir);
 #endif
 	VMCOREINFO_SYMBOL(_stext);
-	VMCOREINFO_SYMBOL(vmlist);
+	VMCOREINFO_SYMBOL(vmap_area_list);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	VMCOREINFO_SYMBOL(mem_map);
diff -puN mm/nommu.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist mm/nommu.c
--- a/mm/nommu.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist
+++ a/mm/nommu.c
@@ -228,8 +228,7 @@ int follow_pfn(struct vm_area_struct *vm
 }
 EXPORT_SYMBOL(follow_pfn);
 
-DEFINE_RWLOCK(vmlist_lock);
-struct vm_struct *vmlist;
+LIST_HEAD(vmap_area_list);
 
 void vfree(const void *addr)
 {
diff -puN mm/vmalloc.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-export-vmap_area_list-instead-of-vmlist
+++ a/mm/vmalloc.c
@@ -261,7 +261,8 @@ struct vmap_area {
 };
 
 static DEFINE_SPINLOCK(vmap_area_lock);
-static LIST_HEAD(vmap_area_list);
+/* Export for kexec only */
+LIST_HEAD(vmap_area_list);
 static struct rb_root vmap_area_root = RB_ROOT;
 
 /* The vmap cache globals are protected by vmap_area_lock */
@@ -272,6 +273,10 @@ static unsigned long cached_align;
 
 static unsigned long vmap_area_pcpu_hole;
 
+/*** Old vmalloc interfaces ***/
+static DEFINE_RWLOCK(vmlist_lock);
+static struct vm_struct *vmlist;
+
 static struct vmap_area *__find_vmap_area(unsigned long addr)
 {
 	struct rb_node *n = vmap_area_root.rb_node;
@@ -1283,10 +1288,6 @@ int map_vm_area(struct vm_struct *area,
 }
 EXPORT_SYMBOL_GPL(map_vm_area);
 
-/*** Old vmalloc interfaces ***/
-DEFINE_RWLOCK(vmlist_lock);
-struct vm_struct *vmlist;
