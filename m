From: akpm@linux-foundation.org
Subject: [obsolete] mm-count-lowmem-rss-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 03 Feb 2010 15:22:38 -0800
Message-ID: <201002032322.o13NMc3f025701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606Ab0BCXWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm-count-lowmem-rss-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-count-lowmem-rss-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-count-lowmem-rss-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#176: FILE: mm/memory.c:157:
+	add_mm_counter_fast(mm, member,1, page)
 	                              ^

ERROR: space required after that ',' (ctx:VxO)
#178: FILE: mm/memory.c:159:
+	add_mm_counter_fast(mm, member,-1, page)
 	                              ^

ERROR: space required before that '-' (ctx:OxV)
#178: FILE: mm/memory.c:159:
+	add_mm_counter_fast(mm, member,-1, page)
 	                               ^

WARNING: line over 80 characters
#188: FILE: mm/memory.c:195:
+#define inc_mm_counter_fast(mm, member, page) inc_mm_counter_page(mm, member, page)

WARNING: line over 80 characters
#189: FILE: mm/memory.c:196:
+#define dec_mm_counter_fast(mm, member, page) dec_mm_counter_page(mm, member, page)

total: 3 errors, 2 warnings, 317 lines checked

./patches/mm-count-lowmem-rss.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-count-lowmem-rss-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-count-lowmem-rss-checkpatch-fixes
+++ a/mm/memory.c
@@ -153,10 +153,10 @@ static void add_mm_counter_fast(struct m
 		member += LOWMEM_COUNTER;
 	__add_mm_counter_fast(mm, member, val);
 }
-#define inc_mm_counter_fast(mm, member, page)\
-	add_mm_counter_fast(mm, member,1, page)
-#define dec_mm_counter_fast(mm, member, page)\
-	add_mm_counter_fast(mm, member,-1, page)
+#define inc_mm_counter_fast(mm, member, page) \
+	add_mm_counter_fast(mm, member, 1, page)
+#define dec_mm_counter_fast(mm, member, page) \
+	add_mm_counter_fast(mm, member, -1, page)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -192,9 +192,12 @@ void sync_mm_rss(struct task_struct *tas
 }
 #else
 
-#define inc_mm_counter_fast(mm, member, page) inc_mm_counter_page(mm, member, page)
-#define dec_mm_counter_fast(mm, member, page) dec_mm_counter_page(mm, member, page)
-#define __add_mm_counter_fast(mm, member, val) add_mm_counter(mm, member, val)
+#define inc_mm_counter_fast(mm, member, page) \
+	inc_mm_counter_page(mm, member, page)
+#define dec_mm_counter_fast(mm, member, page) \
+	dec_mm_counter_page(mm, member, page)
+#define __add_mm_counter_fast(mm, member, val) \
+	add_mm_counter(mm, member, val)
 
 static void check_sync_rss_stat(struct task_struct *task)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch
drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

