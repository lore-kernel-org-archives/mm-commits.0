From: akpm@linux-foundation.org
Subject: + x86_64-fix-section-mismatch-compile-warning.patch added to -mm tree
Date: Wed, 28 Mar 2007 15:20:15 -0700
Message-ID: <200703282220.l2SMKFSg021444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbXC1WUT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 18:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de


The patch titled
     x86_64: fix "Section mismatch" compile warning
has been added to the -mm tree.  Its filename is
     x86_64-fix-section-mismatch-compile-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix "Section mismatch" compile warning
From: Bernhard Walle <bwalle@suse.de>

Fix "Section mismatch" warnings in arch/x86_64/kernel/time.c

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/time.c~x86_64-fix-section-mismatch-compile-warning arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-fix-section-mismatch-compile-warning
+++ a/arch/x86_64/kernel/time.c
@@ -282,7 +282,7 @@ static unsigned int __init pit_calibrate
 #define PIT_MODE 0x43
 #define PIT_CH0  0x40
 
-static void __init __pit_init(int val, u8 mode)
+static void __pit_init(int val, u8 mode)
 {
 	unsigned long flags;
 
@@ -298,12 +298,12 @@ void __init pit_init(void)
 	__pit_init(LATCH, 0x34); /* binary, mode 2, LSB/MSB, ch 0 */
 }
 
-void __init pit_stop_interrupt(void)
+void pit_stop_interrupt(void)
 {
 	__pit_init(0, 0x30); /* mode 0 */
 }
 
-void __init stop_timer_interrupt(void)
+void stop_timer_interrupt(void)
 {
 	char *name;
 	if (hpet_address) {
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
x86_64-fix-section-mismatch-compile-warning.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
