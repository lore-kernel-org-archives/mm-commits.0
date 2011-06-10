From: akpm@linux-foundation.org
Subject: + mm-memorynuma_stat-fix-file-permission.patch added to -mm tree
Date: Fri, 10 Jun 2011 00:56:12 -0700
Message-ID: <201106100754.p5A7suQM029544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab1FJHzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Jun 2011 03:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: memory.numa_stat: fix file permission
has been added to the -mm tree.  Its filename is
     mm-memorynuma_stat-fix-file-permission.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: memory.numa_stat: fix file permission
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Commit 406eb0c9b ("memcg: add memory.numastat api for numa statistics")
adds memory.numa_stat file for memory cgroup.  But the file permissions
are wrong.

[kamezawa@bluextal linux-2.6]$ ls -l /cgroup/memory/A/memory.numa_stat
---------- 1 root root 0 Jun  9 18:36 /cgroup/memory/A/memory.numa_stat

This patch fixes the permission as

[root@bluextal kamezawa]# ls -l /cgroup/memory/A/memory.numa_stat
-r--r--r-- 1 root root 0 Jun 10 16:49 /cgroup/memory/A/memory.numa_stat

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~mm-memorynuma_stat-fix-file-permission mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memorynuma_stat-fix-file-permission
+++ a/mm/memcontrol.c
@@ -4640,6 +4640,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "numa_stat",
 		.open = mem_control_numa_stat_open,
+		.mode = S_IRUGO,
 	},
 #endif
 };
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

