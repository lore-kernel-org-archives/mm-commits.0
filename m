From: akpm@linux-foundation.org
Subject: + mm-vmalloc-use-mutex-for-purge.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:18:35 -0800
Message-ID: <200811130018.mAD0IZhh015624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbYKMATJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:19:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: vmalloc use mutex for purge
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-mutex-for-purge.patch

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

linux-next.patch
mm-vmalloc-allocator-off-by-one.patch
mm-vmalloc-failure-flush-fix.patch
mm-vmalloc-search-restart-fix.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
reiser4.patch

