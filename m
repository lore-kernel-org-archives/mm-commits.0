From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:34 -0700
Message-ID: <20130430184734.A019131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54366 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761321Ab3D3Srg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:36 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84925yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: iterate vmap_area_list, instead of vmlist, in vmallocinfo()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: iterate vmap_area_list, instead of vmlist, in vmallocinfo()

This patch is a preparatory step for removing vmlist entirely.  For above
purpose, we change iterating a vmap_list codes to iterating a
vmap_area_list.  It is somewhat trivial change, but just one thing should
be noticed.

Using vmap_area_list in vmallocinfo() introduce ordering problem in SMP
system.  In s_show(), we retrieve some values from vm_struct.  vm_struct's
values is not fully setup when va->vm is assigned.  Full setup is notified
by removing VM_UNLIST flag without holding a lock.  When we see that
VM_UNLIST is removed, it is not ensured that vm_struct has proper values
in view of other CPUs.  So we need smp_[rw]mb for ensuring that proper
values is assigned when we see that VM_UNLIST is removed.

Therefore, this patch not only change a iteration list, but also add a
appropriate smp_[rw]mb to right places.

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

 mm/vmalloc.c |   55 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo
+++ a/mm/vmalloc.c
@@ -1304,7 +1304,14 @@ static void insert_vmalloc_vmlist(struct
 {
 	struct vm_struct *tmp, **p;
 
+	/*
+	 * Before removing VM_UNLIST,
+	 * we should make sure that vm has proper values.
+	 * Pair with smp_rmb() in show_numa_info().
+	 */
+	smp_wmb();
 	vm->flags &= ~VM_UNLIST;
+
 	write_lock(&vmlist_lock);
 	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
 		if (tmp->addr >= vm->addr)
@@ -2542,19 +2549,19 @@ void pcpu_free_vm_areas(struct vm_struct
 
 #ifdef CONFIG_PROC_FS
 static void *s_start(struct seq_file *m, loff_t *pos)
-	__acquires(&vmlist_lock)
+	__acquires(&vmap_area_lock)
 {
 	loff_t n = *pos;
-	struct vm_struct *v;
+	struct vmap_area *va;
 
-	read_lock(&vmlist_lock);
-	v = vmlist;
-	while (n > 0 && v) {
+	spin_lock(&vmap_area_lock);
+	va = list_entry((&vmap_area_list)->next, typeof(*va), list);
+	while (n > 0 && &va->list != &vmap_area_list) {
 		n--;
-		v = v->next;
+		va = list_entry(va->list.next, typeof(*va), list);
 	}
-	if (!n)
-		return v;
+	if (!n && &va->list != &vmap_area_list)
+		return va;
 
 	return NULL;
 
@@ -2562,16 +2569,20 @@ static void *s_start(struct seq_file *m,
 
 static void *s_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct vm_struct *v = p;
+	struct vmap_area *va = p, *next;
 
 	++*pos;
-	return v->next;
+	next = list_entry(va->list.next, typeof(*va), list);
+	if (&next->list != &vmap_area_list)
+		return next;
+
+	return NULL;
 }
 
 static void s_stop(struct seq_file *m, void *p)
-	__releases(&vmlist_lock)
+	__releases(&vmap_area_lock)
 {
-	read_unlock(&vmlist_lock);
+	spin_unlock(&vmap_area_lock);
 }
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
@@ -2582,6 +2593,11 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in insert_vmalloc_vmlist() */
+		smp_rmb();
+		if (v->flags & VM_UNLIST)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2595,7 +2611,20 @@ static void show_numa_info(struct seq_fi
 
 static int s_show(struct seq_file *m, void *p)
 {
-	struct vm_struct *v = p;
+	struct vmap_area *va = p;
+	struct vm_struct *v;
+
+	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
+		return 0;
+
+	if (!(va->flags & VM_VM_AREA)) {
+		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+			(void *)va->va_start, (void *)va->va_end,
+					va->va_end - va->va_start);
+		return 0;
+	}
+
+	v = va->vm;
 
 	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

