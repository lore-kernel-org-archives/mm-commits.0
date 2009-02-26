From: akpm@linux-foundation.org
Subject: + cgroup-memcg-show-correct-file-mode.patch added to -mm tree
Date: Thu, 26 Feb 2009 13:00:31 -0800
Message-ID: <200902262100.n1QL0Vvi021877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbZBZVBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 16:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, lizf@cn.fujitsu.cn, menage@google.com


The patch titled
     cgroup/memcg: show correct file mode
has been added to the -mm tree.  Its filename is
     cgroup-memcg-show-correct-file-mode.patch

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
Subject: cgroup/memcg: show correct file mode
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Set correct permission on memcg's file.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.cn>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memcontrol.c~cgroup-memcg-show-correct-file-mode mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-memcg-show-correct-file-mode
+++ a/mm/memcontrol.c
@@ -2026,6 +2026,7 @@ static struct cftype mem_cgroup_files[] 
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.mode = 0444
 	},
 	{
 		.name = "max_usage_in_bytes",
@@ -2048,10 +2049,12 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "stat",
 		.read_map = mem_control_stat_show,
+		.mode = 0444
 	},
 	{
 		.name = "force_empty",
 		.trigger = mem_cgroup_force_empty_write,
+		.mode = 0200
 	},
 	{
 		.name = "use_hierarchy",
@@ -2071,6 +2074,7 @@ static struct cftype memsw_cgroup_files[
 		.name = "memsw.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.mode = 0444
 	},
 	{
 		.name = "memsw.max_usage_in_bytes",
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch
cgroup-memcg-show-correct-file-mode.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch

