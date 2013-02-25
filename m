From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memory-use-new-hashtable-implementation.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:47 -0800
Message-ID: <20130225204847.B39545A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39560 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3BYUst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:49 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so346383ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, rientjes@google.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: use new hashtable implementation
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-new-hashtable-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm/huge_memory.c: use new hashtable implementation

Switch hugemem to use the new hashtable implementation.  This reduces the
amount of generic unrelated code in the hugemem.

This also removes the dymanic allocation of the hash table.  The upside is
that we save a pointer dereference when accessing the hashtable, but we
lose 8KB if CONFIG_TRANSPARENT_HUGEPAGE is enabled but the processor
doesn't support hugepages.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   54 +++++++--------------------------------------
 1 file changed, 9 insertions(+), 45 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-use-new-hashtable-implementation mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-use-new-hashtable-implementation
+++ a/mm/huge_memory.c
@@ -20,6 +20,7 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/migrate.h>
+#include <linux/hashtable.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -62,12 +63,11 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
 static unsigned int khugepaged_max_ptes_none __read_mostly = HPAGE_PMD_NR-1;
 
 static int khugepaged(void *none);
-static int mm_slots_hash_init(void);
 static int khugepaged_slab_init(void);
-static void khugepaged_slab_free(void);
 
-#define MM_SLOTS_HASH_HEADS 1024
-static struct hlist_head *mm_slots_hash __read_mostly;
+#define MM_SLOTS_HASH_BITS 10
+static __read_mostly DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
+
 static struct kmem_cache *mm_slot_cache __read_mostly;
 
 /**
@@ -634,12 +634,6 @@ static int __init hugepage_init(void)
 	if (err)
 		goto out;
 
-	err = mm_slots_hash_init();
-	if (err) {
-		khugepaged_slab_free();
-		goto out;
-	}
-
 	register_shrinker(&huge_zero_page_shrinker);
 
 	/*
@@ -1908,12 +1902,6 @@ static int __init khugepaged_slab_init(v
 	return 0;
 }
 
-static void __init khugepaged_slab_free(void)
-{
-	kmem_cache_destroy(mm_slot_cache);
-	mm_slot_cache = NULL;
-}
-
 static inline struct mm_slot *alloc_mm_slot(void)
 {
 	if (!mm_slot_cache)	/* initialization failed */
@@ -1926,47 +1914,23 @@ static inline void free_mm_slot(struct m
 	kmem_cache_free(mm_slot_cache, mm_slot);
 }
 
-static int __init mm_slots_hash_init(void)
-{
-	mm_slots_hash = kzalloc(MM_SLOTS_HASH_HEADS * sizeof(struct hlist_head),
-				GFP_KERNEL);
-	if (!mm_slots_hash)
-		return -ENOMEM;
-	return 0;
-}
-
-#if 0
-static void __init mm_slots_hash_free(void)
-{
-	kfree(mm_slots_hash);
-	mm_slots_hash = NULL;
-}
-#endif
-
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
-	struct hlist_head *bucket;
 	struct hlist_node *node;
 
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
-	hlist_for_each_entry(mm_slot, node, bucket, hash) {
+	hash_for_each_possible(mm_slots_hash, mm_slot, node, hash, (unsigned long)mm)
 		if (mm == mm_slot->mm)
 			return mm_slot;
-	}
+
 	return NULL;
 }
 
 static void insert_to_mm_slots_hash(struct mm_struct *mm,
 				    struct mm_slot *mm_slot)
 {
-	struct hlist_head *bucket;
-
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
 	mm_slot->mm = mm;
-	hlist_add_head(&mm_slot->hash, bucket);
+	hash_add(mm_slots_hash, &mm_slot->hash, (long)mm);
 }
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
@@ -2035,7 +1999,7 @@ void __khugepaged_exit(struct mm_struct 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = get_mm_slot(mm);
 	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
-		hlist_del(&mm_slot->hash);
+		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
 		free = 1;
 	}
@@ -2484,7 +2448,7 @@ static void collect_mm_slot(struct mm_sl
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
-		hlist_del(&mm_slot->hash);
+		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
 
 		/*
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch
posix-timer-dont-call-idr_find-w-out-of-range-id.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch

