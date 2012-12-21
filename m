From: akpm@linux-foundation.org
Subject: + mm-huge_memory-use-new-hashtable-implementation.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:18:17 -0800
Message-ID: <20121221211818.3A2BC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47420 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2LUVSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:18:21 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so274057wey.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:18:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, rientjes@google.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm/huge_memory.c: use new hashtable implementation
has been added to the -mm tree.  Its filename is
     mm-huge_memory-use-new-hashtable-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1893,12 +1887,6 @@ static int __init khugepaged_slab_init(v
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
@@ -1911,47 +1899,23 @@ static inline void free_mm_slot(struct m
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
+	hash_for_each_possible(mm_slots_hash, mm_slot, node, hash, (unsigned long) mm)
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
@@ -2020,7 +1984,7 @@ void __khugepaged_exit(struct mm_struct 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = get_mm_slot(mm);
 	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
-		hlist_del(&mm_slot->hash);
+		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
 		free = 1;
 	}
@@ -2469,7 +2433,7 @@ static void collect_mm_slot(struct mm_sl
 
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
mm-huge_memory-use-new-hashtable-implementation.patch

