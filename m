From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcontrol-prepare-swap-controller-setup-for-integration.patch added to
 -mm tree
Date: Fri, 08 May 2020 16:20:07 -0700
Message-ID: <20200508232007.tuPgUkqUH%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXUK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:20:10 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: prepare swap controller setup for integration
has been added to the -mm tree.  Its filename is
     mm-memcontrol-prepare-swap-controller-setup-for-integration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-prepare-swap-controller-setup-for-integration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: prepare swap controller setup for integration

A few cleanups to streamline the swap controller setup:

- Replace the do_swap_account flag with cgroup_memory_noswap. This
  brings it in line with other functionality that is usually available
  unless explicitly opted out of - nosocket, nokmem.

- Remove the really_do_swap_account flag that stores the boot option
  and is later used to switch the do_swap_account. It's not clear why
  this indirection is/was necessary. Use do_swap_account directly.

- Minor coding style polishing

Link: http://lkml.kernel.org/r/20200508183105.225460-15-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 mm/memcontrol.c            |   59 ++++++++++++++++-------------------
 mm/swap_cgroup.c           |    4 +-
 3 files changed, 31 insertions(+), 34 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-swap-controller-setup-for-integration
+++ a/include/linux/memcontrol.h
@@ -609,7 +609,7 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
 #ifdef CONFIG_MEMCG_SWAP
-extern int do_swap_account;
+extern bool cgroup_memory_noswap;
 #endif
 
 struct mem_cgroup *lock_page_memcg(struct page *page);
--- a/mm/memcontrol.c~mm-memcontrol-prepare-swap-controller-setup-for-integration
+++ a/mm/memcontrol.c
@@ -83,10 +83,14 @@ static bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-int do_swap_account __read_mostly;
+#ifdef CONFIG_MEMCG_SWAP_ENABLED
+bool cgroup_memory_noswap __read_mostly;
 #else
-#define do_swap_account		0
-#endif
+bool cgroup_memory_noswap __read_mostly = 1;
+#endif /* CONFIG_MEMCG_SWAP_ENABLED */
+#else
+#define cgroup_memory_noswap		1
+#endif /* CONFIG_MEMCG_SWAP */
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
@@ -95,7 +99,7 @@ static DECLARE_WAIT_QUEUE_HEAD(memcg_cgw
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && do_swap_account;
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
@@ -6458,18 +6462,19 @@ int mem_cgroup_charge(struct page *page,
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
-		 * already charged pages, too.  The USED bit is protected by
-		 * the page lock, which serializes swap cache removal, which
+		 * already charged pages, too.  page->mem_cgroup is protected
+		 * by the page lock, which serializes swap cache removal, which
 		 * in turn serializes uncharging.
 		 */
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		if (compound_head(page)->mem_cgroup)
 			goto out;
 
-		if (do_swap_account) {
+		if (!cgroup_memory_noswap) {
 			swp_entry_t ent = { .val = page_private(page), };
-			unsigned short id = lookup_swap_cgroup_id(ent);
+			unsigned short id;
 
+			id = lookup_swap_cgroup_id(ent);
 			rcu_read_lock();
 			memcg = mem_cgroup_from_id(id);
 			if (memcg && !css_tryget_online(&memcg->css))
@@ -6942,7 +6947,7 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !do_swap_account)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || cgroup_memory_noswap)
 		return 0;
 
 	memcg = page->mem_cgroup;
@@ -6986,7 +6991,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (!do_swap_account)
+	if (cgroup_memory_noswap)
 		return;
 
 	id = swap_cgroup_record(entry, 0, nr_pages);
@@ -7009,7 +7014,7 @@ long mem_cgroup_get_nr_swap_pages(struct
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (!do_swap_account || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return nr_swap_pages;
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
@@ -7026,7 +7031,7 @@ bool mem_cgroup_swap_full(struct page *p
 
 	if (vm_swap_full())
 		return true;
-	if (!do_swap_account || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
 	memcg = page->mem_cgroup;
@@ -7041,22 +7046,15 @@ bool mem_cgroup_swap_full(struct page *p
 	return false;
 }
 
-/* for remember boot option*/
-#ifdef CONFIG_MEMCG_SWAP_ENABLED
-static int really_do_swap_account __initdata = 1;
-#else
-static int really_do_swap_account __initdata;
-#endif
-
-static int __init enable_swap_account(char *s)
+static int __init setup_swap_account(char *s)
 {
 	if (!strcmp(s, "1"))
-		really_do_swap_account = 1;
+		cgroup_memory_noswap = 0;
 	else if (!strcmp(s, "0"))
-		really_do_swap_account = 0;
+		cgroup_memory_noswap = 1;
 	return 1;
 }
-__setup("swapaccount=", enable_swap_account);
+__setup("swapaccount=", setup_swap_account);
 
 static u64 swap_current_read(struct cgroup_subsys_state *css,
 			     struct cftype *cft)
@@ -7122,7 +7120,7 @@ static struct cftype swap_files[] = {
 	{ }	/* terminate */
 };
 
-static struct cftype memsw_cgroup_files[] = {
+static struct cftype memsw_files[] = {
 	{
 		.name = "memsw.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
@@ -7151,13 +7149,12 @@ static struct cftype memsw_cgroup_files[
 
 static int __init mem_cgroup_swap_init(void)
 {
-	if (!mem_cgroup_disabled() && really_do_swap_account) {
-		do_swap_account = 1;
-		WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys,
-					       swap_files));
-		WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys,
-						  memsw_cgroup_files));
-	}
+	if (mem_cgroup_disabled() || cgroup_memory_noswap)
+		return 0;
+
+	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
+	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
+
 	return 0;
 }
 subsys_initcall(mem_cgroup_swap_init);
--- a/mm/swap_cgroup.c~mm-memcontrol-prepare-swap-controller-setup-for-integration
+++ a/mm/swap_cgroup.c
@@ -171,7 +171,7 @@ int swap_cgroup_swapon(int type, unsigne
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (!do_swap_account)
+	if (cgroup_memory_noswap)
 		return 0;
 
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
@@ -209,7 +209,7 @@ void swap_cgroup_swapoff(int type)
 	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (!do_swap_account)
+	if (cgroup_memory_noswap)
 		return;
 
 	mutex_lock(&swap_cgroup_mutex);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
