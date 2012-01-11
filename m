From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-change-void-into-explict-vm_struct.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:53 -0800
Message-ID: <20120111212853.90AA01E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2AKV2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:54 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: change void* into explict vm_struct*
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-change-void-into-explict-vm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmalloc.c: change void* into explict vm_struct*

vmap_area->private is void* but we don't use the field for various purpose
but use only for vm_struct.  So change it to a vm_struct* with naming to
improve for readability and type checking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-change-void-into-explict-vm_struct mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-change-void-into-explict-vm_struct
+++ a/mm/vmalloc.c
@@ -256,7 +256,7 @@ struct vmap_area {
 	struct rb_node rb_node;		/* address sorted rbtree */
 	struct list_head list;		/* address sorted list */
 	struct list_head purge_list;	/* "lazy purge" list */
-	void *private;
+	struct vm_struct *vm;
 	struct rcu_head rcu_head;
 };
 
@@ -1285,7 +1285,7 @@ static void setup_vmalloc_vm(struct vm_s
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
-	va->private = vm;
+	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 }
 
@@ -1408,7 +1408,7 @@ static struct vm_struct *find_vm_area(co
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA)
-		return va->private;
+		return va->vm;
 
 	return NULL;
 }
@@ -1427,7 +1427,7 @@ struct vm_struct *remove_vm_area(const v
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
-		struct vm_struct *vm = va->private;
+		struct vm_struct *vm = va->vm;
 
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-memcg-clean-up-fault-accounting-fix.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch

