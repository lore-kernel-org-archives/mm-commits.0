From: akpm@linux-foundation.org
Subject: + reapply-sched-cpuset-customize-sched-domains-core-bits.patch added to -mm tree
Date: Sat, 26 Apr 2008 08:37:34 -0700
Message-ID: <200804261537.m3QFbYOo028608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbYDZPiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 11:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     reapply "sched, cpuset: customize sched domains, core" bits
has been added to the -mm tree.  Its filename is
     reapply-sched-cpuset-customize-sched-domains-core-bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
hotplug-memory-make-online_page-common-fix.patch
disable-the-memory-controller-by-default-v3-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
x86-ptrace-pebs-support-warning-fix.patch
git-agpgart.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
git-hrt.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
add-rcu_assign_index-if-ever-needed.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs-vs-git-kvm.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
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

