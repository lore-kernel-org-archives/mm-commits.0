From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:31 -0700
Message-ID: <20130430184731.9C1A831C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62188 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896Ab3D3Srd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:33 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so84654yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()

This patch is a preparatory step for removing vmlist entirely.  For above
purpose, we change iterating a vmap_list codes to iterating a
vmap_area_list.  It is somewhat trivial change, but just one thing should
be noticed.

vmlist is lack of information about some areas in vmalloc address space. 
For example, vm_map_ram() allocate area in vmalloc address space, but it
doesn't make a link with vmlist.  To provide full information about
vmalloc address space is better idea, so we don't use va->vm and use
vmap_area directly.  This makes get_vmalloc_info() more precise.

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

 mm/vmalloc.c |   60 ++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info
+++ a/mm/vmalloc.c
@@ -2671,46 +2671,50 @@ module_init(proc_vmalloc_init);
 
 void get_vmalloc_info(struct vmalloc_info *vmi)
 {
-	struct vm_struct *vma;
+	struct vmap_area *va;
 	unsigned long free_area_size;
 	unsigned long prev_end;
 
 	vmi->used = 0;
+	vmi->largest_chunk = 0;
 
-	if (!vmlist) {
-		vmi->largest_chunk = VMALLOC_TOTAL;
-	} else {
-		vmi->largest_chunk = 0;
-
-		prev_end = VMALLOC_START;
+	prev_end = VMALLOC_START;
 
-		read_lock(&vmlist_lock);
+	spin_lock(&vmap_area_lock);
 
-		for (vma = vmlist; vma; vma = vma->next) {
-			unsigned long addr = (unsigned long) vma->addr;
-
-			/*
-			 * Some archs keep another range for modules in vmlist
-			 */
-			if (addr < VMALLOC_START)
-				continue;
-			if (addr >= VMALLOC_END)
-				break;
+	if (list_empty(&vmap_area_list)) {
+		vmi->largest_chunk = VMALLOC_TOTAL;
+		goto out;
+	}
 
-			vmi->used += vma->size;
+	list_for_each_entry(va, &vmap_area_list, list) {
+		unsigned long addr = va->va_start;
 
-			free_area_size = addr - prev_end;
-			if (vmi->largest_chunk < free_area_size)
-				vmi->largest_chunk = free_area_size;
+		/*
+		 * Some archs keep another range for modules in vmalloc space
+		 */
+		if (addr < VMALLOC_START)
+			continue;
+		if (addr >= VMALLOC_END)
+			break;
+
+		if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
+			continue;
+
+		vmi->used += (va->va_end - va->va_start);
+
+		free_area_size = addr - prev_end;
+		if (vmi->largest_chunk < free_area_size)
+			vmi->largest_chunk = free_area_size;
 
-			prev_end = vma->size + addr;
-		}
+		prev_end = va->va_end;
+	}
 
-		if (VMALLOC_END - prev_end > vmi->largest_chunk)
-			vmi->largest_chunk = VMALLOC_END - prev_end;
+	if (VMALLOC_END - prev_end > vmi->largest_chunk)
+		vmi->largest_chunk = VMALLOC_END - prev_end;
 
-		read_unlock(&vmlist_lock);
-	}
+out:
+	spin_unlock(&vmap_area_lock);
 }
 #endif
 
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

