From: akpm@linux-foundation.org
Subject: + mm-stack-based-kmap_atomic-checkpatch-fixes.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:03:39 -0700
Message-ID: <201009212303.o8LN3dOd008072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IUXEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl


The patch titled
     mm-stack-based-kmap_atomic-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-stack-based-kmap_atomic-checkpatch-fixes.patch

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
Subject: mm-stack-based-kmap_atomic-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing statements should be on next line
#323: FILE: arch/frv/mm/highmem.c:73:
+	case 0:		__kunmap_atomic_primary(4, 6);	break;

ERROR: trailing statements should be on next line
#324: FILE: arch/frv/mm/highmem.c:74:
+	case 1:		__kunmap_atomic_primary(5, 7);	break;

ERROR: trailing statements should be on next line
#325: FILE: arch/frv/mm/highmem.c:75:
+	case 2:		__kunmap_atomic_primary(6, 8);	break;

ERROR: trailing statements should be on next line
#326: FILE: arch/frv/mm/highmem.c:76:
+	case 3:		__kunmap_atomic_primary(7, 9);	break;

ERROR: trailing statements should be on next line
#327: FILE: arch/frv/mm/highmem.c:77:
+	case 4:		__kunmap_atomic_primary(8, 10);	break;

WARNING: line over 80 characters
#1069: FILE: arch/x86/mm/highmem_32.c:82:
+			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));

WARNING: line over 80 characters
#1191: FILE: arch/x86/mm/iomap_32.c:106:
+			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));

WARNING: please, no space before tabs
#1441: FILE: include/linux/highmem.h:107:
+#define kunmap_atomic(addr, args...) ^I^I^I^I\$

total: 5 errors, 3 warnings, 1289 lines checked

./patches/mm-stack-based-kmap_atomic.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/highmem.h~mm-stack-based-kmap_atomic-checkpatch-fixes include/linux/highmem.h
--- a/include/linux/highmem.h~mm-stack-based-kmap_atomic-checkpatch-fixes
+++ a/include/linux/highmem.h
@@ -104,7 +104,7 @@ static inline void __kunmap_atomic(void 
  * Prevent people trying to call kunmap_atomic() as if it were kunmap()
  * kunmap_atomic() should get the return value of kmap_atomic, not the page.
  */
-#define kunmap_atomic(addr, args...) 				\
+#define kunmap_atomic(addr, args...)				\
 do {								\
 	BUILD_BUG_ON(__same_type((addr), struct page *));	\
 	__kunmap_atomic(addr);					\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
viafb-add-interface-for-output-device-configuration.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

