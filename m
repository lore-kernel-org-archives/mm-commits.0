From: akpm@linux-foundation.org
Subject: + mm-memcontrol-track-move_lock-state-internally-fix.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 13:46:31 -0800
Message-ID: <54ac57b7.7+8So9OcjROSkQOX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbbAFVqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 16:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: track move_lock state internally fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-track-move_lock-state-internally-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-track-move_lock-state-internally-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-track-move_lock-state-internally-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: track move_lock state internally fix

Update the !CONFIG_MEMCG page stat dummy API.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally-fix
+++ a/include/linux/memcontrol.h
@@ -283,14 +283,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
 {
 	return NULL;
 }
 
-static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool *locked, unsigned long *flags)
+static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
 {
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

