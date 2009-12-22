From: akpm@linux-foundation.org
Subject: + mm-count-lowmem-rss-checkpatch-fixes.patch added to -mm tree
Date: Mon, 21 Dec 2009 17:01:15 -0800
Message-ID: <200912220101.nBM11GOs006993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbZLVBBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 20:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm-count-lowmem-rss-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-count-lowmem-rss-checkpatch-fixes.patch

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
kfifo-move-struct-kfifo-in-place.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

