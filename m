From: akpm@linux-foundation.org
Subject: - memcg-remove-redundant-check-in-move_task.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:14 -0700
Message-ID: <200807301914.m6UJEEhe010892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYG3Tbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove redundant check in move_task()
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-check-in-move_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant check in move_task()
From: Li Zefan <lizf@cn.fujitsu.com>

It's guaranteed by cgroup that old_cgrp != cgrp.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-check-in-move_task mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-check-in-move_task
+++ a/mm/memcontrol.c
@@ -1168,9 +1168,6 @@ static void mem_cgroup_move_task(struct 
 	mem = mem_cgroup_from_cont(cont);
 	old_mem = mem_cgroup_from_cont(old_cont);
 
-	if (mem == old_mem)
-		goto out;
