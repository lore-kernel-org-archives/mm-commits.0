From: akpm@linux-foundation.org
Subject: - memcg-make-global-var-read_mostly.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:35 -0700
Message-ID: <200807252258.m6PMwZxH003302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbYGYXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: make global var read_mostly
has been removed from the -mm tree.  Its filename was
     memcg-make-global-var-read_mostly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make global var read_mostly
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_subsys and page_cgroup_cache should be read_mostly and
MEM_CGROUP_RECLAIM_RETRIES can be just a fixed number.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-global-var-read_mostly mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-global-var-read_mostly
+++ a/mm/memcontrol.c
@@ -35,9 +35,9 @@
 
 #include <asm/uaccess.h>
 
-struct cgroup_subsys mem_cgroup_subsys;
-static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
-static struct kmem_cache *page_cgroup_cache;
+struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+static struct kmem_cache *page_cgroup_cache __read_mostly;
+#define MEM_CGROUP_RECLAIM_RETRIES	5
 
 /*
  * Statistics for memory cgroup.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

