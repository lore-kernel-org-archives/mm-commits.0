From: akpm@linux-foundation.org
Subject: + percpu-use-new-macros-for-x86-percpu-readmostly-section.patch added to -mm tree
Date: Thu, 09 Dec 2010 14:30:35 -0800
Message-ID: <201012092230.oB9MUZo7010913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab0LIWcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 17:32:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, eric.dumazet@gmail.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org


The patch titled
     percpu: use new macros for x86 percpu readmostly section
has been added to the -mm tree.  Its filename is
     percpu-use-new-macros-for-x86-percpu-readmostly-section.patch

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
Subject: percpu: use new macros for x86 percpu readmostly section
From: Shaohua Li <shaohua.li@intel.com>

Use the new macros to correctly align the percpu readmostly data.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/vmlinux.lds.S~percpu-use-new-macros-for-x86-percpu-readmostly-section arch/x86/kernel/vmlinux.lds.S
--- a/arch/x86/kernel/vmlinux.lds.S~percpu-use-new-macros-for-x86-percpu-readmostly-section
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -230,7 +230,7 @@ SECTIONS
 	 * output PHDR, so the next output section - .init.text - should
 	 * start another segment - init.
 	 */
-	PERCPU_VADDR(0, :percpu)
+	PERCPU_VADDR_CACHEALIGNED(0, :percpu, INTERNODE_CACHE_BYTES)
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)
@@ -305,7 +305,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU_CACHEALIGNED(THREAD_SIZE, INTERNODE_CACHE_BYTES)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-make-kswapd-use-a-correct-order.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch
percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch
percpu-use-new-macros-for-x86-percpu-readmostly-section.patch

