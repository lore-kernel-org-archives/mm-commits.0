From: akpm@linux-foundation.org
Subject: - mm-move-migrate_prep-out-from-under-mmap_sem.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:30 -0800
Message-ID: <200811102032.mAAKWUsI024001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYKJUla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, heiko.carstens@de.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vge


The patch titled
     mm: move migrate_prep out from under mmap_sem
has been removed from the -mm tree.  Its filename was
     mm-move-migrate_prep-out-from-under-mmap_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move migrate_prep out from under mmap_sem
From: Christoph Lameter <cl@linux-foundation.org>

Move the migrate_prep outside the mmap_sem for the following system calls

1. sys_move_pages
2. sys_migrate_pages
3. sys_mbind()

It really does not matter when we flush the lru.  The system is free to
add pages onto the lru even during migration which will make the page
migration either skip the page (mbind, migrate_pages) or return a busy
state (move_pages).

Fixes this lockdep warning (and potential deadlock):

Some VM place has
      mmap_sem -> kevent_wq via lru_add_drain_all()

net/core/dev.c::dev_ioctl()  has
     rtnl_lock  ->  mmap_sem        (*) the ioctl has copy_from_user() and it can do page fault.

linkwatch_event has
     kevent_wq -> rtnl_lock

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   18 +++++++++++-------
 mm/migrate.c   |    2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/mempolicy.c~mm-move-migrate_prep-out-from-under-mmap_sem mm/mempolicy.c
--- a/mm/mempolicy.c~mm-move-migrate_prep-out-from-under-mmap_sem
+++ a/mm/mempolicy.c
@@ -489,12 +489,6 @@ check_range(struct mm_struct *mm, unsign
 	int err;
 	struct vm_area_struct *first, *vma, *prev;
 
-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-
-		err = migrate_prep();
-		if (err)
-			return ERR_PTR(err);
-	}
 
 	first = find_vma(mm, start);
 	if (!first)
@@ -809,9 +803,13 @@ int do_migrate_pages(struct mm_struct *m
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
 {
 	int busy = 0;
-	int err = 0;
+	int err;
 	nodemask_t tmp;
 
+	err = migrate_prep();
+	if (err)
+		return err;
+
 	down_read(&mm->mmap_sem);
 
 	err = migrate_vmas(mm, from_nodes, to_nodes, flags);
@@ -974,6 +972,12 @@ static long do_mbind(unsigned long start
 		 start, start + len, mode, mode_flags,
 		 nmask ? nodes_addr(*nmask)[0] : -1);
 
+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
+
+		err = migrate_prep();
+		if (err)
+			return err;
+	}
 	down_write(&mm->mmap_sem);
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
diff -puN mm/migrate.c~mm-move-migrate_prep-out-from-under-mmap_sem mm/migrate.c
--- a/mm/migrate.c~mm-move-migrate_prep-out-from-under-mmap_sem
+++ a/mm/migrate.c
@@ -841,12 +841,12 @@ static int do_move_page_to_node_array(st
 	struct page_to_node *pp;
 	LIST_HEAD(pagelist);
 
+	migrate_prep();
 	down_read(&mm->mmap_sem);
 
 	/*
 	 * Build a list of pages to migrate
 	 */
-	migrate_prep();
 	for (pp = pm; pp->node != MAX_NUMNODES; pp++) {
 		struct vm_area_struct *vma;
 		struct page *page;
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
cpusets-update-mems-allowed-in-page-allocator.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
mm-remove-lru_add_drain_all-from-the-munlock-path.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch
mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch
alpha-use-generic-percpu-support.patch
reiser4.patch
slab-leaks3-default-y.patch

