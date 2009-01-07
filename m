From: akpm@linux-foundation.org
Subject: - memory-cgroup-hierarchy-feature-selector-v4-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:15:37 -0800
Message-ID: <200901072315.n07NFcUW000324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761422AbZAGXQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.c


The patch titled
     Memory cgroup fix hierarchy selector
has been removed from the -mm tree.  Its filename was
     memory-cgroup-hierarchy-feature-selector-v4-fix.patch

This patch was dropped because it was folded into memory-cgroup-hierarchy-feature-selector-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory cgroup fix hierarchy selector
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Andrew and Li reviewed and found that we need to check for val being 1 or
0 for the root container as well.  use_hierarchy's type is changed to
bool.  We still continue to use the ease of write_X64 for writing to it
and then check if the values are sane.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4-fix
+++ a/mm/memcontrol.c
@@ -152,7 +152,7 @@ struct mem_cgroup {
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
-	unsigned long use_hierarchy;
+	bool use_hierarchy;
 
 	int		obsolete;
 	atomic_t	refcnt;
@@ -1572,8 +1572,8 @@ static int mem_cgroup_hierarchy_write(st
 	 * For the root cgroup, parent_mem is NULL, we allow value to be
 	 * set if there are no children.
 	 */
-	if (!parent_mem || (!parent_mem->use_hierarchy &&
-				(val == 1 || val == 0))) {
+	if ((!parent_mem || !parent_mem->use_hierarchy) &&
+				(val == 1 || val == 0)) {
 		if (list_empty(&cont->children))
 			mem->use_hierarchy = val;
 		else
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch

