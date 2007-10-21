From: akpm@linux-foundation.org
Subject: - memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:49:15 -0700
Message-ID: <200710212349.l9LNnFia000768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbXJUXzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm/memcontrol.c: clenups
has been removed from the -mm tree.  Its filename was
     memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch

This patch was dropped because it was folded into memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch

------------------------------------------------------
Subject: mm/memcontrol.c: clenups
From: Adrian Bunk <bunk@kernel.org>

- lock_page_cgroup()
- unlock_page_cgroup()
- __mem_cgroup_move_lists()

Additionally, there was no reason for the "mem_control_type" object.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup
+++ a/mm/memcontrol.c
@@ -91,7 +91,7 @@ enum {
 	MEM_CGROUP_TYPE_CACHED,
 	MEM_CGROUP_TYPE_ALL,
 	MEM_CGROUP_TYPE_MAX,
-} mem_control_type;
+};
 
 static struct mem_cgroup init_mem_cgroup;
 
@@ -151,18 +151,18 @@ struct page_cgroup *page_get_page_con
 		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
 }
 
-void __always_inline lock_page_cgroup(struct page *page)
+static void __always_inline lock_page_cgroup(struct page *page)
 {
 	bit_spin_lock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 	VM_BUG_ON(!page_cgroup_locked(page));
 }
 
-void __always_inline unlock_page_cgroup(struct page *page)
+static void __always_inline unlock_page_cgroup(struct page *page)
 {
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
-void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
+static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	if (active)
 		list_move(&pc->lru, &pc->mem_cgroup->active_list);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-scsi-misc.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
reiser4.patch
