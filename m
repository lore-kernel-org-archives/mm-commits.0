From: akpm@linux-foundation.org
Subject: [folded-merged]
 rapidio-add-rapidio-channelized-messaging-driver-fix-return-value-check-in-riocm_init.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:46:59 -0700
Message-ID: <57a106c3.XHPwl8PMz0yM498V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcHBUrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:47:00 -0400
Received: from akpm3.mtv.corp.google.com (unknown [104.132.1.73])
	by mail.linuxfoundation.org (Postfix) with ESMTPSA id 0959E78D
	for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2016 20:47:00 +0000 (UTC)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_cm: fix return value check in riocm_init()
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-channelized-messaging-driver-fix-return-value-check-in-riocm_init.patch

This patch was dropped because it was folded into rapidio-add-rapidio-channelized-messaging-driver.patch

------------------------------------------------------
From: Wei Yongjun <[weiyj.lk@gmail.com]>
Subject: rapidio/rio_cm: fix return value check in riocm_init()

In case of error, the function class_create() returns ERR_PTR() and
never returns NULL. The NULL test in the return value check should be
replaced with IS_ERR().

Link: http://lkml.kernel.org/r/1469198221-21970-1-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~rapidio-add-rapidio-channelized-messaging-driver-fix-return-value-check-in-riocm_init drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~rapidio-add-rapidio-channelized-messaging-driver-fix-return-value-check-in-riocm_init
+++ a/drivers/rapidio/rio_cm.c
@@ -2288,9 +2288,9 @@ static int __init riocm_init(void)
 
 	/* Create device class needed by udev */
 	dev_class = class_create(THIS_MODULE, DRV_NAME);
-	if (!dev_class) {
+	if (IS_ERR(dev_class)) {
 		riocm_error("Cannot create " DRV_NAME " class");
-		return -EINVAL;
+		return PTR_ERR(dev_class);
 	}
 
 	ret = alloc_chrdev_region(&dev_number, 0, 1, DRV_NAME);
_

Patches currently in -mm which might be from [weiyj.lk@gmail.com] are

ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch
ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch
ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch
ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery-master-goes-down.patch
mm-fail-prefaulting-if-page-table-allocation-fails.patch
mm-move-swap-in-anonymous-page-into-active-list.patch
fix-bitrotted-value-in-tools-testing-radix-tree-linux-gfph.patch
mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch
mm-hugetlb-fix-huge_pte_alloc-bug_on.patch
memcg-put-soft-limit-reclaim-out-of-way-if-the-excess-tree-is-empty.patch
mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch
kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch
radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch
mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch
sysv-ipc-fix-security-layer-leaking.patch
ubsan-fix-typo-in-format-string.patch
cgroup-update-cgroups-document-path.patch
maintainers-befs-add-new-maintainers.patch
proc_oom_score-remove-tasklist_lock-and-pid_alive.patch
procfs-avoid-32-bit-time_t-in-proc-stat.patch
suppress-warnings-when-compiling-fs-proc-task_mmuc-with-w=1.patch
make-compile_test-depend-on-uml.patch
memstick-dont-allocate-unused-major-for-ms_block.patch
treewide-replace-obsolete-_refok-by-__ref.patch
uapi-move-forward-declarations-of-internal-structures.patch
mailmap-add-linus-lussing.patch
include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch
task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch
dynamic_debug-only-add-header-when-used.patch
printk-do-not-include-interrupth.patch
printk-create-pr_level-functions.patch
printk-introduce-suppress_message_printing.patch
printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch
fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use.patch
ratelimit-extend-to-print-suppressed-messages-on-release.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch
get_maintainerpl-reduce-need-for-command-line-option-f.patch
lib-iommu-helper-skip-to-next-segment.patch
crc32-use-ktime_get_ns-for-measurement.patch
radix-tree-fix-comment-about-exceptional-bits.patch
firmware-consolidate-kmap-read-write-logic.patch
firmware-provide-infrastructure-to-make-fw-caching-optional.patch
firmware-support-loading-into-a-pre-allocated-buffer.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch
checkpatch-yet-another-commit-id-improvement.patch
checkpatch-dont-complain-about-bit-macro-in-uapi.patch
checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch
checkpatch-check-signoff-when-reading-stdin.patch
checkpatch-if-no-filenames-then-read-stdin.patch
binfmt_elf-fix-calculations-for-bss-padding.patch
mm-refuse-wrapped-vm_brk-requests.patch
binfmt_em86-fix-incompatible-pointer-type.patch
nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch
nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch
nilfs2-use-bit-macro.patch
nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately.patch
reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch
signal-consolidate-tstlf_restore_sigmask-code.patch
exit-quieten-greatest-stack-depth-printk.patch
cpumask-fix-code-comment.patch
kexec-return-error-number-directly.patch
arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
arm-kexec-advertise-location-of-bootable-ram.patch
kexec-dont-invoke-oom-killer-for-control-page-allocation.patch
kexec-ensure-user-memory-sizes-do-not-wrap.patch
kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch
kexec-allow-architectures-to-override-boot-mapping.patch
arm-keystone-dts-add-psci-command-definition.patch
arm-kexec-fix-kexec-for-keystone-2.patch
kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch
add-a-kexec_crash_loaded-function.patch
allow-kdump-with-crash_kexec_post_notifiers.patch
kexec-add-restriction-on-kexec_load-segment-sizes.patch
rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-change-inbound-window-size-type-to-u64-fix.patch
rapidio-modify-for-rev3-specification-changes.patch
rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch
rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch
w1-remove-need-for-ida-and-use-platform_devid_auto.patch
w1-add-helper-macro-module_w1_family.patch
w1-omap_hdq-fix-regression.patch
init-allow-blacklisting-of-module_init-functions.patch
relay-add-global-mode-support-for-buffer-only-channels.patch
ban-config_localversion_auto-with-allmodconfig.patch
config-add-android-config-fragments.patch
init-kconfig-add-clarification-for-out-of-tree-modules.patch
kcov-allow-more-fine-grained-coverage-instrumentation.patch
ipc-delete-nr_ipc_ns.patch

