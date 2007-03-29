From: akpm@linux-foundation.org
Subject: + i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch added to -mm tree
Date: Wed, 28 Mar 2007 18:45:52 -0700
Message-ID: <200703290145.l2T1jqin025025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965890AbXC2Bp6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 21:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp, ak@suse.de


The patch titled
     i386 machine_real_restart(): replace spin_lock_irqsave with spin_lock
has been added to the -mm tree.  Its filename is
     i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 machine_real_restart(): replace spin_lock_irqsave with spin_lock
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

IRQ is already disabled through local_irq_disable().  So
spin_lock_irqsave() can be replaced with spin_lock().

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/reboot.c~i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c~i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock
+++ a/arch/i386/kernel/reboot.c
@@ -197,8 +197,6 @@ static unsigned char jump_to_bios [] =
  */
 void machine_real_restart(unsigned char *code, int length)
 {
-	unsigned long flags;
-
 	local_irq_disable();
 
 	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -211,9 +209,9 @@ void machine_real_restart(unsigned char 
 	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
 	 */
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&rtc_lock);
 	CMOS_WRITE(0x00, 0x8f);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock(&rtc_lock);
 
 	/* Remap the kernel at virtual address zero, as well as offset zero
 	   from the kernel segment.  This assumes the kernel segment starts at
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch
