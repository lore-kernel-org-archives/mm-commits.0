From: akpm@linux-foundation.org
Subject: [merged] mm-break-up-swap_writepage-for-frontswap-backends.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:35 -0700
Message-ID: <20130430184935.873CE5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54048 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3D3Stg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:36 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so85049qen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, dan.magenheimer@oracle.com, konrad.wilk@oracle.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: break up swap_writepage() for frontswap backends
has been removed from the -mm tree.  Its filename was
     mm-break-up-swap_writepage-for-frontswap-backends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: mm: break up swap_writepage() for frontswap backends

swap_writepage() is currently where frontswap hooks into the swap write
path to capture pages with the frontswap_store() function.  However, if a
frontswap backend wants to "resume" the writeback of a page to the swap
device, it can't call swap_writepage() as the page will simply reenter the
backend.

This patch separates swap_writepage() into a top and bottom half, the
bottom half named __swap_writepage() to allow a frontswap backend, like
zswap, to resume writeback beyond the frontswap_store() hook.

__add_to_swap_cache() is also made non-static so that the page for
which writeback is to be resumed can be added to the swap cache.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 ++
 mm/page_io.c         |   14 +++++++++++---
 mm/swap_state.c      |    2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-break-up-swap_writepage-for-frontswap-backends include/linux/swap.h
--- a/include/linux/swap.h~mm-break-up-swap_writepage-for-frontswap-backends
+++ a/include/linux/swap.h
@@ -330,6 +330,7 @@ static inline void mem_cgroup_uncharge_s
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
+extern int __swap_writepage(struct page *page, struct writeback_control *wbc);
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
@@ -345,6 +346,7 @@ extern unsigned long total_swapcache_pag
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
+extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
diff -puN mm/page_io.c~mm-break-up-swap_writepage-for-frontswap-backends mm/page_io.c
--- a/mm/page_io.c~mm-break-up-swap_writepage-for-frontswap-backends
+++ a/mm/page_io.c
@@ -185,9 +185,7 @@ bad_bmap:
  */
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct bio *bio;
-	int ret = 0, rw = WRITE;
-	struct swap_info_struct *sis = page_swap_info(page);
+	int ret = 0;
 
 	if (try_to_free_swap(page)) {
 		unlock_page(page);
@@ -199,6 +197,16 @@ int swap_writepage(struct page *page, st
 		end_page_writeback(page);
 		goto out;
 	}
+	ret = __swap_writepage(page, wbc);
+out:
+	return ret;
+}
+
+int __swap_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct bio *bio;
+	int ret = 0, rw = WRITE;
+	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
 		struct kiocb kiocb;
diff -puN mm/swap_state.c~mm-break-up-swap_writepage-for-frontswap-backends mm/swap_state.c
--- a/mm/swap_state.c~mm-break-up-swap_writepage-for-frontswap-backends
+++ a/mm/swap_state.c
@@ -78,7 +78,7 @@ void show_swap_cache_info(void)
  * __add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
+int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
 	int error;
 	struct address_space *address_space;
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

origin.patch

