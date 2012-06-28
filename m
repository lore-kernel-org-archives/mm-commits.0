From: akpm@linux-foundation.org
Subject: + memcg-rename-config-variables-fix-fix.patch added to -mm tree
Date: Thu, 28 Jun 2012 13:08:42 -0700
Message-ID: <20120628200843.32D6FA0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50217 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2F1UIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 16:08:45 -0400
Received: by fat25 with SMTP id 25so145976fat.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 13:08:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: memcg-rename-config-variables-fix-fix
has been added to the -mm tree.  Its filename is
     memcg-rename-config-variables-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: memcg-rename-config-variables-fix-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

