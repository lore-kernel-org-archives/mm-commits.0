From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom-introduce-oom-reaper-fix-fix.patch removed from -mm tree
Date: Mon, 11 Jan 2016 14:47:37 -0800
Message-ID: <56943109.4vWcmIZ11O+W2wf4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbcAKWri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-fix-fix.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-introduce-oom-reaper-fix-fix

document the msleep

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-fix
+++ a/mm/oom_kill.c
@@ -468,6 +468,7 @@ static void oom_reap_vmas(struct mm_stru
 {
 	int attempts = 0;
 
+	/* Retry the down_read_trylock(mmap_sem) a few times */
 	while (attempts++ < 10 && !__oom_reap_vmas(mm))
 		msleep_interruptible(100);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

