From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:28 -0700
Message-ID: <20130430184728.9DB1A31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35989 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896Ab3D3Sra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:30 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86490qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: iterate vmap_area_list, instead of vmlist in vread/vwrite()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: iterate vmap_area_list, instead of vmlist in vread/vwrite()

Now, when we hold a vmap_area_lock, va->vm can't be discarded.  So we can
safely access to va->vm when iterating a vmap_area_list with holding a
vmap_area_lock.  With this property, change iterating vmlist codes in
vread/vwrite() to iterating vmap_area_list.

There is a little difference relate to lock, because vmlist_lock is mutex,
but, vmap_area_lock is spin_lock.  It may introduce a spinning overhead
during vread/vwrite() is executing.  But, these are debug-oriented
functions, so this overhead is not real problem for common case.

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

 mm/vmalloc.c |   48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite
+++ a/mm/vmalloc.c
@@ -2012,7 +2012,8 @@ static int aligned_vwrite(char *buf, cha
 
 long vread(char *buf, char *addr, unsigned long count)
 {
-	struct vm_struct *tmp;
+	struct vmap_area *va;
+	struct vm_struct *vm;
 	char *vaddr, *buf_start = buf;
 	unsigned long buflen = count;
 	unsigned long n;
@@ -2021,10 +2022,17 @@ long vread(char *buf, char *addr, unsign
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
 
-	read_lock(&vmlist_lock);
-	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
-		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
+	spin_lock(&vmap_area_lock);
+	list_for_each_entry(va, &vmap_area_list, list) {
+		if (!count)
+			break;
+
+		if (!(va->flags & VM_VM_AREA))
+			continue;
+
+		vm = va->vm;
+		vaddr = (char *) vm->addr;
+		if (addr >= vaddr + vm->size - PAGE_SIZE)
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -2034,10 +2042,10 @@ long vread(char *buf, char *addr, unsign
 			addr++;
 			count--;
 		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
+		n = vaddr + vm->size - PAGE_SIZE - addr;
 		if (n > count)
 			n = count;
-		if (!(tmp->flags & VM_IOREMAP))
+		if (!(vm->flags & VM_IOREMAP))
 			aligned_vread(buf, addr, n);
 		else /* IOREMAP area is treated as memory hole */
 			memset(buf, 0, n);
@@ -2046,7 +2054,7 @@ long vread(char *buf, char *addr, unsign
 		count -= n;
 	}
 finished:
-	read_unlock(&vmlist_lock);
+	spin_unlock(&vmap_area_lock);
 
 	if (buf == buf_start)
 		return 0;
@@ -2085,7 +2093,8 @@ finished:
 
 long vwrite(char *buf, char *addr, unsigned long count)
 {
-	struct vm_struct *tmp;
+	struct vmap_area *va;
+	struct vm_struct *vm;
 	char *vaddr;
 	unsigned long n, buflen;
 	int copied = 0;
@@ -2095,10 +2104,17 @@ long vwrite(char *buf, char *addr, unsig
 		count = -(unsigned long) addr;
 	buflen = count;
 
-	read_lock(&vmlist_lock);
-	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
-		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
+	spin_lock(&vmap_area_lock);
+	list_for_each_entry(va, &vmap_area_list, list) {
+		if (!count)
+			break;
+
+		if (!(va->flags & VM_VM_AREA))
+			continue;
+
+		vm = va->vm;
+		vaddr = (char *) vm->addr;
+		if (addr >= vaddr + vm->size - PAGE_SIZE)
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -2107,10 +2123,10 @@ long vwrite(char *buf, char *addr, unsig
 			addr++;
 			count--;
 		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
+		n = vaddr + vm->size - PAGE_SIZE - addr;
 		if (n > count)
 			n = count;
-		if (!(tmp->flags & VM_IOREMAP)) {
+		if (!(vm->flags & VM_IOREMAP)) {
 			aligned_vwrite(buf, addr, n);
 			copied++;
 		}
@@ -2119,7 +2135,7 @@ long vwrite(char *buf, char *addr, unsig
 		count -= n;
 	}
 finished:
-	read_unlock(&vmlist_lock);
+	spin_unlock(&vmap_area_lock);
 	if (!copied)
 		return 0;
 	return buflen;
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

