From: akpm@linux-foundation.org
Subject: - memory-unplug-v7-migration-by-kernel.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:51 -0700
Message-ID: <200707290611.l6T6Bpg9011010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757510AbXG2GMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     memory unplug: migration by kernel
has been removed from the -mm tree.  Its filename was
     memory-unplug-v7-migration-by-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory unplug: migration by kernel
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In usual, migrate_pages(page,,) is called with holding mm->sem by system call.
(mm here is a mm_struct which maps the migration target page.)
This semaphore helps avoiding some race conditions.

But, if we want to migrate a page by some kernel codes, we have to avoid
some races. This patch adds check code for following race condition.

1. A page which page->mapping==NULL can be target of migration. Then, we have
   to check page->mapping before calling try_to_unmap().

2. anon_vma can be freed while page is unmapped, but page->mapping remains as
   it was. We drop page->mapcount to be 0. Then we cannot trust page->mapping.
   So, use rcu_read_lock() to prevent anon_vma pointed by page->mapping from
   being freed during migration.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~memory-unplug-v7-migration-by-kernel mm/migrate.c
--- a/mm/migrate.c~memory-unplug-v7-migration-by-kernel
+++ a/mm/migrate.c
@@ -632,18 +632,35 @@ static int unmap_and_move(new_page_t get
 			goto unlock;
 		wait_on_page_writeback(page);
 	}
-
 	/*
-	 * Establish migration ptes or remove ptes
+	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
+	 * we cannot notice that anon_vma is freed while we migrates a page.
+	 * This rcu_read_lock() delays freeing anon_vma pointer until the end
+	 * of migration. File cache pages are no problem because of page_lock()
+	 */
+	rcu_read_lock();
+	/*
+	 * This is a corner case handling.
+	 * When a new swap-cache is read into, it is linked to LRU
+	 * and treated as swapcache but has no rmap yet.
+	 * Calling try_to_unmap() against a page->mapping==NULL page is
+	 * BUG. So handle it here.
 	 */
+	if (!page->mapping)
+		goto rcu_unlock;
+	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
+
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page);
 
 	if (rc)
 		remove_migration_ptes(page, page);
+rcu_unlock:
+	rcu_read_unlock();
 
 unlock:
+
 	unlock_page(page);
 
 	if (rc != -EAGAIN) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
