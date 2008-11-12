From: akpm@linux-foundation.org
Subject: - alsa-fix-snd_bug_on-and-friends.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:08 -0800
Message-ID: <200811122047.mACKl8nI006855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbYKLUrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: fix snd_BUG_on() and friends
has been removed from the -mm tree.  Its filename was
     alsa-fix-snd_bug_on-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alsa: fix snd_BUG_on() and friends
From: Andrew Morton <akpm@linux-foundation.org>

sound/pci/pcxhr/pcxhr_core.c: In function 'pcxhr_set_pipe_cmd_params':
sound/pci/pcxhr/pcxhr_core.c:700: warning: statement with no effect
sound/pci/pcxhr/pcxhr_core.c:706: warning: statement with no effect
sound/pci/pcxhr/pcxhr_core.c:710: warning: statement with no effect

Due to

#define snd_BUG_ON(cond)        ({ 0;})

try to fix this, and be more conventional about the empty stubs.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/sound/core.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN include/sound/core.h~alsa-fix-snd_bug_on-and-friends include/sound/core.h
--- a/include/sound/core.h~alsa-fix-snd_bug_on-and-friends
+++ a/include/sound/core.h
@@ -385,9 +385,13 @@ void snd_verbose_printd(const char *file
 
 #else /* !CONFIG_SND_DEBUG */
 
-#define snd_printd(fmt, args...)	/* nothing */
-#define snd_BUG()			/* nothing */
-#define snd_BUG_ON(cond)	({/*(void)(cond);*/ 0;})  /* always false */
+#define snd_printd(fmt, args...)	do { } while (0)
+#define snd_BUG()			do { } while (0)
+static inline int __snd_bug_on(void)
+{
+	return 0;
+}
+#define snd_BUG_ON(cond)		__snd_bug_on()  /* always false */
 
 #endif /* CONFIG_SND_DEBUG */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
remove-ratelimt.patch
doc-add-printk-formatstxt-fix.patch
kernel-kprobesc-dont-pad-kretprobe_table_locks-on-uniprocessor-builds.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
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
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
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

