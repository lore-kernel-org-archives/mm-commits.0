From: akpm@linux-foundation.org
Subject: + mlock-make-mlock-error-return-posixly-correct-fix.patch added to -mm tree
Date: Fri, 22 Aug 2008 16:03:51 -0700
Message-ID: <200808222317.m7MNHAMX021646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbYHVXRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 19:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     mlock-make-mlock-error-return-posixly-correct-fix
has been added to the -mm tree.  Its filename is
     mlock-make-mlock-error-return-posixly-correct-fix.patch

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
Subject: mlock-make-mlock-error-return-posixly-correct-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/mlock.c: In function 'mlock_fixup':
mm/mlock.c:468: error: implicit declaration of function '__mlock_posix_error_return'

Documentation/SubmitChecklist considered useful...

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN mm/mlock.c~mlock-make-mlock-error-return-posixly-correct-fix mm/mlock.c
--- a/mm/mlock.c~mlock-make-mlock-error-return-posixly-correct-fix
+++ a/mm/mlock.c
@@ -143,18 +143,6 @@ static void munlock_vma_page(struct page
 	}
 }
 
-/*
- * convert get_user_pages() return value to posix mlock() error
- */
-static int __mlock_posix_error_return(long retval)
-{
-	if (retval == -EFAULT)
-		retval = -ENOMEM;
-	else if (retval == -ENOMEM)
-		retval = -EAGAIN;
-	return retval;
-}
-
 /**
  * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
  * @vma:   target vma
@@ -268,6 +256,18 @@ static long __mlock_vma_pages_range(stru
 	return ret;	/* count entire vma as locked_vm */
 }
 
+/*
+ * convert get_user_pages() return value to posix mlock() error
+ */
+static int __mlock_posix_error_return(long retval)
+{
+	if (retval == -EFAULT)
+		retval = -ENOMEM;
+	else if (retval == -ENOMEM)
+		retval = -EAGAIN;
+	return retval;
+}
+
 #else /* CONFIG_UNEVICTABLE_LRU */
 
 /*
@@ -281,6 +281,12 @@ static long __mlock_vma_pages_range(stru
 		return make_pages_present(start, end);
 	return 0;
 }
+
+static inline int __mlock_posix_error_return(long retval)
+{
+	return 0;
+}
+
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
mm-show-quicklist-memory-usage-in-proc-meminfo.patch
mm-quicklist-shouldnt-be-proportional-to-number-of-cpus.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
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

