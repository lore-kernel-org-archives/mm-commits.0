From: akpm@linux-foundation.org
Subject: [folded] nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch removed from -mm tree
Date: Fri, 08 Jun 2012 14:38:29 -0700
Message-ID: <20120608213829.4877DA02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50653 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508Ab2FHVic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 17:38:32 -0400
Received: by lbbgp10 with SMTP id gp10so134867lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 14:38:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, snanda@chromium.org, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch

This patch was dropped because it was folded into nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix

fix section errors

WARNING: vmlinux.o(.text+0x13b6eb): Section mismatch in reference from the function lockup_detector_bootcpu_resume() to the function .cpuinit.text:cpu_callback()
The function lockup_detector_bootcpu_resume() references
the function __cpuinit cpu_callback().
This is often because lockup_detector_bootcpu_resume lacks a __cpuinit 
annotation or the annotation of cpu_callback is wrong.


WARNING: vmlinux.o(.text+0x13b6f5): Section mismatch in reference from the function lockup_detector_bootcpu_resume() to the variable .cpuinit.data:cpu_nfb
The function lockup_detector_bootcpu_resume() references
the variable __cpuinitdata cpu_nfb.
This is often because lockup_detector_bootcpu_resume lacks a __cpuinitdata 
annotation or the annotation of cpu_nfb is wrong.


Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix
+++ a/kernel/watchdog.c
@@ -558,7 +558,7 @@ out:
 /*
  * Create/destroy watchdog threads as CPUs come and go:
  */
-static int __cpuinit
+static int
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -593,7 +593,7 @@ cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_nfb = {
+static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

