From: akpm@linux-foundation.org
Subject: + slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch added to -mm tree
Date: Mon, 24 Mar 2008 13:13:20 -0700
Message-ID: <200803242013.m2OKDKQN023402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbYCXUOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 16:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi


The patch titled
     slab: add a flag to prevent debug_free checks on a kmem_cache
has been added to the -mm tree.  Its filename is
     slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch

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
Subject: slab: add a flag to prevent debug_free checks on a kmem_cache
From: Thomas Gleixner <tglx@linutronix.de>

This is a preperatory patch for the debugobjects infrastructure.  The flag
prevents debug_free checks on kmem_caches.  This is necessary to avoid
resursive calls into a debug mechanism which uses a kmem_cache itself.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/slab.h~slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache include/linux/slab.h
--- a/include/linux/slab.h~slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache
+++ a/include/linux/slab.h
@@ -29,6 +29,13 @@
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
+/* Flag to prevent checks on free */
+#ifdef CONFIG_DEBUG_OBJECTS
+# define SLAB_DEBUG_OBJECTS	0x00400000UL
+#else
+# define SLAB_DEBUG_OBJECTS	0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-x86.patch
add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
x86_64-do-not-reserve-ramdisk-two-times.patch
x86-handle_vm86_trap-cleanup.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
git-kgdb-light.patch
git-acpi-fixup.patch
git-hrt.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
fix-typo-in-tick-broadcastc.patch
git-kvm.patch
mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch
git-s390.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-sched-schedc-needs-tickh.patch
git-semaphore-git-rejects.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mm-move-cache_line_size-to-linux-cacheh.patch
proper-extern-for-late_time_init.patch
x86-configurable-dmi-scanning-code.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
asm-futexh-should-include-linux-uaccessh.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

