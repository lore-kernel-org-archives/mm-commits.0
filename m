From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-protect-va-vm-by-vmap_area_lock.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:25 -0700
Message-ID: <20130430184725.94B5231C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:65193 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3D3Sr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:27 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86453qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: protect va->vm by vmap_area_lock
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-protect-va-vm-by-vmap_area_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: protect va->vm by vmap_area_lock

Inserting and removing an entry to vmlist is linear time complexity, so it
is inefficient.  Following patches will try to remove vmlist entirely. 
This patch is preparing step for it.

For removing vmlist, iterating vmlist codes should be changed to iterating
a vmap_area_list.  Before implementing that, we should make sure that when
we iterate a vmap_area_list, accessing to va->vm doesn't cause a race
condition.  This patch ensure that when iterating a vmap_area_list, there
is no race condition for accessing to vm_struct.

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

 mm/vmalloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmalloc.c~mm-vmalloc-protect-va-vm-by-vmap_area_lock mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-protect-va-vm-by-vmap_area_lock
+++ a/mm/vmalloc.c
@@ -1290,12 +1290,14 @@ struct vm_struct *vmlist;
 static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 			      unsigned long flags, const void *caller)
 {
+	spin_lock(&vmap_area_lock);
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
 	va->vm = vm;
 	va->flags |= VM_VM_AREA;
+	spin_unlock(&vmap_area_lock);
 }
 
 static void insert_vmalloc_vmlist(struct vm_struct *vm)
@@ -1447,6 +1449,11 @@ struct vm_struct *remove_vm_area(const v
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->vm;
 
+		spin_lock(&vmap_area_lock);
+		va->vm = NULL;
+		va->flags &= ~VM_VM_AREA;
+		spin_unlock(&vmap_area_lock);
+
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;
 			/*
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

