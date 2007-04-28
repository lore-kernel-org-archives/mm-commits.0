From: akpm@linux-foundation.org
Subject: - i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:15 -0700
Message-ID: <200704281055.l3SAtFns020164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965744AbXD1KzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 machine_real_restart(): replace spin_lock_irqsave with spin_lock
has been removed from the -mm tree.  Its filename was
     i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -198,8 +198,6 @@ static unsigned char jump_to_bios [] =
  */
 void machine_real_restart(unsigned char *code, int length)
 {
-	unsigned long flags;
-
 	local_irq_disable();
 
 	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -212,9 +210,9 @@ void machine_real_restart(unsigned char 
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

upper-32-bits.patch
