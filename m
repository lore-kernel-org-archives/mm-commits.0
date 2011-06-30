From: akpm@linux-foundation.org
Subject: + ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch added to -mm tree
Date: Thu, 30 Jun 2011 11:15:34 -0700
Message-ID: <201106301815.p5UIFYIb004786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab1F3SPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jun 2011 14:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, segoon@openwall.com


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-comments-fix
has been added to the -mm tree.  Its filename is
     ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch

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
Subject: ipc-introduce-shm_rmid_forced-sysctl-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix shm_rmid_forced/shm_forced_rmid confusion

- use standard comment layout

Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    6 ++++--
 ipc/shm.c                     |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments-fix include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments-fix
+++ a/include/linux/ipc_namespace.h
@@ -44,8 +44,10 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
-	/* Defines whether IPC_RMID is forced for _all_ shm segments
-	 * regardless of shmctl() */
+	/*
+	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
+	 * of shmctl()
+	 */
 	int		shm_rmid_forced;
 
 	struct notifier_block ipcns_nb;
diff -puN ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments-fix ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments-fix
+++ a/ipc/shm.c
@@ -195,7 +195,7 @@ static void shm_destroy(struct ipc_names
  *
  * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
  *
- * 2) sysctl kernel.shm_forced_rmid is set to 1.
+ * 2) sysctl kernel.shm_rmid_forced is set to 1.
  */
 static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

