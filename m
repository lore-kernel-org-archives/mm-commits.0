From: akpm@linux-foundation.org
Subject: - detect-atomic-counter-underflows.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:17 -0700
Message-ID: <200810241940.m9OJeHUU000867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbYJXTkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     detect atomic counter underflows
has been removed from the -mm tree.  Its filename was
     detect-atomic-counter-underflows.patch

This patch was dropped because I got tired of chasing files all around the tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: detect atomic counter underflows
From: Ingo Molnar <mingo@elte.hu>

The patch below will detect atomic counter underflows.  This has been
test-driven in the -RT patchset for some time.  qdisc_destroy() triggered
it sometimes (in a seemingly nonfatal way, during device shutdown) - with
DaveM suggesting that it is most likely a bug in the networking code.  So
it would be nice to have this in -mm for some time to validate all atomic
counters on a broader base.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/atomic_32.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/asm-x86/atomic_32.h~detect-atomic-counter-underflows include/asm-x86/atomic_32.h
--- a/include/asm-x86/atomic_32.h~detect-atomic-counter-underflows
+++ a/include/asm-x86/atomic_32.h
@@ -113,6 +113,11 @@ static inline int atomic_dec_and_test(at
 {
 	unsigned char c;
 
+	if (!atomic_read(v)) {
+		printk("BUG: atomic counter underflow at:\n");
+		dump_stack();
+	}
+
 	asm volatile(LOCK_PREFIX "decl %0; sete %1"
 		     : "+m" (v->counter), "=qm" (c)
 		     : : "memory");
_

Patches currently in -mm which might be from mingo@elte.hu are

linux-next.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
kvmclockc-fix-section-mismatch-warning.patch
mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
likely-profiling-disable-ftrace.patch

