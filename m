From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-mark-various-intentional-data-races.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 18:01:56 -0800
Message-ID: <20200210020156.sKUQ80NK5%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgBJCB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 21:01:57 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state: mark various intentional data races
has been added to the -mm tree.  Its filename is
     mm-swap_state-mark-various-intentional-data-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_state-mark-various-intentional-data-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_state-mark-various-intentional-data-races.patch

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
Subject: mm/swap_state: mark various intentional data races

swap_cache_info.* could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in lookup_swap_cache / lookup_swap_cache

 write to 0xffffffff85517318 of 8 bytes by task 94138 on cpu 101:
  lookup_swap_cache+0x12e/0x460
  lookup_swap_cache at mm/swap_state.c:322
  do_swap_page+0x112/0xeb0
  __handle_mm_fault+0xc7a/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffffffff85517318 of 8 bytes by task 91655 on cpu 100:
  lookup_swap_cache+0x117/0x460
  lookup_swap_cache at mm/swap_state.c:322
  shmem_swapin_page+0xc7/0x9e0
  shmem_getpage_gfp+0x2ca/0x16c0
  shmem_fault+0xef/0x3c0
  __do_fault+0x9e/0x220
  do_fault+0x4a0/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 100 PID: 91655 Comm: systemd-journal Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

 write to 0xffffffff8d717308 of 8 bytes by task 11365 on cpu 87:
   __delete_from_swap_cache+0x681/0x8b0
   __delete_from_swap_cache at mm/swap_state.c:178

 read to 0xffffffff8d717308 of 8 bytes by task 11275 on cpu 53:
   __delete_from_swap_cache+0x66e/0x8b0
   __delete_from_swap_cache at mm/swap_state.c:178

Both the read and write are done as lockless. Since swap_cache_info.*
are only used to print out counter information, even if any of them
missed a few incremental due to data races, it will be harmless, so just
mark it as an intentional data race using the data_race() macro.

While at it, fix a checkpatch.pl warning,

WARNING: Single statement macros should not use a do {} while (0) loop

Link: http://lkml.kernel.org/r/20200207003715.1578-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-mark-various-intentional-data-races
+++ a/mm/swap_state.c
@@ -58,8 +58,8 @@ static bool enable_vma_readahead __read_
 #define GET_SWAP_RA_VAL(vma)					\
 	(atomic_long_read(&(vma)->swap_readahead_info) ? : 4)
 
-#define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
-#define ADD_CACHE_INFO(x, nr)	do { swap_cache_info.x += (nr); } while (0)
+#define INC_CACHE_INFO(x)	data_race(swap_cache_info.x++)
+#define ADD_CACHE_INFO(x, nr)	data_race(swap_cache_info.x += (nr))
 
 static struct {
 	unsigned long add_total;
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-and-annotate-various-data-races.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
