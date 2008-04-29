From: akpm@linux-foundation.org
Subject: - reapply-sched-cpuset-customize-sched-domains-core-bits.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:38:14 -0700
Message-ID: <200804290538.m3T5cEG4003336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYD2FjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com, xemul@o


The patch titled
     reapply "sched, cpuset: customize sched domains, core" bits
has been removed from the -mm tree.  Its filename was
     reapply-sched-cpuset-customize-sched-domains-core-bits.patch

This patch was dropped because it was folded into cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reapply "sched, cpuset: customize sched domains, core" bits
From: Andrew Morton <akpm@linux-foundation.org>

Attempt to reapply the 1d3504fcf5606579d60b649d19f44b3871c1ddae and convert
them to the new regime.

Please review carefully.

Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   51 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff -puN kernel/cpuset.c~reapply-sched-cpuset-customize-sched-domains-core-bits kernel/cpuset.c
--- a/kernel/cpuset.c~reapply-sched-cpuset-customize-sched-domains-core-bits
+++ a/kernel/cpuset.c
@@ -98,6 +98,9 @@ struct cpuset {
 	/* partition number for rebuild_sched_domains() */
 	int pn;
 
+	/* for custom sched domain */
+	int relax_domain_level;
+
 	/* used for walking a cpuset heirarchy */
 	struct list_head stack_list;
 };
@@ -126,6 +129,7 @@ typedef enum {
 	CS_MEM_EXCLUSIVE,
 	CS_MEMORY_MIGRATE,
 	CS_SCHED_LOAD_BALANCE,
+	CS_SCHED_RELAX_DOMAIN_LEVEL,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
@@ -146,6 +150,11 @@ static inline int is_sched_load_balance(
 	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 }
 
+static inline int is_sched_relax_domain_level(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_RELAX_DOMAIN_LEVEL, &cs->flags);
+}
+
 static inline int is_memory_migrate(const struct cpuset *cs)
 {
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
@@ -478,6 +487,16 @@ static int cpusets_overlap(struct cpuset
 	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
 }
 
+static void
+update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
+{
+	if (!dattr)
+		return;
+	if (dattr->relax_domain_level < c->relax_domain_level)
+		dattr->relax_domain_level = c->relax_domain_level;
+	return;
+}
+
 /*
  * rebuild_sched_domains()
  *
@@ -553,12 +572,14 @@ static void rebuild_sched_domains(void)
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
+	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
 	q = NULL;
 	csa = NULL;
 	doms = NULL;
+	dattr = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
@@ -566,6 +587,11 @@ static void rebuild_sched_domains(void)
 		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 		if (!doms)
 			goto rebuild;
+		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
+		if (dattr) {
+			*dattr = SD_ATTR_INIT;
+			update_domain_attr(dattr, &top_cpuset);
+		}
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
 	}
@@ -622,6 +648,7 @@ restart:
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms)
 		goto rebuild;
+	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
@@ -644,12 +671,15 @@ restart:
 			}
 
 			cpus_clear(*dp);
+			if (dattr)
+				*(dattr + nslot) = SD_ATTR_INIT;
 			for (j = i; j < csn; j++) {
 				struct cpuset *b = csa[j];
 
 				if (apn == b->pn) {
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
+					update_domain_attr(dattr, b);
 				}
 			}
 			nslot++;
@@ -660,7 +690,7 @@ restart:
 rebuild:
 	/* Have scheduler rebuild sched domains */
 	get_online_cpus();
-	partition_sched_domains(ndoms, doms);
+	partition_sched_domains(ndoms, doms, dattr);
 	put_online_cpus();
 
 done:
@@ -668,6 +698,7 @@ done:
 		kfifo_free(q);
 	kfree(csa);
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
+	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
 static inline int started_after_time(struct task_struct *t1,
@@ -1187,6 +1218,7 @@ typedef enum {
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_SCHED_LOAD_BALANCE,
+	FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
@@ -1269,6 +1301,9 @@ static int cpuset_write_u64(struct cgrou
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		retval = update_flag(CS_SCHED_RELAX_DOMAIN_LEVEL, cs, val);
+		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
@@ -1375,6 +1410,8 @@ static u64 cpuset_read_u64(struct cgroup
 		return is_mem_exclusive(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		return is_sched_relax_domain_level(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
@@ -1431,6 +1468,13 @@ static struct cftype cft_sched_load_bala
 	.private = FILE_SCHED_LOAD_BALANCE,
 };
 
+static struct cftype cft_sched_relax_domain_level = {
+	.name = "sched_relax_domain_level",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
+};
+
 static struct cftype cft_memory_migrate = {
 	.name = "memory_migrate",
 	.read_u64 = cpuset_read_u64,
@@ -1482,6 +1526,9 @@ static int cpuset_populate(struct cgroup
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss,
+					&cft_sched_relax_domain_level)) < 0)
+		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
@@ -1566,6 +1613,7 @@ static struct cgroup_subsys_state *cpuse
 	nodes_clear(cs->mems_allowed);
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
+	cs->relax_domain_level = -1;
 
 	cs->parent = parent;
 	number_of_cpusets++;
@@ -1638,6 +1686,7 @@ int __init cpuset_init(void)
 	fmeter_init(&top_cpuset.fmeter);
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
+	top_cpuset.relax_domain_level = -1;
 
 	err = register_filesystem(&cpuset_fs_type);
 	if (err < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

