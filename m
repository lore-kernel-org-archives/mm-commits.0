From: akpm@linux-foundation.org
Subject: + alpha-fix-vmalloc-breakage.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:54:46 -0800
Message-ID: <200901130354.n0D3skcb016542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171AbZAMDzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, hannes@cmpxchg.org, npiggin@suse.de, rth@twiddle.net


The patch titled
     alpha: fix vmalloc breakage
has been added to the -mm tree.  Its filename is
     alpha-fix-vmalloc-breakage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix vmalloc breakage
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

On alpha, we have to map some stuff in the VMALLOC space very early in the
boot process (to make SRM console callbacks work and so on, see
arch/alpha/mm/init.c).  For old VM allocator, we just manually placed a
vm_struct onto the global vmlist and this worked for ages.

Unfortunately, the new allocator isn't aware of this, so it constantly
tries to allocate the VM space which is already in use, making vmalloc on
alpha defunct.

This patch forces KVA to import vmlist entries on init.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/vmalloc.c~alpha-fix-vmalloc-breakage mm/vmalloc.c
--- a/mm/vmalloc.c~alpha-fix-vmalloc-breakage
+++ a/mm/vmalloc.c
@@ -24,6 +24,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/bootmem.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -984,6 +985,8 @@ EXPORT_SYMBOL(vm_map_ram);
 
 void __init vmalloc_init(void)
 {
+	struct vmap_area *va;
+	struct vm_struct *tmp;
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -996,6 +999,16 @@ void __init vmalloc_init(void)
 		vbq->nr_dirty = 0;
 	}
 
+	/* Import existing vmlist entries. */
+	for (tmp = vmlist; tmp; tmp = tmp->next) {
+		va = alloc_bootmem(sizeof(struct vmap_area));
+		if (!va)
+			break;
+		va->flags = tmp->flags | VM_VM_AREA;
+		va->va_start = (unsigned long)tmp->addr;
+		va->va_end = va->va_start + tmp->size;
+		__insert_vmap_area(va);
+	}
 	vmap_initialized = true;
 }
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-vmalloc-breakage.patch
make-sure-nobodys-leaking-resources.patch

