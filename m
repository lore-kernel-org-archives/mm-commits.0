From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-frontswap-mark-various-intentional-data-races.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 17:05:37 -0800
Message-ID: <20200210010537.b-ZabVn8s%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgBJBFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 20:05:38 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap: mark various intentional data races
has been added to the -mm tree.  Its filename is
     mm-frontswap-mark-various-intentional-data-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-frontswap-mark-various-intentional-data-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-frontswap-mark-various-intentional-data-races.patch

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
Subject: mm/frontswap: mark various intentional data races

There are a few information counters that are intentionally not protected
against increment races, so just annotate them using the data_race()
macro.

 BUG: KCSAN: data-race in __frontswap_store / __frontswap_store

 write to 0xffffffff8b7174d8 of 8 bytes by task 6396 on cpu 103:
  __frontswap_store+0x2d0/0x344
  inc_frontswap_failed_stores at mm/frontswap.c:70
  (inlined by) __frontswap_store at mm/frontswap.c:280
  swap_writepage+0x83/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
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

 read to 0xffffffff8b7174d8 of 8 bytes by task 6405 on cpu 47:
  __frontswap_store+0x2b9/0x344
  inc_frontswap_failed_stores at mm/frontswap.c:70
  (inlined by) __frontswap_store at mm/frontswap.c:280
  swap_writepage+0x83/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
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

Link: http://lkml.kernel.org/r/1581114499-5042-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/frontswap.c~mm-frontswap-mark-various-intentional-data-races
+++ a/mm/frontswap.c
@@ -61,16 +61,16 @@ static u64 frontswap_failed_stores;
 static u64 frontswap_invalidates;
 
 static inline void inc_frontswap_loads(void) {
-	frontswap_loads++;
+	data_race(frontswap_loads++);
 }
 static inline void inc_frontswap_succ_stores(void) {
-	frontswap_succ_stores++;
+	data_race(frontswap_succ_stores++);
 }
 static inline void inc_frontswap_failed_stores(void) {
-	frontswap_failed_stores++;
+	data_race(frontswap_failed_stores++);
 }
 static inline void inc_frontswap_invalidates(void) {
-	frontswap_invalidates++;
+	data_race(frontswap_invalidates++);
 }
 #else
 static inline void inc_frontswap_loads(void) { }
_

Patches currently in -mm which might be from cai@lca.pw are

mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-frontswap-mark-various-intentional-data-races.patch
