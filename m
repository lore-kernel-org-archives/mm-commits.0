From: akpm@linux-foundation.org
Subject: + mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch added to -mm tree
Date: Mon, 25 Jan 2010 17:11:40 -0800
Message-ID: <201001260111.o0Q1BeWk022249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab0AZBMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 20:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     mm/migrate.c: kill anon local variable from migrate_page_copy
has been added to the -mm tree.  Its filename is
     mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/migrate.c: kill anon local variable from migrate_page_copy
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 01b1ae63c2 ("memcg: simple migration handling") removed
mem_cgroup_uncharge_cache_page() call from migrate_page_copy.  Local
variable `anon' is now unused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/migrate.c~mm-migratec-kill-anon-local-variable-from-migrate_page_copy mm/migrate.c
--- a/mm/migrate.c~mm-migratec-kill-anon-local-variable-from-migrate_page_copy
+++ a/mm/migrate.c
@@ -275,8 +275,6 @@ static int migrate_page_move_mapping(str
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	int anon;
-
 	copy_highpage(newpage, page);
 
 	if (PageError(page))
@@ -313,8 +311,6 @@ static void migrate_page_copy(struct pag
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	/* page->mapping contains a flag for PageAnon() */
-	anon = PageAnon(page);
 	page->mapping = NULL;
 
 	/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

