Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD3A6DD03
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1qfJH/um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B349C433C9;
	Thu, 14 Dec 2023 22:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702593838;
	bh=t3/51EBjuLR7+RajxQoLwxegyOMA1r2BzZLrPdumk6E=;
	h=Date:To:From:Subject:From;
	b=1qfJH/umb2rvPDVP7ES0wSR3yUbcOvWaZRk0/b2969EjUfh0cBMdhlIwmllTbqsIh
	 ULTDj4lyDvaUwcoCHFBy4WEMw+OkYK7ABSSZZWFOo1QSPEppGsKOWfy+rtCyha2I/9
	 eX9ZbmOqH8xai8r2M8rzbXEDwSAfkWwTYkkIIpbc=
Date: Thu, 14 Dec 2023 14:43:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch added to mm-unstable branch
Message-Id: <20231214224358.1B349C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/irqflags: ddo not instrument arch_local_irq_*() with KMSAN
has been added to the -mm mm-unstable branch.  Its filename is
     s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/irqflags: ddo not instrument arch_local_irq_*() with KMSAN
Date: Thu, 14 Dec 2023 00:24:47 +0100

KMSAN generates the following false positives on s390x:

[    6.063666] DEBUG_LOCKS_WARN_ON(lockdep_hardirqs_enabled())
[         ...]
[    6.577050] Call Trace:
[    6.619637]  [<000000000690d2de>] check_flags+0x1fe/0x210
[    6.665411] ([<000000000690d2da>] check_flags+0x1fa/0x210)
[    6.707478]  [<00000000006cec1a>] lock_acquire+0x2ca/0xce0
[    6.749959]  [<00000000069820ea>] _raw_spin_lock_irqsave+0xea/0x190
[    6.794912]  [<00000000041fc988>] __stack_depot_save+0x218/0x5b0
[    6.838420]  [<000000000197affe>] __msan_poison_alloca+0xfe/0x1a0
[    6.882985]  [<0000000007c5827c>] start_kernel+0x70c/0xd50
[    6.927454]  [<0000000000100036>] startup_continue+0x36/0x40

Between trace_hardirqs_on() and `stosm __mask, 3` lockdep thinks that
interrupts are on, but on the CPU they are still off.  KMSAN
instrumentation takes spinlocks, giving lockdep a chance to see and
complain about this discrepancy.

KMSAN instrumentation is inserted in order to poison the __mask variable. 
Disable instrumentation in the respective functions.  They are very small
and it's easy to see that no important metadata updates are lost because
of this.

Link: https://lkml.kernel.org/r/20231213233605.661251-28-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/irqflags.h |   18 +++++++++++++++---
 drivers/s390/char/sclp.c         |    2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/irqflags.h~s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan
+++ a/arch/s390/include/asm/irqflags.h
@@ -37,12 +37,19 @@ static __always_inline void __arch_local
 	asm volatile("ssm   %0" : : "Q" (flags) : "memory");
 }
 
-static __always_inline unsigned long arch_local_save_flags(void)
+#ifdef CONFIG_KMSAN
+#define ARCH_LOCAL_IRQ_ATTRIBUTES \
+	noinline notrace __no_sanitize_memory __maybe_unused
+#else
+#define ARCH_LOCAL_IRQ_ATTRIBUTES __always_inline
+#endif
+
+static ARCH_LOCAL_IRQ_ATTRIBUTES unsigned long arch_local_save_flags(void)
 {
 	return __arch_local_irq_stnsm(0xff);
 }
 
-static __always_inline unsigned long arch_local_irq_save(void)
+static ARCH_LOCAL_IRQ_ATTRIBUTES unsigned long arch_local_irq_save(void)
 {
 	return __arch_local_irq_stnsm(0xfc);
 }
@@ -52,7 +59,12 @@ static __always_inline void arch_local_i
 	arch_local_irq_save();
 }
 
-static __always_inline void arch_local_irq_enable(void)
+static ARCH_LOCAL_IRQ_ATTRIBUTES void arch_local_irq_enable_external(void)
+{
+	__arch_local_irq_stosm(0x01);
+}
+
+static ARCH_LOCAL_IRQ_ATTRIBUTES void arch_local_irq_enable(void)
 {
 	__arch_local_irq_stosm(0x03);
 }
--- a/drivers/s390/char/sclp.c~s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan
+++ a/drivers/s390/char/sclp.c
@@ -736,7 +736,7 @@ sclp_sync_wait(void)
 	cr0_sync.val = cr0.val & ~CR0_IRQ_SUBCLASS_MASK;
 	cr0_sync.val |= 1UL << (63 - 54);
 	local_ctl_load(0, &cr0_sync);
-	__arch_local_irq_stosm(0x01);
+	arch_local_irq_enable_external();
 	/* Loop until driver state indicates finished request */
 	while (sclp_running_state != sclp_running_state_idle) {
 		/* Check for expired request timer */
_

Patches currently in -mm which might be from iii@linux.ibm.com are

ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch
kmsan-make-the-tests-compatible-with-kmsanpanic=1.patch
kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled.patch
kmsan-increase-the-maximum-store-size-to-4096.patch
kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces.patch
kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces.patch
kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush.patch
kmsan-remove-an-x86-specific-include-from-kmsanh.patch
kmsan-expose-kmsan_get_metadata.patch
kmsan-export-panic_on_kmsan.patch
kmsan-allow-disabling-kmsan-checks-for-the-current-task.patch
kmsan-support-slab_poison.patch
kmsan-use-align_down-in-kmsan_get_metadata.patch
mm-slub-let-kmsan-access-metadata.patch
mm-slub-unpoison-the-memchr_inv-return-value.patch
mm-kfence-disable-kmsan-when-checking-the-canary.patch
lib-zlib-unpoison-dfltcc-output-buffers.patch
kmsan-accept-ranges-starting-with-0-on-s390.patch
s390-turn-off-kmsan-for-boot-vdso-and-purgatory.patch
s390-use-a-larger-stack-for-kmsan.patch
s390-boot-add-the-kmsan-runtime-stub.patch
s390-checksum-add-a-kmsan-check.patch
s390-cpacf-unpoison-the-results-of-cpacf_trng.patch
s390-cpumf-unpoison-stcctm-output-buffer.patch
s390-diag-unpoison-diag224-output-buffer.patch
s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler.patch
s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch
s390-mm-define-kmsan-metadata-for-vmalloc-and-modules.patch
s390-string-add-kmsan-support.patch
s390-traps-unpoison-the-kernel_stack_overflows-pt_regs.patch
s390-uaccess-add-kmsan-support-to-put_user-and-get_user.patch
s390-unwind-disable-kmsan-checks.patch
s390-implement-the-architecture-specific-kmsan-functions.patch
kmsan-enable-on-s390.patch

