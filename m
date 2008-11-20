From: akpm@linux-foundation.org
Subject: - mm-vmalloc-failure-flush-fix.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:57 -0800
Message-ID: <200811202042.mAKKgvFE007199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164AbYKTUrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc failure flush fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-failure-flush-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc failure flush fix
From: Nick Piggin <npiggin@suse.de>

An initial vmalloc failure should start off a synchronous flush of lazy
areas, in case someone is in progress flushing them already, which could
cause us to return an allocation failure even if there is plenty of KVA
free.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-failure-flush-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-failure-flush-fix
+++ a/mm/vmalloc.c
@@ -522,13 +522,24 @@ static void __purge_vmap_area_lazy(unsig
 }
 
 /*
+ * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
+ * is already purging.
+ */
+static void try_purge_vmap_area_lazy(void)
+{
+	unsigned long start = ULONG_MAX, end = 0;
+
+	__purge_vmap_area_lazy(&start, &end, 0, 0);
+}
+
+/*
  * Kick off a purge of the outstanding lazy areas.
  */
 static void purge_vmap_area_lazy(void)
 {
 	unsigned long start = ULONG_MAX, end = 0;
 
-	__purge_vmap_area_lazy(&start, &end, 0, 0);
+	__purge_vmap_area_lazy(&start, &end, 1, 0);
 }
 
 /*
@@ -539,7 +550,7 @@ static void free_unmap_vmap_area(struct 
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
 	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
-		purge_vmap_area_lazy();
+		try_purge_vmap_area_lazy();
 }
 
 static struct vmap_area *find_vmap_area(unsigned long addr)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-vmalloc-fix-lazy-unmapping-cache-aliasing.patch
mm-vmalloc-fix-lazy-unmapping-cache-aliasing-fix.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
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

