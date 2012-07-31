From: akpm@linux-foundation.org
Subject: [folded] memcg-rename-config-variables-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:29:50 -0700
Message-ID: <20120731232950.2A511A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54389 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2GaX3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:29:51 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4818144obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:29:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-rename-config-variables-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-rename-config-variables-fix-fix.patch

This patch was dropped because it was folded into memcg-rename-config-variables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-rename-config-variables-fix-fix

that's everything

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt      |    2 +-
 arch/powerpc/configs/chroma_defconfig |    4 ++--
 arch/s390/defconfig                   |    2 +-
 arch/sh/configs/apsh4ad0a_defconfig   |    2 +-
 arch/sh/configs/sdk7786_defconfig     |    4 ++--
 arch/sh/configs/se7206_defconfig      |    2 +-
 arch/sh/configs/shx3_defconfig        |    2 +-
 arch/sh/configs/urquell_defconfig     |    4 ++--
 arch/tile/configs/tilegx_defconfig    |    4 ++--
 arch/tile/configs/tilepro_defconfig   |    4 ++--
 arch/um/defconfig                     |    8 ++++----
 11 files changed, 19 insertions(+), 19 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-rename-config-variables-fix-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-rename-config-variables-fix-fix
+++ a/Documentation/cgroups/memory.txt
@@ -187,7 +187,7 @@ the cgroup that brought it in -- this wi
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used.
+Exception: If CONFIG_CGROUP_CGROUP_MEMCG_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
diff -puN arch/powerpc/configs/chroma_defconfig~memcg-rename-config-variables-fix-fix arch/powerpc/configs/chroma_defconfig
--- a/arch/powerpc/configs/chroma_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/powerpc/configs/chroma_defconfig
@@ -21,8 +21,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_NAMESPACES=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/s390/defconfig~memcg-rename-config-variables-fix-fix arch/s390/defconfig
--- a/arch/s390/defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/s390/defconfig
@@ -13,7 +13,7 @@ CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
diff -puN arch/sh/configs/apsh4ad0a_defconfig~memcg-rename-config-variables-fix-fix arch/sh/configs/apsh4ad0a_defconfig
--- a/arch/sh/configs/apsh4ad0a_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/sh/configs/apsh4ad0a_defconfig
@@ -11,7 +11,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_BLK_CGROUP=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/sh/configs/sdk7786_defconfig~memcg-rename-config-variables-fix-fix arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -18,8 +18,8 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/sh/configs/se7206_defconfig~memcg-rename-config-variables-fix-fix arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/sh/configs/se7206_defconfig
@@ -11,7 +11,7 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff -puN arch/sh/configs/shx3_defconfig~memcg-rename-config-variables-fix-fix arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/sh/configs/shx3_defconfig
@@ -13,7 +13,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff -puN arch/sh/configs/urquell_defconfig~memcg-rename-config-variables-fix-fix arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/sh/configs/urquell_defconfig
@@ -15,8 +15,8 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/tile/configs/tilegx_defconfig~memcg-rename-config-variables-fix-fix arch/tile/configs/tilegx_defconfig
--- a/arch/tile/configs/tilegx_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/tile/configs/tilegx_defconfig
@@ -18,8 +18,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/tile/configs/tilepro_defconfig~memcg-rename-config-variables-fix-fix arch/tile/configs/tilepro_defconfig
--- a/arch/tile/configs/tilepro_defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/tile/configs/tilepro_defconfig
@@ -17,8 +17,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/um/defconfig~memcg-rename-config-variables-fix-fix arch/um/defconfig
--- a/arch/um/defconfig~memcg-rename-config-variables-fix-fix
+++ a/arch/um/defconfig
@@ -155,10 +155,10 @@ CONFIG_CPUSETS=y
 CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
-# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
-# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
+# CONFIG_CGROUP_MEMCG_SWAP_ENABLED is not set
+# CONFIG_CGROUP_MEMCG_KMEM is not set
 CONFIG_CGROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_CFS_BANDWIDTH is not set
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

