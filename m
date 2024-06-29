Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C57B134C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628275; cv=none; b=ict72Lpj3MDeZL7L5hN5r4Ktq7RARORU68O5xOa0K/A1JQ7HZcYXakvM1S1HAi/LRXiVGFiOlp/6eyeNvZZ9ld2/359yn4cgaXIzp758wndAV6NQ2gvaRqN6wvl++kp15eyShReQBxlinRt7jGyLv9zPmlytlwFNfh7VILgBVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628275; c=relaxed/simple;
	bh=qy/FPpRgNYU/4ir6k7F/BtTtO3IoCGEigX+3Uq8oadY=;
	h=Date:To:From:Subject:Message-Id; b=Z03mRUyfflQM0iO0XEdP9EWdvcr1hRb+FEDggE9j5pzFvZi8wKnmJAG55MwiMaBYT++Gx9aHFfDGFAgL/NL32QsTS4+v+ANXRzEJCLP67ey7aK6b9BVapZTW+0T9aYrFhfxMyT5v3KRj4gmvgrrbapivI/qhzL6mWwdPlmVegKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPjWrHjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPjWrHjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D0C116B1;
	Sat, 29 Jun 2024 02:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628275;
	bh=qy/FPpRgNYU/4ir6k7F/BtTtO3IoCGEigX+3Uq8oadY=;
	h=Date:To:From:Subject:From;
	b=LPjWrHjSj4vnFaILi1HvFd4iCXLOen0mUVBMYU/AUG62YS+fQr3VE7onp+g/ar2eL
	 aCeLnXUGrkb7V1PRAwmWQx4WcrAL6IHG7HlljzK36X8DHFrWfYOB+h8M4qmERe0Pk5
	 UciCJ2C4WGjWVIw/VCFe9Nqk2wnpK5e+qRQtagIU=
Date: Fri, 28 Jun 2024 19:31:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch removed from -mm tree
Message-Id: <20240629023115.551D0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/irqflags: do not instrument arch_local_irq_*() with KMSAN
has been removed from the -mm tree.  Its filename was
     s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/irqflags: do not instrument arch_local_irq_*() with KMSAN
Date: Fri, 21 Jun 2024 13:35:14 +0200

Lockdep generates the following false positives with KMSAN on s390x:

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

Link: https://lkml.kernel.org/r/20240621113706.315500-31-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/irqflags.h |   17 ++++++++++++++---
 drivers/s390/char/sclp.c         |    2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/irqflags.h~s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan
+++ a/arch/s390/include/asm/irqflags.h
@@ -37,12 +37,18 @@ static __always_inline void __arch_local
 	asm volatile("ssm   %0" : : "Q" (flags) : "memory");
 }
 
-static __always_inline unsigned long arch_local_save_flags(void)
+#ifdef CONFIG_KMSAN
+#define arch_local_irq_attributes noinline notrace __no_sanitize_memory __maybe_unused
+#else
+#define arch_local_irq_attributes __always_inline
+#endif
+
+static arch_local_irq_attributes unsigned long arch_local_save_flags(void)
 {
 	return __arch_local_irq_stnsm(0xff);
 }
 
-static __always_inline unsigned long arch_local_irq_save(void)
+static arch_local_irq_attributes unsigned long arch_local_irq_save(void)
 {
 	return __arch_local_irq_stnsm(0xfc);
 }
@@ -52,7 +58,12 @@ static __always_inline void arch_local_i
 	arch_local_irq_save();
 }
 
-static __always_inline void arch_local_irq_enable(void)
+static arch_local_irq_attributes void arch_local_irq_enable_external(void)
+{
+	__arch_local_irq_stosm(0x01);
+}
+
+static arch_local_irq_attributes void arch_local_irq_enable(void)
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


