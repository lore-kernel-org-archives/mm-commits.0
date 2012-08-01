From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:37 -0700
Message-ID: <20120801201438.0A8845C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61449 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:39 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr14so198985wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment
has been removed from the -mm tree.  Its filename was
     mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment
+++ a/mm/memcontrol.c
@@ -1898,7 +1898,7 @@ again:
 		return;
 	/*
 	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_page_cgroup(). Because we already hold
+	 * need to take move_lock_mem_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
 	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
 	 */
@@ -1920,7 +1920,7 @@ void __mem_cgroup_end_update_page_stat(s
 	/*
 	 * It's guaranteed that pc->mem_cgroup never changes while
 	 * lock is held because a routine modifies pc->mem_cgroup
-	 * should take move_lock_page_cgroup().
+	 * should take move_lock_mem_cgroup().
 	 */
 	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
 }
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

