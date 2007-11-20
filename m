From: akpm@linux-foundation.org
Subject: + slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch added to -mm tree
Date: Mon, 19 Nov 2007 17:04:50 -0800
Message-ID: <200711200104.lAK14oZ5005743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbXKTBK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 20:10:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, clameter@sgi.com, kamalesh@linux.vnet.ibm.com


The patch titled
     slub: workaround for lockdep confusion
has been added to the -mm tree.  Its filename is
     slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: workaround for lockdep confusion
From: root@programming.kicks-ass.net (root)

inconsistent {softirq-on-W} -> {in-softirq-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
 (&n->list_lock){-+..}, at: [<ffffffff802935c1>] add_partial+0x31/0xa0
{softirq-on-W} state was registered at:
  [<ffffffff80259fb8>] __lock_acquire+0x3e8/0x1140
  [<ffffffff80259838>] debug_check_no_locks_freed+0x188/0x1a0
  [<ffffffff8025ad65>] lock_acquire+0x55/0x70
  [<ffffffff802935c1>] add_partial+0x31/0xa0
  [<ffffffff805c76de>] _spin_lock+0x1e/0x30
  [<ffffffff802935c1>] add_partial+0x31/0xa0
  [<ffffffff80296f9c>] kmem_cache_open+0x1cc/0x330
  [<ffffffff805c7984>] _spin_unlock_irq+0x24/0x30
  [<ffffffff802974f4>] create_kmalloc_cache+0x64/0xf0
  [<ffffffff80295640>] init_alloc_cpu_cpu+0x70/0x90
  [<ffffffff8080ada5>] kmem_cache_init+0x65/0x1d0
  [<ffffffff807f1b4e>] start_kernel+0x23e/0x350
  [<ffffffff807f112d>] _sinittext+0x12d/0x140
  [<ffffffffffffffff>] 0xffffffffffffffff

This change isn't really necessary for correctness, but it prevents lockdep
from getting upset and then disabling itself.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/slub.c~slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion mm/slub.c
--- a/mm/slub.c~slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion
+++ a/mm/slub.c
@@ -2002,6 +2002,7 @@ static struct kmem_cache_node *early_kme
 {
 	struct page *page;
 	struct kmem_cache_node *n;
+	unsigned long flags;
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
@@ -2026,7 +2027,14 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
+	/*
+	 * lockdep requires consistent irq usage for each lock
+	 * so even though there cannot be a race this early in
+	 * the boot sequence, we still disable irqs.
+	 */
+	local_irq_save(flags);
 	add_partial(kmalloc_caches, page, 0);
+	local_irq_restore(flags);
 	return n;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
