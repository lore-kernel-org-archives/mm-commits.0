From: akpm@linux-foundation.org
Subject: + x86-use-for_each_clear_bit_from.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:25 -0800
Message-ID: <20120113225625.925A110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33463 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2AMW40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:26 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so368945ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86: use for_each_clear_bit_from()
has been added to the -mm tree.  Its filename is
     x86-use-for_each_clear_bit_from.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: x86: use for_each_clear_bit_from()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch

