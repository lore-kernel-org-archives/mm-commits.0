From: akpm@linux-foundation.org
Subject: - declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:37:33 -0800
Message-ID: <200802060737.m167bE5k032037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757278AbYBFHiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:38:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, rene.herman@gmail.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch

This patch was dropped because it was folded into declare-pnp-option-parsing-functions-as-__init.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#56: FILE: drivers/pnp/pnpacpi/rsparser.c:427:
+						struct acpi_resource_extended_irq *p)

WARNING: line over 80 characters
#78: FILE: drivers/pnp/pnpacpi/rsparser.c:466:
+						   struct acpi_resource_fixed_io *io)

WARNING: line over 80 characters
#111: FILE: drivers/pnp/pnpacpi/rsparser.c:525:
+						    struct acpi_resource_fixed_memory32 *p)

ERROR: "foo * bar" should be "foo *bar"
#144: FILE: drivers/pnp/pnpacpi/rsparser.c:692:
+						      struct pnp_dev * dev)

WARNING: line over 80 characters
#243: FILE: drivers/pnp/pnpbios/rsparser.c:374:
+static __init unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,

WARNING: line over 80 characters
#244: FILE: drivers/pnp/pnpbios/rsparser.c:375:
+								unsigned char *end,

WARNING: line over 80 characters
#245: FILE: drivers/pnp/pnpbios/rsparser.c:376:
+								struct pnp_dev *dev)

WARNING: line over 80 characters
#254: FILE: drivers/pnp/pnpbios/rsparser.c:784:
+int __init pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)

total: 1 errors, 7 warnings, 204 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |    8 ++++----
 drivers/pnp/pnpbios/rsparser.c |    9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -432,7 +432,7 @@ static __init void pnpacpi_parse_irq_opt
 }
 
 static __init void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
-						struct acpi_resource_extended_irq *p)
+					struct acpi_resource_extended_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -471,7 +471,7 @@ static __init void pnpacpi_parse_port_op
 }
 
 static __init void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
-						   struct acpi_resource_fixed_io *io)
+					struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
 
@@ -530,7 +530,7 @@ static __init void pnpacpi_parse_mem32_o
 }
 
 static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-						    struct acpi_resource_fixed_memory32 *p)
+					struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -697,7 +697,7 @@ static __init acpi_status pnpacpi_option
 }
 
 acpi_status __init pnpacpi_parse_resource_option_data(acpi_handle handle,
-						      struct pnp_dev * dev)
+						      struct pnp_dev *dev)
 {
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
diff -puN drivers/pnp/pnpbios/rsparser.c~declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -371,9 +371,9 @@ static __init void pnpbios_parse_fixed_p
 	pnp_register_port_resource(option, port);
 }
 
-static __init unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
-								unsigned char *end,
-								struct pnp_dev *dev)
+static __init unsigned char *
+pnpbios_parse_resource_option_data(unsigned char *p, unsigned char *end,
+					struct pnp_dev *dev)
 {
 	unsigned int len, tag;
 	int priority = 0;
@@ -781,7 +781,8 @@ len_err:
  * Core Parsing Functions
  */
 
-int __init pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)
+int __init pnpbios_parse_data_stream(struct pnp_dev *dev,
+					struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
remove-support-for-un-needed-_extratext-section.patch
allow-auto-destruction-of-loop-devices.patch
read_current_time-cleanups.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
kallsyms-should-prefer-non-weak-symbols.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
stopmachine-semaphore-to-mutex.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec.patch
system-timer-fix-crash-in-100hz-system-timer.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
rtc-ds1302-rtc-support.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
fbmon-cleanup-trailing-whitespaces.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
