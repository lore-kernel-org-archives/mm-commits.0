From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 17 Jun 2015 11:52:40 -0700
Message-ID: <5581c1f8.Ty4vLkE+KvTkFht1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbbFQSwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jun 2015 14:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_codec.c |    4 ----
 sound/pci/hda/hda_intel.c |    9 ---------
 2 files changed, 13 deletions(-)

diff -puN sound/pci/hda/hda_codec.c~linux-next-git-rejects sound/pci/hda/hda_codec.c
--- a/sound/pci/hda/hda_codec.c~linux-next-git-rejects
+++ a/sound/pci/hda/hda_codec.c
@@ -437,11 +437,7 @@ static unsigned int get_num_devices(stru
 		return 0;
 
 	parm = snd_hdac_read_parm_uncached(&codec->core, nid, AC_PAR_DEVLIST_LEN);
-<<<<<<< HEAD
-	if (parm == -1 && codec->bus->rirb_error)
-=======
 	if (parm == -1)
->>>>>>> linux-next/akpm-base
 		parm = 0;
 	return parm & AC_DEV_LIST_LEN_MASK;
 }
diff -puN sound/pci/hda/hda_intel.c~linux-next-git-rejects sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~linux-next-git-rejects
+++ a/sound/pci/hda/hda_intel.c
@@ -1981,16 +1981,11 @@ static int azx_probe_continue(struct azx
 	 * display codec needs the power and it can be released after probe.
 	 */
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
-<<<<<<< HEAD
-#ifdef CONFIG_SND_HDA_I915
-		err = hda_i915_init(hda);
-=======
 		/* HSW/BDW controllers need this power */
 		if (CONTROLLER_IN_GPU(pci))
 			hda->need_i915_power = 1;
 
 		err = snd_hdac_i915_init(bus);
->>>>>>> linux-next/akpm-base
 		if (err < 0) {
 			/* if the controller is bound only with HDMI/DP
 			 * (for HSW and BDW), we need to abort the probe;
@@ -2002,12 +1997,8 @@ static int azx_probe_continue(struct azx
 			else
 				goto skip_i915;
 		}
-<<<<<<< HEAD
-		err = hda_display_power(hda, true);
-=======
 
 		err = snd_hdac_display_power(bus, true);
->>>>>>> linux-next/akpm-base
 		if (err < 0) {
 			dev_err(chip->card->dev,
 				"Cannot turn on display power on i915\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
revert-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next.patch
reapply-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-provide-new-get_vaddr_frames-helper-fix.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

