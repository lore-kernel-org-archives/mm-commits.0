From: akpm@linux-foundation.org
Subject: + zsmalloc-add-more-comment.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:57:37 -0800
Message-ID: <52a8fbf1.v1HDIHgSg4J6dKO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3LKX5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, semenzato@google.com, riel@redhat.com, penberg@kernel.org, minchan@kernel.org, mgorman@suse.de, konrad.wilk@oracle.com, hughd@google.com, gregkh@linuxfoundation.org, bob.liu@oracle.com, axboe@kernel.dk, ngupta@vflare.org

Subject: + zsmalloc-add-more-comment.patch added to -mm tree
To: ngupta@vflare.org,axboe@kernel.dk,bob.liu@oracle.com,gregkh@linuxfoundation.org,hughd@google.com,konrad.wilk@oracle.com,mgorman@suse.de,minchan@kernel.org,penberg@kernel.org,riel@redhat.com,semenzato@google.com,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:57:37 -0800


The patch titled
     Subject: zsmalloc: add more comment
has been added to the -mm tree.  Its filename is
     zsmalloc-add-more-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-add-more-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-add-more-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nitin Cupta <ngupta@vflare.org>
Subject: zsmalloc: add more comment

This patch adds lots of comments and it will help others to review and
enhance.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zsmalloc/zsmalloc-main.c |   66 +++++++++++++++++----
 drivers/staging/zsmalloc/zsmalloc.h      |    9 ++
 2 files changed, 64 insertions(+), 11 deletions(-)

diff -puN drivers/staging/zsmalloc/zsmalloc-main.c~zsmalloc-add-more-comment drivers/staging/zsmalloc/zsmalloc-main.c
--- a/drivers/staging/zsmalloc/zsmalloc-main.c~zsmalloc-add-more-comment
+++ a/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -10,16 +10,14 @@
  * Released under the terms of GNU General Public License Version 2.0
  */
 
-
 /*
- * This allocator is designed for use with zcache and zram. Thus, the
- * allocator is supposed to work well under low memory conditions. In
- * particular, it never attempts higher order page allocation which is
- * very likely to fail under memory pressure. On the other hand, if we
- * just use single (0-order) pages, it would suffer from very high
- * fragmentation -- any object of size PAGE_SIZE/2 or larger would occupy
- * an entire page. This was one of the major issues with its predecessor
- * (xvmalloc).
+ * This allocator is designed for use with zram. Thus, the allocator is
+ * supposed to work well under low memory conditions. In particular, it
+ * never attempts higher order page allocation which is very likely to
+ * fail under memory pressure. On the other hand, if we just use single
+ * (0-order) pages, it would suffer from very high fragmentation --
+ * any object of size PAGE_SIZE/2 or larger would occupy an entire page.
+ * This was one of the major issues with its predecessor (xvmalloc).
  *
  * To overcome these issues, zsmalloc allocates a bunch of 0-order pages
  * and links them together using various 'struct page' fields. These linked
@@ -27,6 +25,21 @@
  * page boundaries. The code refers to these linked pages as a single entity
  * called zspage.
  *
+ * For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
+ * since this satisfies the requirements of all its current users (in the
+ * worst case, page is incompressible and is thus stored "as-is" i.e. in
+ * uncompressed form). For allocation requests larger than this size, failure
+ * is returned (see zs_malloc).
+ *
+ * Additionally, zs_malloc() does not return a dereferenceable pointer.
+ * Instead, it returns an opaque handle (unsigned long) which encodes actual
+ * location of the allocated object. The reason for this indirection is that
+ * zsmalloc does not keep zspages permanently mapped since that would cause
+ * issues on 32-bit systems where the VA region for kernel space mappings
+ * is very small. So, before using the allocating memory, the object has to
+ * be mapped using zs_map_object() to get a usable pointer and subsequently
+ * unmapped using zs_unmap_object().
+ *
  * Following is how we use various fields and flags of underlying
  * struct page(s) to form a zspage.
  *
@@ -98,7 +111,7 @@
 
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
- * as single (void *) handle value.
+ * as single (unsigned long) handle value.
  *
  * Note that object index <obj_idx> is relative to system
  * page <PFN> it is stored in, so for each sub-page belonging
@@ -264,6 +277,13 @@ static void set_zspage_mapping(struct pa
 	page->mapping = (struct address_space *)m;
 }
 
+/*
+ * zsmalloc divides the pool into various size classes where each
+ * class maintains a list of zspages where each zspage is divided
+ * into equal sized chunks. Each allocation falls into one of these
+ * classes depending on its size. This function returns index of the
+ * size class which has chunk size big enough to hold the give size.
+ */
 static int get_size_class_index(int size)
 {
 	int idx = 0;
@@ -275,6 +295,13 @@ static int get_size_class_index(int size
 	return idx;
 }
 
+/*
+ * For each size class, zspages are divided into different groups
+ * depending on how "full" they are. This was done so that we could
+ * easily find empty or nearly empty zspages when we try to shrink
+ * the pool (not yet implemented). This function returns fullness
+ * status of the given page.
+ */
 static enum fullness_group get_fullness_group(struct page *page)
 {
 	int inuse, max_objects;
@@ -296,6 +323,12 @@ static enum fullness_group get_fullness_
 	return fg;
 }
 
+/*
+ * Each size class maintains various freelists and zspages are assigned
+ * to one of these freelists based on the number of live objects they
+ * have. This functions inserts the given zspage into the freelist
+ * identified by <class, fullness_group>.
+ */
 static void insert_zspage(struct page *page, struct size_class *class,
 				enum fullness_group fullness)
 {
@@ -313,6 +346,10 @@ static void insert_zspage(struct page *p
 	*head = page;
 }
 
+/*
+ * This function removes the given zspage from the freelist identified
+ * by <class, fullness_group>.
+ */
 static void remove_zspage(struct page *page, struct size_class *class,
 				enum fullness_group fullness)
 {
@@ -334,6 +371,15 @@ static void remove_zspage(struct page *p
 	list_del_init(&page->lru);
 }
 
+/*
+ * Each size class maintains zspages in different fullness groups depending
+ * on the number of live objects they contain. When allocating or freeing
+ * objects, the fullness status of the page can change, say, from ALMOST_FULL
+ * to ALMOST_EMPTY when freeing an object. This function checks if such
+ * a status change has occurred for the given page and accordingly moves the
+ * page from the freelist of the old fullness group to that of the new
+ * fullness group.
+ */
 static enum fullness_group fix_fullness_group(struct zs_pool *pool,
 						struct page *page)
 {
diff -puN drivers/staging/zsmalloc/zsmalloc.h~zsmalloc-add-more-comment drivers/staging/zsmalloc/zsmalloc.h
--- a/drivers/staging/zsmalloc/zsmalloc.h~zsmalloc-add-more-comment
+++ a/drivers/staging/zsmalloc/zsmalloc.h
@@ -18,12 +18,19 @@
 /*
  * zsmalloc mapping modes
  *
- * NOTE: These only make a difference when a mapped object spans pages
+ * NOTE: These only make a difference when a mapped object spans pages.
+ * They also have no effect when PGTABLE_MAPPING is selected.
  */
 enum zs_mapmode {
 	ZS_MM_RW, /* normal read-write mapping */
 	ZS_MM_RO, /* read-only (no copy-out at unmap time) */
 	ZS_MM_WO /* write-only (no copy-in at map time) */
+	/*
+	 * NOTE: ZS_MM_WO should only be used for initializing new
+	 * (uninitialized) allocations.  Partial writes to already
+	 * initialized allocations should use ZS_MM_RW to preserve the
+	 * existing data.
+	 */
 };
 
 struct zs_pool;
_

Patches currently in -mm which might be from ngupta@vflare.org are

linux-next.patch
zsmalloc-add-kconfig-for-enabling-page-table-method.patch
zsmalloc-add-more-comment.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

