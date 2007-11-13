From: akpm@linux-foundation.org
Subject: - x86-io_apic_64c-remove-unused-config-check.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:59 -0800
Message-ID: <200711130407.lAD47wSf025267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbXKMEQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     x86: io_apic_64.c: remove unused config check
has been removed from the -mm tree.  Its filename was
     x86-io_apic_64c-remove-unused-config-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-x86.patch
