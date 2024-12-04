Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DEA192D7E
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349580; cv=none; b=mDaAjlS0M1HLzZ4inDWZ1vMA/aFQCHy+B30776KFF1zURj4OeA8t9KIw+rR8jWJzqDHNGgNw8EIsg+Z+OyPt3sEXaFjjjW5ljj2FwBc4bBCyvGRuRO38Lacvi3gKcXbd1OA/uNNWHCt3skpdNjWlWj476+ldgxORC8J/qoJLXyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349580; c=relaxed/simple;
	bh=yFwzyDPpz/U/cObfZmjBzAuQwNp95uc7L2W9K8KbxC0=;
	h=Date:To:From:Subject:Message-Id; b=GGIrMHjxDhhF38t29+Wg1jP1S3Tevdl63u6J8EOeE5XgiuOZ6L/bkq5fCsHA98xX6x5bSRaCiMSnPaRfdQuWx7qENliiiZ0CFYUEir6HMEZYRncuHq9HszjjWCM6NaRGDanh7nlgwzCQSxLbQWMID8mnd8NJd0L6QVsUemtAYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XjM3yaLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XjM3yaLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB364C4CECD;
	Wed,  4 Dec 2024 21:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733349580;
	bh=yFwzyDPpz/U/cObfZmjBzAuQwNp95uc7L2W9K8KbxC0=;
	h=Date:To:From:Subject:From;
	b=XjM3yaLPL78bfABD6UyTnaadeMLSr0oxblPf0xkcZnyh9FAzr2lrNdfVyK/r/G9v1
	 jwvYFSHzOnLcqmwIoHtmNrrPvp7CGaGjksAEFxF6v1Sqr4TWIX61Mvo4SnhZfL2dZN
	 WSaIvlE1+S4VN8QGknPgrOxikbcCWo+xR7iDSfPA=
Date: Wed, 04 Dec 2024 13:59:39 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,takakura@valinux.co.jp,sourabhjain@linux.ibm.com,songshuaishuai@tinylab.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,linux@armlinux.org.uk,jonnyc@amazon.com,hbathini@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,adityag@linux.ibm.com,farbere@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch added to mm-nonmm-unstable branch
Message-Id: <20241204215939.EB364C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: prevent redundant IRQ masking by checking state before shutdown
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Eliav Farber <farbere@amazon.com>
Subject: kexec: prevent redundant IRQ masking by checking state before shutdown
Date: Wed, 4 Dec 2024 14:20:03 +0000

During machine kexec, the function machine_kexec_mask_interrupts() is
responsible for disabling or masking all interrupts.  While the
irq_disable hook ensures that an already-disabled IRQ is not disabled
again, the current implementation unconditionally invokes the irq_mask()
function for every interrupt descriptor, even when the interrupt is
already masked.

A specific issue was observed in the crash kernel flow after unbinding a
device (prior to kexec) that used a GPIO as an IRQ source.  The warning
was triggered by the gpiochip_disable_irq() function, which attempted to
clear the FLAG_IRQ_IS_ENABLED flag when FLAG_USED_AS_IRQ was not set:

```
void gpiochip_disable_irq(struct gpio_chip *gc, unsigned int offset)
{
	struct gpio_desc *desc = gpiochip_get_desc(gc, offset);

	if (!IS_ERR(desc) &&
	    !WARN_ON(!test_bit(FLAG_USED_AS_IRQ, &desc->flags)))
		clear_bit(FLAG_IRQ_IS_ENABLED, &desc->flags);
}
```

This issue surfaced after commit a8173820f441 ("gpio: gpiolib: Allow GPIO
IRQs to lazy disable") introduced lazy disablement for GPIO IRQs.  It
replaced disable/enable hooks with mask/unmask hooks.  Unlike the disable
hook, the mask hook doesn't handle already-masked IRQs.

When a GPIO-IRQ driver is unbound, the IRQ is released, triggering
__irq_disable() and irq_state_set_masked().  A subsequent call to
machine_kexec_mask_interrupts() re-invokes chip->irq_mask().  This results
in a call chain, including gpiochip_irq_mask() and gpiochip_disable_irq().
Since FLAG_USED_AS_IRQ was cleared earlier, a warning occurs.

Replace calls to irq_mask() and irq_disable() hooks with a simplified call
to irq_shutdown(), and check if the interrupt is started (irqd_is_started)
before calling the shutdown.

Link: https://lkml.kernel.org/r/20241204142003.32859-3-farbere@amazon.com
Signed-off-by: Eliav Farber <farbere@amazon.com>
Cc: Aditya Gupta <adityag@linux.ibm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jonathan Chocron <jonnyc@amazon.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryo Takakura <takakura@valinux.co.jp>
Cc: Song Shuai <songshuaishuai@tinylab.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/kexec.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/irq/kexec.c~kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown
+++ a/kernel/irq/kexec.c
@@ -17,7 +17,7 @@ void machine_kexec_mask_interrupts(void)
 		int check_eoi = 1;
 
 		chip = irq_desc_get_chip(desc);
-		if (!chip)
+		if (!chip || !irqd_is_started(&desc->irq_data))
 			continue;
 
 		if (IS_ENABLED(CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD)) {
@@ -31,10 +31,6 @@ void machine_kexec_mask_interrupts(void)
 		if (check_eoi && chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
 			chip->irq_eoi(&desc->irq_data);
 
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
+		irq_shutdown(desc);
 	}
 }
_

Patches currently in -mm which might be from farbere@amazon.com are

kexec-consolidate-machine_kexec_mask_interrupts-implementation.patch
kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

