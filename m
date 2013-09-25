From: akpm@linux-foundation.org
Subject: +
 mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch added to
 -mm tree
Date: Wed, 25 Sep 2013 15:42:33 -0700
Message-ID: <524366d9.2W4bSNTJ0grfois4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3IYWme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 18:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mel@csn.ul.ie, lcapitulino@redhat.com, hughd@google.com, hannes@cmpxchg.org, aquini@redhat.com

Subject: + mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch added to -mm tree
To: aquini@redhat.com,hannes@cmpxchg.org,hughd@google.com,lcapitulino@redhat.com,mel@csn.ul.ie,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 15:42:33 -0700


The patch titled
     Subject: mm: avoid reinserting isolated balloon pages into LRU lists
has been added to the -mm tree.  Its filename is
     mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: avoid reinserting isolated balloon pages into LRU lists

Isolated balloon pages can wrongly end up in LRU lists when
migrate_pages() finishes its round without draining all the isolated page
list.  The same issue can happen when reclaim_clean_pages_from_list()
tries to reclaim pages from an isolated page list, before migration, in
the CMA path.  Such balloon page leak opens a race window against LRU
lists shrinkers that leads us to the following kernel panic:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
  IP: [<ffffffff810c2625>] shrink_page_list+0x24e/0x897
  PGD 3cda2067 PUD 3d713067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 340 Comm: kswapd0 Not tainted 3.12.0-rc1-22626-g4367597 #87
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  task: ffff88003d920ee0 ti: ffff88003da48000 task.ti: ffff88003da48000
  RIP: 0010:[<ffffffff810c2625>]  [<ffffffff810c2625>] shrink_page_list+0x24e/0x897
  RSP: 0000:ffff88003da499b8  EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff88003e82bd60 RCX: 00000000000657d5
  RDX: 0000000000000000 RSI: 000000000000031f RDI: ffff88003e82bd40
  RBP: ffff88003da49ab0 R08: 0000000000000001 R09: 0000000081121a45
  R10: ffffffff81121a45 R11: ffff88003c4a9a28 R12: ffff88003e82bd40
  R13: ffff88003da0e800 R14: 0000000000000001 R15: ffff88003da49d58
  FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000067d9000 CR3: 000000003ace5000 CR4: 00000000000407b0
  Stack:
   ffff88003d920ee0 ffff88003d920ee0 ffff88003da49a50 ffff88003da49a40
   ffff88003da49b18 ffff88003da49b08 0000000000a499e0 ffffffff81667fc0
   0000000000000000 0000000000000000 0000000000000000 0000000000000000
  Call Trace:
   [<ffffffff8107507f>] ? lock_release+0x188/0x1d7
   [<ffffffff810c31f8>] shrink_inactive_list+0x240/0x3de
   [<ffffffff810c3a3b>] shrink_lruvec+0x3e0/0x566
   [<ffffffff810734c4>] ? __lock_is_held+0x38/0x50
   [<ffffffff810c3c55>] __shrink_zone+0x94/0x178
   [<ffffffff810c3d73>] shrink_zone+0x3a/0x82
   [<ffffffff810c4818>] balance_pgdat+0x32a/0x4c2
   [<ffffffff810c4ca0>] kswapd+0x2f0/0x372
   [<ffffffff8104fb93>] ? abort_exclusive_wait+0x8b/0x8b
   [<ffffffff810c49b0>] ? balance_pgdat+0x4c2/0x4c2
   [<ffffffff8104ef73>] kthread+0xa2/0xaa
   [<ffffffff8104eed1>] ? __kthread_parkme+0x65/0x65
   [<ffffffff81364f6c>] ret_from_fork+0x7c/0xb0
   [<ffffffff8104eed1>] ? __kthread_parkme+0x65/0x65
  Code: 80 7d 8f 01 48 83 95 68 ff ff ff 00 4c 89 e7 e8 5a 7b 00 00 48 85 c0 49 89 c5 75 08 80 7d 8f 00 74 3e eb 31 48 8b 80 18 01 00 00 <48> 8b 74 0d 48 8b 78 30 be 02 00 00 00 ff d2 eb
  RIP  [<ffffffff810c2625>] shrink_page_list+0x24e/0x897
   RSP <ffff88003da499b8>
  CR2: 0000000000000028
  ---[ end trace 703d2451af6ffbfd ]---
  Kernel panic - not syncing: Fatal exception

This patch fixes the issue, by assuring the proper tests are made at
putback_movable_pages() & reclaim_clean_pages_from_list() to avoid
isolated balloon pages being wrongly reinserted in LRU lists.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reported-by: Luiz Capitulino <lcapitulino@redhat.com>
Tested-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   25 +++++++++++++++++++++++++
 mm/migrate.c                       |    2 +-
 mm/vmscan.c                        |    4 +++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists
+++ a/include/linux/balloon_compaction.h
@@ -159,6 +159,26 @@ static inline bool balloon_page_movable(
 }
 
 /*
+ * isolated_balloon_page - identify an isolated balloon page on private
+ *			   compaction/migration page lists.
+ *
+ * After a compaction thread isolates a balloon page for migration, it raises
+ * the page refcount to avoid concurrent compaction threads on re-isolating the
+ * same page. For that reason putback_movable_pages(), or other routines
+ * that need to identify isolated balloon pages on private pagelists, cannot
+ * rely on balloon_page_movable() to accomplish the task.
+ */
+static inline bool isolated_balloon_page(struct page *page)
+{
+	/* Already isolated balloon pages, by default, have a raised refcount */
+	if (page_flags_cleared(page) && !page_mapped(page) &&
+	    page_count(page) >= 2)
+		return __is_movable_balloon_page(page);
+
+	return false;
+}
+
+/*
  * balloon_page_insert - insert a page into the balloon's page list and make
  *		         the page->mapping assignment accordingly.
  * @page    : page to be assigned as a 'balloon page'
@@ -242,6 +262,11 @@ static inline bool balloon_page_movable(
 {
 	return false;
 }
+
+static inline bool isolated_balloon_page(struct page *page)
+{
+	return false;
+}
 
 static inline bool balloon_page_isolate(struct page *page)
 {
diff -puN mm/migrate.c~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists mm/migrate.c
--- a/mm/migrate.c~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists
+++ a/mm/migrate.c
@@ -107,7 +107,7 @@ void putback_movable_pages(struct list_h
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (unlikely(balloon_page_movable(page)))
+		if (unlikely(isolated_balloon_page(page)))
 			balloon_page_putback(page);
 		else
 			putback_lru_page(page);
diff -puN mm/vmscan.c~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists
+++ a/mm/vmscan.c
@@ -48,6 +48,7 @@
 #include <asm/div64.h>
 
 #include <linux/swapops.h>
+#include <linux/balloon_compaction.h>
 
 #include "internal.h"
 
@@ -1113,7 +1114,8 @@ unsigned long reclaim_clean_pages_from_l
 	LIST_HEAD(clean_pages);
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (page_is_file_cache(page) && !PageDirty(page)) {
+		if (page_is_file_cache(page) && !PageDirty(page) &&
+		    !isolated_balloon_page(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch

