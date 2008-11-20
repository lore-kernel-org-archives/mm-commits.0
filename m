From: akpm@linux-foundation.org
Subject: - mm-vmalloc-fix-lazy-unmapping-cache-aliasing-fix.patch removed from -mm tree
Date: Thu, 20 Nov 2008 13:13:06 -0800
Message-ID: <200811202113.mAKLD61n023077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbYKTVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, radford@blackbean.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc fix lazy unmapping cache aliasing (fix)
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-lazy-unmapping-cache-aliasing-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-lazy-unmapping-cache-aliasing.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc fix lazy unmapping cache aliasing (fix)
From: Nick Piggin <npiggin@suse.de>

Russell King wrote:
> One minor nit - this looks like we're flushing the cache after the
> range has been marked as needing the mapping torn down.  Can the
> mapping be torn down before the cache is flushed?
>
> The reason I ask is that with VIPT caches, the mapping has to be
> present so the hardware knows the physical tag to be flushed, so if
> the mapping has been torn down, we'll get an exception.  _If_ and
> only if we convert flush_cache_vunmap() to be less heavy weight
> than its current flush_cache_all().
>
> IOW, shouldn't flush_cache_vunmap() be towards the start of vb_free() ?

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jim Radford <radford@blackbean.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-fix-lazy-unmapping-cache-aliasing-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-lazy-unmapping-cache-aliasing-fix
+++ a/mm/vmalloc.c
@@ -805,6 +805,9 @@ static void vb_free(const void *addr, un
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
+
+	flush_cache_vunmap((unsigned long)addr, (unsigned long)addr + size);
+
 	order = get_order(size);
 
 	offset = (unsigned long)addr & (VMAP_BLOCK_SIZE - 1);
@@ -829,8 +832,6 @@ static void vb_free(const void *addr, un
 		free_vmap_block(vb);
 	} else
 		spin_unlock(&vb->lock);
-
-	flush_cache_vunmap((unsigned long)addr, (unsigned long)addr + size);
 }
 
 /**
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

