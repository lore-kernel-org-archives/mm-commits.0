From: akpm@linux-foundation.org
Subject: [merged] mm-docs-fix-parameter-names-mismatch.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 12:00:34 -0800
Message-ID: <20180207200034.ftjIt5QHM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com


The patch titled
     Subject: mm: docs: fix parameter names mismatch
has been removed from the -mm tree.  Its filename was
     mm-docs-fix-parameter-names-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm: docs: fix parameter names mismatch

There are several places where parameter descriptions do no match the
actual code.  Fix it.

Link: http://lkml.kernel.org/r/1516700871-22279-3-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c           |    2 +-
 mm/maccess.c           |    2 +-
 mm/memcontrol.c        |    2 +-
 mm/process_vm_access.c |    2 +-
 mm/swap.c              |    4 ++--
 mm/z3fold.c            |    4 ++--
 mm/zbud.c              |    4 ++--
 mm/zpool.c             |   20 ++++++++++----------
 8 files changed, 20 insertions(+), 20 deletions(-)

diff -puN mm/bootmem.c~mm-docs-fix-parameter-names-mismatch mm/bootmem.c
--- a/mm/bootmem.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/bootmem.c
@@ -410,7 +410,7 @@ void __init free_bootmem_node(pg_data_t
 
 /**
  * free_bootmem - mark a page range as usable
- * @addr: starting physical address of the range
+ * @physaddr: starting physical address of the range
  * @size: size of the range in bytes
  *
  * Partial pages will be considered reserved and left as they are.
diff -puN mm/maccess.c~mm-docs-fix-parameter-names-mismatch mm/maccess.c
--- a/mm/maccess.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/maccess.c
@@ -70,7 +70,7 @@ EXPORT_SYMBOL_GPL(probe_kernel_write);
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
- * @src:   Unsafe address.
+ * @unsafe_addr: Unsafe address.
  * @count: Maximum number of bytes to copy, including the trailing NUL.
  *
  * Copies a NUL-terminated string from unsafe address to kernel buffer.
diff -puN mm/memcontrol.c~mm-docs-fix-parameter-names-mismatch mm/memcontrol.c
--- a/mm/memcontrol.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/memcontrol.c
@@ -917,7 +917,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 /**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
- * @zone: zone of the page
+ * @pgdat: pgdat of the page
  *
  * This function is only safe when following the LRU page isolation
  * and putback protocol: the LRU lock must be held, and the page must
diff -puN mm/process_vm_access.c~mm-docs-fix-parameter-names-mismatch mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/process_vm_access.c
@@ -25,7 +25,7 @@
 /**
  * process_vm_rw_pages - read/write pages from task specified
  * @pages: array of pointers to pages we want to copy
- * @start_offset: offset in page to start copying from/to
+ * @offset: offset in page to start copying from/to
  * @len: number of bytes to copy
  * @iter: where to copy to/from locally
  * @vm_write: 0 means copy from, 1 means copy to
diff -puN mm/swap.c~mm-docs-fix-parameter-names-mismatch mm/swap.c
--- a/mm/swap.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/swap.c
@@ -913,11 +913,11 @@ EXPORT_SYMBOL(__pagevec_lru_add);
  * @pvec:	Where the resulting entries are placed
  * @mapping:	The address_space to search
  * @start:	The starting entry index
- * @nr_entries:	The maximum number of entries
+ * @nr_pages:	The maximum number of pages
  * @indices:	The cache indices corresponding to the entries in @pvec
  *
  * pagevec_lookup_entries() will search for and return a group of up
- * to @nr_entries pages and shadow entries in the mapping.  All
+ * to @nr_pages pages and shadow entries in the mapping.  All
  * entries are placed in @pvec.  pagevec_lookup_entries() takes a
  * reference against actual pages in @pvec.
  *
diff -puN mm/z3fold.c~mm-docs-fix-parameter-names-mismatch mm/z3fold.c
--- a/mm/z3fold.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/z3fold.c
@@ -769,7 +769,7 @@ static void z3fold_free(struct z3fold_po
 /**
  * z3fold_reclaim_page() - evicts allocations from a pool page and frees it
  * @pool:	pool from which a page will attempt to be evicted
- * @retires:	number of pages on the LRU list for which eviction will
+ * @retries:	number of pages on the LRU list for which eviction will
  *		be attempted before failing
  *
  * z3fold reclaim is different from normal system reclaim in that it is done
@@ -779,7 +779,7 @@ static void z3fold_free(struct z3fold_po
  * z3fold and the user, however.
  *
  * To avoid these, this is how z3fold_reclaim_page() should be called:
-
+ *
  * The user detects a page should be reclaimed and calls z3fold_reclaim_page().
  * z3fold_reclaim_page() will remove a z3fold page from the pool LRU list and
  * call the user-defined eviction handler with the pool and handle as
diff -puN mm/zbud.c~mm-docs-fix-parameter-names-mismatch mm/zbud.c
--- a/mm/zbud.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/zbud.c
@@ -466,7 +466,7 @@ void zbud_free(struct zbud_pool *pool, u
 /**
  * zbud_reclaim_page() - evicts allocations from a pool page and frees it
  * @pool:	pool from which a page will attempt to be evicted
- * @retires:	number of pages on the LRU list for which eviction will
+ * @retries:	number of pages on the LRU list for which eviction will
  *		be attempted before failing
  *
  * zbud reclaim is different from normal system reclaim in that the reclaim is
@@ -476,7 +476,7 @@ void zbud_free(struct zbud_pool *pool, u
  * the user, however.
  *
  * To avoid these, this is how zbud_reclaim_page() should be called:
-
+ *
  * The user detects a page should be reclaimed and calls zbud_reclaim_page().
  * zbud_reclaim_page() will remove a zbud page from the pool LRU list and call
  * the user-defined eviction handler with the pool and handle as arguments.
diff -puN mm/zpool.c~mm-docs-fix-parameter-names-mismatch mm/zpool.c
--- a/mm/zpool.c~mm-docs-fix-parameter-names-mismatch
+++ a/mm/zpool.c
@@ -201,7 +201,7 @@ struct zpool *zpool_create_pool(const ch
 
 /**
  * zpool_destroy_pool() - Destroy a zpool
- * @pool:	The zpool to destroy.
+ * @zpool:	The zpool to destroy.
  *
  * Implementations must guarantee this to be thread-safe,
  * however only when destroying different pools.  The same
@@ -224,7 +224,7 @@ void zpool_destroy_pool(struct zpool *zp
 
 /**
  * zpool_get_type() - Get the type of the zpool
- * @pool:	The zpool to check
+ * @zpool:	The zpool to check
  *
  * This returns the type of the pool.
  *
@@ -239,7 +239,7 @@ const char *zpool_get_type(struct zpool
 
 /**
  * zpool_malloc() - Allocate memory
- * @pool:	The zpool to allocate from.
+ * @zpool:	The zpool to allocate from.
  * @size:	The amount of memory to allocate.
  * @gfp:	The GFP flags to use when allocating memory.
  * @handle:	Pointer to the handle to set
@@ -261,7 +261,7 @@ int zpool_malloc(struct zpool *zpool, si
 
 /**
  * zpool_free() - Free previously allocated memory
- * @pool:	The zpool that allocated the memory.
+ * @zpool:	The zpool that allocated the memory.
  * @handle:	The handle to the memory to free.
  *
  * This frees previously allocated memory.  This does not guarantee
@@ -280,7 +280,7 @@ void zpool_free(struct zpool *zpool, uns
 
 /**
  * zpool_shrink() - Shrink the pool size
- * @pool:	The zpool to shrink.
+ * @zpool:	The zpool to shrink.
  * @pages:	The number of pages to shrink the pool.
  * @reclaimed:	The number of pages successfully evicted.
  *
@@ -304,11 +304,11 @@ int zpool_shrink(struct zpool *zpool, un
 
 /**
  * zpool_map_handle() - Map a previously allocated handle into memory
- * @pool:	The zpool that the handle was allocated from
+ * @zpool:	The zpool that the handle was allocated from
  * @handle:	The handle to map
- * @mm:		How the memory should be mapped
+ * @mapmode:	How the memory should be mapped
  *
- * This maps a previously allocated handle into memory.  The @mm
+ * This maps a previously allocated handle into memory.  The @mapmode
  * param indicates to the implementation how the memory will be
  * used, i.e. read-only, write-only, read-write.  If the
  * implementation does not support it, the memory will be treated
@@ -332,7 +332,7 @@ void *zpool_map_handle(struct zpool *zpo
 
 /**
  * zpool_unmap_handle() - Unmap a previously mapped handle
- * @pool:	The zpool that the handle was allocated from
+ * @zpool:	The zpool that the handle was allocated from
  * @handle:	The handle to unmap
  *
  * This unmaps a previously mapped handle.  Any locks or other
@@ -347,7 +347,7 @@ void zpool_unmap_handle(struct zpool *zp
 
 /**
  * zpool_get_total_size() - The total size of the pool
- * @pool:	The zpool to check
+ * @zpool:	The zpool to check
  *
  * This returns the total size in bytes of the pool.
  *
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


