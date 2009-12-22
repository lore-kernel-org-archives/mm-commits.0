From: akpm@linux-foundation.org
Subject: + mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch added to -mm tree
Date: Mon, 21 Dec 2009 16:57:35 -0800
Message-ID: <200912220057.nBM0vZXZ006865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZLVA5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch

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
Subject: mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#173: FILE: mm/memory.c:149:
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,1)
                                                                       ^

ERROR: space required after that ',' (ctx:VxO)
#174: FILE: mm/memory.c:150:
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
                                                                       ^

ERROR: space required before that '-' (ctx:OxV)
#174: FILE: mm/memory.c:150:
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
                                                                        ^

ERROR: code indent should use tabs where possible
#192: FILE: mm/memory.c:168:
+ ^I * The caller must guarantee task->mm is not invalid.$

ERROR: code indent should use tabs where possible
#193: FILE: mm/memory.c:169:
+ ^I */$

total: 5 errors, 0 warnings, 225 lines checked

./patches/mm-avoid-false-sharing-of-mm_counter.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
+++ a/mm/memory.c
@@ -146,8 +146,8 @@ static void add_mm_counter_fast(struct m
 	else
 		add_mm_counter(mm, member, val);
 }
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -165,8 +165,8 @@ unsigned long get_mm_counter(struct mm_s
 
 	/*
 	 * Don't use task->mm here...for avoiding to use task_get_mm()..
- 	 * The caller must guarantee task->mm is not invalid.
- 	 */
+	 * The caller must guarantee task->mm is not invalid.
+	 */
 	val = atomic_long_read(&mm->rss_stat.count[member]);
 	/*
 	 * counter is updated in asynchronous manner and may go to minus.
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

