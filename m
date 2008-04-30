From: akpm@linux-foundation.org
Subject: - memcg-remove-redundant-initialization-in-mem_cgroup_create.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:18 -0700
Message-ID: <200804300543.m3U5hIM4029305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380AbYD3FoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove redundant initialization in mem_cgroup_create()
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-initialization-in-mem_cgroup_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant initialization in mem_cgroup_create()
From: Li Zefan <lizf@cn.fujitsu.com>

*mem has been zeroed, that means mem->info has already been filled with 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-initialization-in-mem_cgroup_create mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-initialization-in-mem_cgroup_create
+++ a/mm/memcontrol.c
@@ -1024,8 +1024,6 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	res_counter_init(&mem->res);
 
-	memset(&mem->info, 0, sizeof(mem->info));
