From: akpm@linux-foundation.org
Subject: + mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch added to -mm tree
Date: Wed, 25 Aug 2010 15:46:12 -0700
Message-ID: <201008252246.o7PMkC7Q020301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287Ab0HYWqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 18:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cascardo@holoscopio.com


The patch titled
     mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup
has been added to the -mm tree.  Its filename is
     mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch

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
Subject: mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

grumble

Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup include/linux/swap.h
--- a/include/linux/swap.h~mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup
+++ a/include/linux/swap.h
@@ -274,8 +274,13 @@ extern int scan_unevictable_handler(stru
 extern int scan_unevictable_register_node(struct node *node);
 extern void scan_unevictable_unregister_node(struct node *node);
 #else
-static inline int scan_unevictable_register_node(struct node *node) {return 0;}
-static inline void scan_unevictable_unregister_node(struct node *node) {}
+static inline int scan_unevictable_register_node(struct node *node)
+{
+	return 0;
+}
+static inline void scan_unevictable_unregister_node(struct node *node)
+{
+}
 #endif
 
 extern int kswapd_run(int nid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
tmio_mmc-revise-a-limit-of-the-data-size-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
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

