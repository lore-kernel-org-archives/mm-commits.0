From: akpm@linux-foundation.org
Subject: - mm-vmalloc-use-mutex-for-purge.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:02 -0800
Message-ID: <200901072212.n07MC2pj012306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbZAGWMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc use mutex for purge
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-mutex-for-purge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc use mutex for purge
From: Nick Piggin <npiggin@suse.de>

The vmalloc purge lock can be a mutex so we can sleep while a purge is
going on (purge involves a global kernel TLB invalidate, so it can take
quite a while).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-mutex-for-purge mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-mutex-for-purge
+++ a/mm/vmalloc.c
@@ -14,6 +14,7 @@
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -473,7 +474,7 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
 static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 					int sync, int force_flush)
 {
-	static DEFINE_SPINLOCK(purge_lock);
+	static DEFINE_MUTEX(purge_lock);
 	LIST_HEAD(valist);
 	struct vmap_area *va;
 	int nr = 0;
@@ -484,10 +485,10 @@ static void __purge_vmap_area_lazy(unsig
 	 * the case that isn't actually used at the moment anyway.
 	 */
 	if (!sync && !force_flush) {
-		if (!spin_trylock(&purge_lock))
+		if (!mutex_trylock(&purge_lock))
 			return;
 	} else
-		spin_lock(&purge_lock);
+		mutex_lock(&purge_lock);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(va, &vmap_area_list, list) {
@@ -519,7 +520,7 @@ static void __purge_vmap_area_lazy(unsig
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}
-	spin_unlock(&purge_lock);
+	mutex_unlock(&purge_lock);
 }
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

