From: akpm@linux-foundation.org
Subject: + mm-break-up-swap_writepage-for-frontswap-backends.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:11:36 -0700
Message-ID: <20130411231136.DD23831C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:57108 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3DKXLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:11:38 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so196961ghr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:11:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, dan.magenheimer@oracle.com, konrad.wilk@oracle.com, minchan@kernel.org


The patch titled
     Subject: mm: break up swap_writepage() for frontswap backends
has been added to the -mm tree.  Its filename is
     mm-break-up-swap_writepage-for-frontswap-backends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -184,9 +184,7 @@ bad_bmap:
  */
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct bio *bio;
-	int ret = 0, rw = WRITE;
-	struct swap_info_struct *sis = page_swap_info(page);
+	int ret = 0;
 
 	if (try_to_free_swap(page)) {
 		unlock_page(page);
@@ -198,6 +196,16 @@ int swap_writepage(struct page *page, st
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

mm-break-up-swap_writepage-for-frontswap-backends.patch
mm-allow-for-outstanding-swap-writeback-accounting.patch

