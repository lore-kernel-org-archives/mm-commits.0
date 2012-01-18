From: akpm@linux-foundation.org
Subject: + mm-fix-rss-count-leakage-during-migration.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:21:56 -0800
Message-ID: <20120118232157.32F4F1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:60889 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2ARXV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:21:58 -0500
Received: by yhjj52 with SMTP id j52so660594yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:21:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm: fix rss count leakage during migration
has been added to the -mm tree.  Its filename is
     mm-fix-rss-count-leakage-during-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: fix rss count leakage during migration

Memory migration fills a pte with a migration entry and it doesn't update
the rss counters.  Then it replaces the migration entry with the new page
(or the old one if migration failed).  But between these two passes this
pte can be unmaped, or a task can fork a child and it will get a copy of
this migration entry.  Nobody accounts for this in the rss counters.

This patch properly adjust rss counters for migration entries in
zap_pte_range() and copy_one_pte().  Thus we avoid extra atomic operations
on the migration fast-path.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN mm/memory.c~mm-fix-rss-count-leakage-during-migration mm/memory.c
--- a/mm/memory.c~mm-fix-rss-count-leakage-during-migration
+++ a/mm/memory.c
@@ -878,15 +878,24 @@ copy_one_pte(struct mm_struct *dst_mm, s
 			}
 			if (likely(!non_swap_entry(entry)))
 				rss[MM_SWAPENTS]++;
-			else if (is_write_migration_entry(entry) &&
-					is_cow_mapping(vm_flags)) {
-				/*
-				 * COW mappings require pages in both parent
-				 * and child to be set to read.
-				 */
-				make_migration_entry_read(&entry);
-				pte = swp_entry_to_pte(entry);
-				set_pte_at(src_mm, addr, src_pte, pte);
+			else if (is_migration_entry(entry)) {
+				page = migration_entry_to_page(entry);
+
+				if (PageAnon(page))
+					rss[MM_ANONPAGES]++;
+				else
+					rss[MM_FILEPAGES]++;
+
+				if (is_write_migration_entry(entry) &&
+				    is_cow_mapping(vm_flags)) {
+					/*
+					 * COW mappings require pages in both
+					 * parent and child to be set to read.
+					 */
+					make_migration_entry_read(&entry);
+					pte = swp_entry_to_pte(entry);
+					set_pte_at(src_mm, addr, src_pte, pte);
+				}
 			}
 		}
 		goto out_set_pte;
@@ -1191,6 +1200,16 @@ again:
 
 			if (!non_swap_entry(entry))
 				rss[MM_SWAPENTS]--;
+			else if (is_migration_entry(entry)) {
+				struct page *page;
+
+				page = migration_entry_to_page(entry);
+
+				if (PageAnon(page))
+					rss[MM_ANONPAGES]--;
+				else
+					rss[MM_FILEPAGES]--;
+			}
 			if (unlikely(!free_swap_and_cache(entry)))
 				print_bad_pte(vma, addr, ptent, NULL);
 		}
_
Subject: Subject: mm: fix rss count leakage during migration

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-rss-count-leakage-during-migration.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

