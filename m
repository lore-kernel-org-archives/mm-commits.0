From: akpm@linux-foundation.org
Subject: + ia64-tree-wide-misc-__cpuinitdata-init-exit.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:06:11 -0700
Message-ID: <200708232306.l7NN6CIW031665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762108AbXHWXGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, tony.luck@intel.com


The patch titled
     ia64 tree-wide: Misc __cpu{initdata, init, exit} annotations
has been added to the -mm tree.  Its filename is
     ia64-tree-wide-misc-__cpuinitdata-init-exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64 tree-wide: Misc __cpu{initdata, init, exit} annotations
From: Satyam Sharma <satyam@infradead.org>

* palinfo.c:

palinfo_cpu_notifier is a CPU hotplug notifier_block, and can be
marked __cpuinitdata, and the callback function palinfo_cpu_callback()
itself can be marked __cpuinit. create_palinfo_proc_entries() is only
called from __cpuinit callback or general __init code, therefore a
candidate for __cpuinit itself. remove_palinfo_proc_entries() is only
called from __cpuinit callback or general __exit code, therefore a
candidate for __cpuexit.

* salinfo.c:

The CPU hotplug notifier_block can be __cpuinitdata. The callback
salinfo_cpu_callback() is incorrectly marked __devinit -- it must
be __cpuinit instead.

* topology.c:

cache_sysfs_init() is only called at device_initcall() time so marking
it as __cpuinit is wrong and wasteful. It should be unconditionally
__init. Also cleanup reference to hotplug notifier callback function
from this function and replace with cache_add_dev(), which could also
enable us to use other tricks to replace __cpuinit{data} annotations,
as recently discussed on this list.

cache_shared_cpu_map_setup() is only ever called from __cpuinit-marked
functions hence both its definitions (SMP or !SMP) are candidates for
__cpuinit itself. Also all_cpu_cache_info can be __cpuinitdata because
only referenced from __cpuinit code.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/palinfo.c  |    8 ++++----
 arch/ia64/kernel/salinfo.c  |    4 ++--
 arch/ia64/kernel/topology.c |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/ia64/kernel/palinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit arch/ia64/kernel/palinfo.c
--- a/arch/ia64/kernel/palinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit
+++ a/arch/ia64/kernel/palinfo.c
@@ -907,7 +907,7 @@ palinfo_read_entry(char *page, char **st
 	return len;
 }
 
-static void
+static void __cpuinit
 create_palinfo_proc_entries(unsigned int cpu)
 {
 #	define CPUSTR	"cpu%d"
@@ -947,7 +947,7 @@ create_palinfo_proc_entries(unsigned int
 	}
 }
 
-static void
+static void __cpuexit
 remove_palinfo_proc_entries(unsigned int hcpu)
 {
 	int j;
@@ -968,7 +968,7 @@ remove_palinfo_proc_entries(unsigned int
 	}
 }
 
-static int palinfo_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit palinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int hotcpu = (unsigned long)hcpu;
@@ -986,7 +986,7 @@ static int palinfo_cpu_callback(struct n
 	return NOTIFY_OK;
 }
 
-static struct notifier_block palinfo_cpu_notifier =
+static struct notifier_block palinfo_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = palinfo_cpu_callback,
 	.priority = 0,
diff -puN arch/ia64/kernel/salinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit
+++ a/arch/ia64/kernel/salinfo.c
@@ -574,7 +574,7 @@ static const struct file_operations sali
 	.write   = salinfo_log_write,
 };
 
-static int __devinit
+static int __cpuinit
 salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int i, cpu = (unsigned long)hcpu;
@@ -615,7 +615,7 @@ salinfo_cpu_callback(struct notifier_blo
 	return NOTIFY_OK;
 }
 
-static struct notifier_block salinfo_cpu_notifier =
+static struct notifier_block salinfo_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = salinfo_cpu_callback,
 	.priority = 0,
diff -puN arch/ia64/kernel/topology.c~ia64-tree-wide-misc-__cpuinitdata-init-exit arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c~ia64-tree-wide-misc-__cpuinitdata-init-exit
+++ a/arch/ia64/kernel/topology.c
@@ -118,11 +118,11 @@ struct cpu_cache_info {
 	struct kobject kobj;
 };
 
-static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS];
+static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS] __cpuinitdata;
 #define LEAF_KOBJECT_PTR(x,y)    (&all_cpu_cache_info[x].cache_leaves[y])
 
 #ifdef CONFIG_SMP
-static void cache_shared_cpu_map_setup( unsigned int cpu,
+static void __cpuinit cache_shared_cpu_map_setup( unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	pal_cache_shared_info_t	csi;
@@ -157,7 +157,7 @@ static void cache_shared_cpu_map_setup( 
 				&csi) == PAL_STATUS_SUCCESS);
 }
 #else
-static void cache_shared_cpu_map_setup(unsigned int cpu,
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	cpu_set(cpu, this_leaf->shared_cpu_map);
@@ -428,13 +428,13 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cache_cpu_callback
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
 	for_each_online_cpu(i) {
-		cache_cpu_callback(&cache_cpu_notifier, CPU_ONLINE,
-				(void *)(long)i);
+		struct sys_device *sys_dev = get_cpu_sysdev((unsigned int)i);
+		cache_add_dev(sys_dev);
 	}
 
 	register_hotcpu_notifier(&cache_cpu_notifier);
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch
s390-appldata_base-remove-module_exit-function-and-modular.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
i386-cpuid-misc-cpuinit-annotations.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
