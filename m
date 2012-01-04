From: akpm@linux-foundation.org
Subject: + mm-vmallocc-change-void-into-explict-vm_struct.patch added to -mm tree
Date: Wed, 04 Jan 2012 15:30:55 -0800
Message-ID: <20120104233055.AC31710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:63961 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2ADXa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 18:30:56 -0500
Received: by ghrr15 with SMTP id r15so1827518ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 15:30:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/vmalloc.c: change void* into explict vm_struct*
has been added to the -mm tree.  Its filename is
     mm-vmallocc-change-void-into-explict-vm_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/vmalloc.c: change void* into explict vm_struct*

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch
mm-migratec-cleanup-comment-for-migration_entry_wait.patch
mm-test-pageswapbacked-in-lumpy-reclaim.patch
mm-vmallocc-change-void-into-explict-vm_struct.patch
mm-memcg-clean-up-fault-accounting-fix.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch

