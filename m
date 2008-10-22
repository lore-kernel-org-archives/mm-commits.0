From: akpm@linux-foundation.org
Subject: + memcg-fix-page_cgroup-allocation-fix-2.patch added to -mm tree
Date: Wed, 22 Oct 2008 00:27:20 -0700
Message-ID: <200810220727.m9M7RKXv001881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYJVH1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 03:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg-fix-page_cgroup-allocation-fix-2
has been added to the -mm tree.  Its filename is
     memcg-fix-page_cgroup-allocation-fix-2.patch

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
Subject: memcg-fix-page_cgroup-allocation-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

init/main.c: In function 'start_kernel':
init/main.c:660: error: implicit declaration of function 'page_cgroup_init'

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN init/main.c~memcg-fix-page_cgroup-allocation-fix-2 init/main.c
diff -puN mm/memcontrol.c~memcg-fix-page_cgroup-allocation-fix-2 mm/memcontrol.c
diff -puN mm/page_cgroup.c~memcg-fix-page_cgroup-allocation-fix-2 mm/page_cgroup.c
diff -puN include/linux/page_cgroup.h~memcg-fix-page_cgroup-allocation-fix-2 include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-fix-page_cgroup-allocation-fix-2
+++ a/include/linux/page_cgroup.h
@@ -99,5 +99,10 @@ static inline struct page_cgroup *lookup
 {
 	return NULL;
 }
+
+static inline void page_cgroup_init(void)
+{
+}
+
 #endif
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-page_cgroup-allocation-fix.patch
memcg-fix-page_cgroup-allocation-fix-2.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-unbork-meminfo.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
why-does-this-keep-happening.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
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
reiser4-broke.patch
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

