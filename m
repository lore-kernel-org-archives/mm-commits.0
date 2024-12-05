Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49AC1B87D0
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733430606; cv=none; b=XoKfvKJsEYqNxzfZ5PUbjhymuww7AXFjdHuSmffYglBrMcUnCJwruXeLSNn3XDOv5v2fbqi824VO5ioAflSz3yFm8I+RgTFgHrdWw4r66JnpadP00j1Kqp9d7oi/ej87BYmLvX3XLBIEUGU4G3eU6IZNCGeBzVwzkQ4CukwKZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733430606; c=relaxed/simple;
	bh=swdd879deUJNI35ag2P/1kKo71dB5rhWiVtAbi2tWGc=;
	h=Date:To:From:Subject:Message-Id; b=M43CxDtw+tEb/pQCSAX7mStxGXwL3QeZ9yhGO31gipwifdF8Q+7pcreCSbK8xwy89ooYix26A39E17QsNzOtRF+EEK9ifmMvMXIqOrsDqs2bdvAq+m0jsH7z6iJYV4WOWahZfElUjz2od45tpxtW4RyqcEAuDaRyf6k8O9MO1x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lha4PsKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lha4PsKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D86AC4AF09;
	Thu,  5 Dec 2024 20:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733430606;
	bh=swdd879deUJNI35ag2P/1kKo71dB5rhWiVtAbi2tWGc=;
	h=Date:To:From:Subject:From;
	b=Lha4PsKfqtFkws2k6B/X1B/3JzoymFv699K+M4bJhi1DfRzPi4LpQ0F8hz3ZldHwm
	 /BdVUllcla5MFax8Oeose3LbkCRv6ABmApQOSWE3m4RXg0gElF+L8ErUqA3IZeVbp1
	 9jMuPgCMgMQCEJAY23BAuPUJcjbygBpU9yFhqstU=
Date: Thu, 05 Dec 2024 12:30:05 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,takakura@valinux.co.jp,sourabhjain@linux.ibm.com,songshuaishuai@tinylab.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,linux@armlinux.org.uk,jonnyc@amazon.com,hbathini@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,adityag@linux.ibm.com,farbere@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch removed from -mm tree
Message-Id: <20241205203006.0D86AC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: prevent redundant IRQ masking by checking state before shutdown
has been removed from the -mm tree.  Its filename was
     kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

This patch was dropped because it is obsolete

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


