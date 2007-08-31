From: akpm@linux-foundation.org
Subject: - fix-rcu_read_lock-in-page-migraton.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:45 -0700
Message-ID: <200708311655.l7VGtjFq017427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759683AbXHaQzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     fix rcu_read_lock() in page migraton
has been removed from the -mm tree.  Its filename was
     fix-rcu_read_lock-in-page-migraton.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix rcu_read_lock() in page migraton
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In migration fallback path, write_page() or lock_page() will be called.
This causes sleep with holding rcu_read_lock().
For avoding that, just do rcu_lock if the page is Anon.(this is enough.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~fix-rcu_read_lock-in-page-migraton mm/migrate.c
--- a/mm/migrate.c~fix-rcu_read_lock-in-page-migraton
+++ a/mm/migrate.c
@@ -611,6 +611,7 @@ static int unmap_and_move(new_page_t get
 	int rc = 0;
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
+	int rcu_locked = 0;
 
 	if (!newpage)
 		return -ENOMEM;
@@ -636,8 +637,13 @@ static int unmap_and_move(new_page_t get
 	 * we cannot notice that anon_vma is freed while we migrates a page.
 	 * This rcu_read_lock() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
+	 * File Caches may use write_page() or lock_page() in migration, then,
+	 * just care Anon page here.
 	 */
-	rcu_read_lock();
+	if (PageAnon(page)) {
+		rcu_read_lock();
+		rcu_locked = 1;
+	}
 	/*
 	 * This is a corner case handling.
 	 * When a new swap-cache is read into, it is linked to LRU
@@ -656,7 +662,8 @@ static int unmap_and_move(new_page_t get
 	if (rc)
 		remove_migration_ptes(page, page);
 rcu_unlock:
-	rcu_read_unlock();
+	if (rcu_locked)
+		rcu_read_unlock();
 
 unlock:
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
