From: akpm@linux-foundation.org
Subject: +
 mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch
 added to -mm tree
Date: Tue, 10 Oct 2017 13:48:27 -0700
Message-ID: <59dd321b.exTug9pl8DFABmxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755653AbdJJUs3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference
has been added to the -mm tree.  Its filename is
     mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference

When SWP_SYNCHRONOUS_IO swapped-in pages are shared by several processes,
it can cause unnecessary memory wastage by skipping swap cache.  Because,
with swapin fault by read, they could share a page if the page were in
swap cache.  Thus, it avoids allocating same content new pages.

This patch makes the swapcache skipping work only if the swap pte is
non-sharable.

Link: http://lkml.kernel.org/r/1507620825-5537-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memory.c          |   19 ++++++++++---------
 mm/swapfile.c        |    7 +++++++
 3 files changed, 23 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference
+++ a/include/linux/swap.h
@@ -458,6 +458,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int __swap_count(struct swap_info_struct *si, swp_entry_t entry);
 extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
@@ -583,6 +584,11 @@ static inline int page_swapcount(struct
 {
 	return 0;
 }
+
+static inline int __swap_count(struct swap_info_struct *si, swp_entry_t entry)
+{
+	return 0;
+}
 
 static inline int __swp_swapcount(swp_entry_t entry)
 {
diff -puN mm/memory.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference mm/memory.c
--- a/mm/memory.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference
+++ a/mm/memory.c
@@ -2890,15 +2890,8 @@ int do_swap_page(struct vm_fault *vmf)
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
-		if (!(si->flags & SWP_SYNCHRONOUS_IO)) {
-			if (vma_readahead)
-				page = do_swap_page_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
-			else
-				page = swapin_readahead(entry,
-					GFP_HIGHUSER_MOVABLE, vma, vmf->address);
-			swapcache = page;
-		} else {
+		if (si->flags & SWP_SYNCHRONOUS_IO &&
+				__swap_count(si, entry) == 1) {
 			/* skip swapcache */
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
 			if (page) {
@@ -2908,6 +2901,14 @@ int do_swap_page(struct vm_fault *vmf)
 				lru_cache_add_anon(page);
 				swap_readpage(page, true);
 			}
+		} else {
+			if (vma_readahead)
+				page = do_swap_page_readahead(entry,
+					GFP_HIGHUSER_MOVABLE, vmf, &swap_ra);
+			else
+				page = swapin_readahead(entry,
+					GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+			swapcache = page;
 		}
 
 		if (!page) {
diff -puN mm/swapfile.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference
+++ a/mm/swapfile.c
@@ -1328,6 +1328,13 @@ int page_swapcount(struct page *page)
 	return count;
 }
 
+int __swap_count(struct swap_info_struct *si, swp_entry_t entry)
+{
+	pgoff_t offset = swp_offset(entry);
+
+	return swap_count(si->swap_map[offset]);
+}
+
 static int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
 {
 	int count = 0;
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-set-bdi_cap_stable_writes-once.patch
bdi-introduce-bdi_cap_synchronous_io.patch
mm-swap-introduce-swp_synchronous_io.patch
mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference.patch

