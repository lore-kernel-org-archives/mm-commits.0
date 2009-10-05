From: akpm@linux-foundation.org
Subject: + include-trace-events-lockdeph-fix-do_div-warning.patch added to -mm tree
Date: Mon, 05 Oct 2009 14:46:47 -0700
Message-ID: <200910052146.n95Lkmi7015547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbZJEVrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 17:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     include/trace/events/lockdep.h: fix do_div() warning
has been added to the -mm tree.  Its filename is
     include-trace-events-lockdeph-fix-do_div-warning.patch

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
Subject: include/trace/events/lockdep.h: fix do_div() warning
From: Andrew Morton <akpm@linux-foundation.org>

do_div() takes a u64.  The mips build warns:

In file included from include/trace/ftrace.h:635,
                 from include/trace/define_trace.h:61,
                 from include/trace/events/lockdep.h:96,
                 from kernel/lockdep.c:52:
include/trace/events/lockdep.h: In function `ftrace_raw_event_lock_acquired':
include/trace/events/lockdep.h:71: warning: comparison of distinct pointer types lacks a cast

from the check in include/asm-generic/div64.h:do_div().

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/lockdep.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/lockdep.h~include-trace-events-lockdeph-fix-do_div-warning include/trace/events/lockdep.h
--- a/include/trace/events/lockdep.h~include-trace-events-lockdeph-fix-do_div-warning
+++ a/include/trace/events/lockdep.h
@@ -69,7 +69,7 @@ TRACE_EVENT(lock_contended,
 );
 
 TRACE_EVENT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip, u64 waittime),
 
 	TP_ARGS(lock, ip, waittime),
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
sparc32-convert-to-asm-generic-hardirqh.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

