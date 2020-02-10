From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-mark-various-intentional-data-races.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 18:01:52 -0800
Message-ID: <20200210020152.T30V2BlSQ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgBJCBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 21:01:53 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: mark various intentional data races
has been added to the -mm tree.  Its filename is
     mm-page_io-mark-various-intentional-data-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_io-mark-various-intentional-data-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_io-mark-various-intentional-data-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_io: mark various intentional data races

struct swap_info_struct si.flags could be accessed concurrently as noticed
by KCSAN,

 BUG: KCSAN: data-race in scan_swap_map_slots / swap_readpage

 write to 0xffff9c77b80ac400 of 8 bytes by task 91325 on cpu 16:
  scan_swap_map_slots+0x6fe/0xb50
  scan_swap_map_slots at mm/swapfile.c:887
  get_swap_pages+0x39d/0x5c0
  get_swap_page+0x377/0x524
  add_to_swap+0xe4/0x1c0
  shrink_page_list+0x1740/0x2820
  shrink_inactive_list+0x316/0x8b0
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9c77b80ac400 of 8 bytes by task 5422 on cpu 7:
  swap_readpage+0x204/0x6a0
  swap_readpage at mm/page_io.c:380
  read_swap_cache_async+0xa2/0xb0
  swapin_readahead+0x6a0/0x890
  do_swap_page+0x465/0xeb0
  __handle_mm_fault+0xc7a/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 7 PID: 5422 Comm: gmain Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

Other reads,

 read to 0xffff91ea33eac400 of 8 bytes by task 11276 on cpu 120:
  __swap_writepage+0x140/0xc20
  __swap_writepage at mm/page_io.c:289

 read to 0xffff91ea33eac400 of 8 bytes by task 11264 on cpu 16:
  swap_set_page_dirty+0x44/0x1f4
  swap_set_page_dirty at mm/page_io.c:442

The write is under &si->lock, but the reads are done as lockless.  Since
the reads only check for a specific bit in the flag, it is harmless even
if load tearing happens.  Thus, just mark them as intentional data races
using the data_race() macro.

Link: http://lkml.kernel.org/r/20200207003601.1526-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-page_io-mark-various-intentional-data-races
+++ a/mm/page_io.c
@@ -286,7 +286,7 @@ int __swap_writepage(struct page *page,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -377,7 +377,7 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -439,7 +439,7 @@ int swap_set_page_dirty(struct page *pag
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-and-annotate-various-data-races.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
