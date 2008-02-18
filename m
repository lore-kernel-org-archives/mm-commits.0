From: akpm@linux-foundation.org
Subject: + kernel-cpusetc-make-3-functions-static.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:17:23 -0800
Message-ID: <200802181018.m1IAILk7019893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930AbYBRKTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:19:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, pj@sgi.com


The patch titled
     kernel/cpuset.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     kernel-cpusetc-make-3-functions-static.patch

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
Subject: kernel/cpuset.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- cpuset_test_cpumask()
- cpuset_change_cpumask()
- cpuset_do_move_task()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpusetc-make-3-functions-static kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpusetc-make-3-functions-static
+++ a/kernel/cpuset.c
@@ -710,7 +710,8 @@ static inline int started_after(void *p1
  * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
  * words, if its mask is not equal to its cpuset's mask).
  */
-int cpuset_test_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static int cpuset_test_cpumask(struct task_struct *tsk,
+			       struct cgroup_scanner *scan)
 {
 	return !cpus_equal(tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
@@ -727,7 +728,8 @@ int cpuset_test_cpumask(struct task_stru
  * We don't need to re-check for the cgroup/cpuset membership, since we're
  * holding cgroup_lock() at this point.
  */
-void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_change_cpumask(struct task_struct *tsk,
+				  struct cgroup_scanner *scan)
 {
 	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
 }
@@ -1648,7 +1650,8 @@ int __init cpuset_init(void)
  * Called by cgroup_scan_tasks() for each task in a cgroup.
  * Return nonzero to stop the walk through the tasks.
  */
-void cpuset_do_move_task(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_do_move_task(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
 {
 	struct cpuset_hotplug_scanner *chsp;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch
gfs2-ops_filec-should-include-ops_inodeh.patch
git-kbuild.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
make-ocfs2_downconvert_thread-static.patch
ocfs-make-dlm_do_assert_master-static.patch
if-0-pci_cleanup_aer_correct_error_status.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
make-lpfc_disable_node-static.patch
if-0-ses_match_host.patch
scsi_transport_iscsic-make-2-functions-static.patch
remove-ps2esdi.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ipwireless-remove-dead-code.patch
git-xtensa.patch
sparc-fix-build.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-printk_recursion_bug_msg-static.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-block_devc-remove-if-0ed-code.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
make-struct-def_blk_aops-static.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
