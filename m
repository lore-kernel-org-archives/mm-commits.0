From: akpm@linux-foundation.org
Subject: [merged] x86-use-for_each_clear_bit_from.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:22 -0700
Message-ID: <20120326192922.81386A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55374 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:24 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so288130bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use for_each_clear_bit_from()
has been removed from the -mm tree.  Its filename was
     x86-use-for_each_clear_bit_from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: x86: use for_each_clear_bit_from()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/irqinit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/irqinit.c~x86-use-for_each_clear_bit_from arch/x86/kernel/irqinit.c
--- a/arch/x86/kernel/irqinit.c~x86-use-for_each_clear_bit_from
+++ a/arch/x86/kernel/irqinit.c
@@ -306,10 +306,10 @@ void __init native_init_IRQ(void)
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
-	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+	i = FIRST_EXTERNAL_VECTOR;
+	for_each_clear_bit_from(i, used_vectors, NR_VECTORS) {
 		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
-		if (!test_bit(i, used_vectors))
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
 
 	if (!acpi_ioapic && !of_ioapic)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

