From: akpm@linux-foundation.org
Subject: + x86-io_apic_64c-remove-unused-config-check.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:25:57 -0800
Message-ID: <200711122125.lACLPvAu009719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbXKLV0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com


The patch titled
     x86: io_apic_64.c: remove unused config check
has been added to the -mm tree.  Its filename is
     x86-io_apic_64c-remove-unused-config-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: io_apic_64.c: remove unused config check
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

CONFIG_IRQBALANCE doesn't exist on x86_64.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/io_apic_64.c~x86-io_apic_64c-remove-unused-config-check arch/x86/kernel/io_apic_64.c
--- a/arch/x86/kernel/io_apic_64.c~x86-io_apic_64c-remove-unused-config-check
+++ a/arch/x86/kernel/io_apic_64.c
@@ -1436,7 +1436,7 @@ static void ack_apic_level(unsigned int 
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-#if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
+#ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

x86-io_apic_64c-remove-unused-config-check.patch
