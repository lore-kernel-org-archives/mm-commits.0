From: akpm@linux-foundation.org
Subject: + devpts-fix-unused-function-warning.patch added to -mm tree
Date: Tue, 21 Oct 2008 17:02:33 -0700
Message-ID: <200810220017.m9M0HDWA022408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbYJVARg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 20:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@redhat.com, sukadev@us.ibm.com


The patch titled
     devpts: fix unused function warning
has been added to the -mm tree.  Its filename is
     devpts-fix-unused-function-warning.patch

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
Subject: devpts: fix unused function warning
From: Andrew Morton <akpm@linux-foundation.org>

fs/devpts/inode.c:324: warning: 'compare_init_pts_sb' defined but not used

Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~devpts-fix-unused-function-warning fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-fix-unused-function-warning
+++ a/fs/devpts/inode.c
@@ -320,6 +320,7 @@ fail:
 	return -ENOMEM;
 }
 
+#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 static int compare_init_pts_sb(struct super_block *s, void *p)
 {
 	if (devpts_mnt)
@@ -327,7 +328,6 @@ static int compare_init_pts_sb(struct su
 	return 0;
 }
 
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 /*
  * Safely parse the mount options in @data and update @opts.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
devpts-fix-unused-function-warning.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-unbork-meminfo.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
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

