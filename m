From: akpm@linux-foundation.org
Subject: + remove-ratelimt.patch added to -mm tree
Date: Fri, 07 Nov 2008 10:46:52 -0800
Message-ID: <200811071846.mA7Ikqea018810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbYKGSqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 13:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hidave.darkstar@gmail.com


The patch titled
     remove ratelimt()
has been added to the -mm tree.  Its filename is
     remove-ratelimt.patch

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
Subject: remove ratelimt()
From: Andrew Morton <akpm@linux-foundation.org>

It mistakenly assumes that a static local in an inlined function is a
kernel-wide singleton.  It also has no callers, so let's remove it.

Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |    7 -------
 ratelimit.c               |    0 
 2 files changed, 7 deletions(-)

diff -puN include/linux/ratelimit.h~remove-ratelimt include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~remove-ratelimt
+++ a/include/linux/ratelimit.h
@@ -17,11 +17,4 @@ struct ratelimit_state {
 		struct ratelimit_state name = {interval, burst,}
 
 extern int __ratelimit(struct ratelimit_state *rs);
-
-static inline int ratelimit(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
-					DEFAULT_RATELIMIT_BURST);
-	return __ratelimit(&rs);
-}
 #endif
diff -puN lib/ratelimit.c~remove-ratelimt lib/ratelimit.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return.patch
maintainers-make-ioat-easier-to-find.patch
binfmtsh-include-listh-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
remove-ratelimt.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
alsa-fix-snd_bug_on-and-friends.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

