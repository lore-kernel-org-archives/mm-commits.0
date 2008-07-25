From: akpm@linux-foundation.org
Subject: - mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:55:40 -0700
Message-ID: <200807252355.m6PNtevx006096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbYGYX4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix migration_entry_wait() for speculative page cache
has been removed from the -mm tree.  Its filename was
     mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch

This patch was dropped because it was folded into mm-speculative-page-references.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix migration_entry_wait() for speculative page cache
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In speculative page cache lookup protocol, page_count(page) is set to 0
while radix-tree modification is going on, truncation, migration, etc...

While page migration, a page fault to page under migration should wait
unlock_page() and migration_entry_wait() waits for the page from its pte
entry.  It does get_page() -> wait_on_page_locked() -> put_page() now.

In page migration, page_freeze_refs() -> page_unfreeze_refs() is called.

Here, page_unfreeze_refs() expects page_count(page) == 0 and panics if
page_count(page) != 0.  To avoid this, we shouldn't touch page_count() if
it is zero.  This patch uses page_cache_get_speculative() to avoid the
panic.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache mm/migrate.c
--- a/mm/migrate.c~mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache
+++ a/mm/migrate.c
@@ -285,7 +285,15 @@ void migration_entry_wait(struct mm_stru
 
 	page = migration_entry_to_page(entry);
 
-	get_page(page);
+	/*
+	 * Once radix-tree replacement of page migration started, page_count
+	 * *must* be zero. And, we don't want to call wait_on_page_locked()
+	 * against a page without get_page().
+	 * So, we use get_page_unless_zero(), here. Even failed, page fault
+	 * will occur again.
+	 */
+	if (!get_page_unless_zero(page))
+		goto out;
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

