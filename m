From: akpm@linux-foundation.org
Subject: - bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch removed from -mm tree
Date: Wed, 06 Feb 2008 23:25:53 -0800
Message-ID: <200802070725.m177PYAG021853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbYBGH0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 02:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     bugfix for memory cgroup controller: fix error handling path in mem_charge_cgroup
has been removed from the -mm tree.  Its filename was
     bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch

This patch was dropped because it was folded into memory-controller-add-per-container-lru-and-reclaim-v7.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for memory cgroup controller: fix error handling path in mem_charge_cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This unlock_page_cgroup() is unnecessary.

Changelog: v1 -> v2
 * adjusted to 2.6.23-mm1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup
+++ a/mm/memcontrol.c
@@ -392,9 +392,7 @@ done:
 	return 0;
 free_pc:
 	kfree(pc);
-	return -ENOMEM;
 err:
-	unlock_page_cgroup(page);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
memory-controller-improve-user-interface.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
memory-controller-remove-control_type-feature.patch
update-documentation-controller-memorytxt.patch
