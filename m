From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 May 2013 12:34:18 -0700
Message-ID: <51a506ba.3ElSG19MRwdJR4Ha%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3E1TeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:34:18 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/tablet/wacom_wac.c       |   24 -----------------------
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 -----
 drivers/net/wireless/ath/ath9k/main.c  |    4 ---
 drivers/staging/nvec/nvec_kbd.c        |    5 ----
 4 files changed, 39 deletions(-)

diff -puN drivers/staging/nvec/nvec_kbd.c~linux-next-git-rejects drivers/staging/nvec/nvec_kbd.c
--- a/drivers/staging/nvec/nvec_kbd.c~linux-next-git-rejects
+++ a/drivers/staging/nvec/nvec_kbd.c
@@ -172,11 +172,6 @@ static int nvec_kbd_remove(struct platfo
 	nvec_write_async(nvec, uncnfg_wake_key_reporting, 3);
 	nvec_write_async(nvec, disable_kbd, 2);
 	nvec_unregister_notifier(nvec, &keys_dev.notifier);
-<<<<<<< HEAD
-
-	input_unregister_device(keys_dev.input);
-=======
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
diff -puN drivers/input/tablet/wacom_wac.c~linux-next-git-rejects drivers/input/tablet/wacom_wac.c
--- a/drivers/input/tablet/wacom_wac.c~linux-next-git-rejects
+++ a/drivers/input/tablet/wacom_wac.c
@@ -362,11 +362,7 @@ static int wacom_intuos_inout(struct wac
 		case 0x100804: /* Intuos4/5 13HD/24HD Art Pen */
 		case 0x140802: /* Intuos4/5 13HD/24HD Classic Pen */
 		case 0x160802: /* Cintiq 13HD Pro Pen */
-<<<<<<< HEAD
-		case 0x180802: /* DTH2242 Pen */
-=======
 		case 0x180802: /* DTH2242 Grip Pen */
->>>>>>> linux-next/akpm-base
 			wacom->tool[idx] = BTN_TOOL_PEN;
 			break;
 
@@ -404,10 +400,6 @@ static int wacom_intuos_inout(struct wac
 		case 0x10090a: /* Intuos4/5 13HD/24HD Airbrush Eraser */
 		case 0x10080c: /* Intuos4/5 13HD/24HD Art Pen Eraser */
 		case 0x16080a: /* Cintiq 13HD Pro Pen Eraser */
-<<<<<<< HEAD
-		case 0x18080a: /* DTH2242 Eraser */
-=======
->>>>>>> linux-next/akpm-base
 			wacom->tool[idx] = BTN_TOOL_RUBBER;
 			break;
 
@@ -558,14 +550,6 @@ static int wacom_intuos_irq(struct wacom
 			input_report_key(input, BTN_3, (data[6] & 0x08));
 			input_report_key(input, BTN_4, (data[6] & 0x10));
 			input_report_key(input, BTN_5, (data[6] & 0x20));
-<<<<<<< HEAD
-			if (data[6] & 0x3f) {
-				input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
-			} else {
-				input_report_abs(input, ABS_MISC, 0);
-			}
-=======
->>>>>>> linux-next/akpm-base
 		} else if (features->type == WACOM_13HD) {
 			input_report_key(input, BTN_0, (data[3] & 0x01));
 			input_report_key(input, BTN_1, (data[4] & 0x01));
@@ -576,14 +560,6 @@ static int wacom_intuos_irq(struct wacom
 			input_report_key(input, BTN_6, (data[4] & 0x20));
 			input_report_key(input, BTN_7, (data[4] & 0x40));
 			input_report_key(input, BTN_8, (data[4] & 0x80));
-<<<<<<< HEAD
-			if ((data[3] & 0x01) | data[4]) {
-				input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
-			} else {
-				input_report_abs(input, ABS_MISC, 0);
-			}
-=======
->>>>>>> linux-next/akpm-base
 		} else if (features->type == WACOM_24HD) {
 			input_report_key(input, BTN_0, (data[6] & 0x01));
 			input_report_key(input, BTN_1, (data[6] & 0x02));
diff -puN drivers/net/wireless/ath/ath9k/ath9k.h~linux-next-git-rejects drivers/net/wireless/ath/ath9k/ath9k.h
--- a/drivers/net/wireless/ath/ath9k/ath9k.h~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -251,16 +251,10 @@ struct ath_atx_tid {
 	int tidno;
 	int baw_head;   /* first un-acked tx buffer */
 	int baw_tail;   /* next unused tx buffer slot */
-<<<<<<< HEAD
-	int sched;
-	int paused;
-	u8 state;
 	bool stop_cb;
-=======
 	bool sched;
 	bool paused;
 	bool active;
->>>>>>> linux-next/akpm-base
 };
 
 struct ath_node {
diff -puN drivers/net/wireless/ath/ath9k/main.c~linux-next-git-rejects drivers/net/wireless/ath/ath9k/main.c
--- a/drivers/net/wireless/ath/ath9k/main.c~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/ath9k/main.c
@@ -1708,12 +1708,8 @@ static int ath9k_ampdu_action(struct iee
 		flush = true;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		ath9k_ps_wakeup(sc);
-<<<<<<< HEAD
-		if (ath_tx_aggr_stop(sc, sta, tid, flush))
-=======
 		ath_tx_aggr_stop(sc, sta, tid);
 		if (!flush)
->>>>>>> linux-next/akpm-base
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

