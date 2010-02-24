From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 24 Feb 2010 11:37:10 -0800
Message-ID: <201002241937.o1OJbAsv016148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757854Ab0BXThM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:37:12 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o1OJbAVb024218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2010 11:37:11 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/cpu/cache.c |    7 -------
 include/linux/blkdev.h             |    9 +++------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN arch/microblaze/kernel/cpu/cache.c~linux-next-git-rejects arch/microblaze/kernel/cpu/cache.c
--- a/arch/microblaze/kernel/cpu/cache.c~linux-next-git-rejects
+++ a/arch/microblaze/kernel/cpu/cache.c
@@ -175,11 +175,7 @@ do {									\
 	int volatile temp;						\
 	BUG_ON(end - start <= 0);					\
 									\
-<<<<<<< HEAD:arch/microblaze/kernel/cpu/cache.c
-	__asm__ __volatile__ (" 1:	" #op " %1, r0;			\
-=======
 	__asm__ __volatile__ (" 1:	" #op "	%1, r0;			\
->>>>>>> FETCH_HEAD:arch/microblaze/kernel/cpu/cache.c
 					cmpu	%0, %1, %2;		\
 					bgtid	%0, 1b;			\
 					addk	%1, %1, %3;		\
@@ -346,14 +342,11 @@ static void __invalidate_dcache_all_wb(v
 #ifdef ASM_LOOP
 	CACHE_ALL_LOOP2(cpuinfo.dcache_size, cpuinfo.dcache_line_length,
 					wdc.clear)
-<<<<<<< HEAD:arch/microblaze/kernel/cpu/cache.c
-=======
 #else
 	for (i = 0; i < cpuinfo.dcache_size;
 		 i += cpuinfo.dcache_line_length)
 			__invalidate_dcache_wb(i, 0);
 #endif
->>>>>>> FETCH_HEAD:arch/microblaze/kernel/cpu/cache.c
 }
 
 static void __invalidate_dcache_range_wb(unsigned long start,
diff -puN include/linux/blkdev.h~linux-next-git-rejects include/linux/blkdev.h
--- a/include/linux/blkdev.h~linux-next-git-rejects
+++ a/include/linux/blkdev.h
@@ -461,13 +461,10 @@ struct request_queue
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
-<<<<<<< HEAD:include/linux/blkdev.h
 #define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
-=======
-#define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
-#define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
-#define QUEUE_FLAG_NOXMERGES   18	/* No extended merges */
->>>>>>> FETCH_HEAD:include/linux/blkdev.h
+#define QUEUE_FLAG_CQ	       17	/* hardware does queuing */
+#define QUEUE_FLAG_DISCARD     18	/* supports DISCARD */
+#define QUEUE_FLAG_NOXMERGES   19	/* No extended merges */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-serial-clients-support-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

