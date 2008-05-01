From: akpm@linux-foundation.org
Subject: - slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:51 -0700
Message-ID: <200805010932.m419Wp8N031017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbYEAJdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab: add a flag to prevent debug_free checks on a kmem_cache
has been removed from the -mm tree.  Its filename was
     slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64-ia64.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
git-x86.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-kvm.patch
rename-div64_64-to-div64_u64-kvm.patch
git-sched.patch
aes-x86_64-asm-implementation-optimization.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

