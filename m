From: akpm@linux-foundation.org
Subject: - x86-amd-thermal-interrupt-support-fix-3.patch removed from -mm tree
Date: Tue, 05 Feb 2008 00:00:11 -0800
Message-ID: <200802050759.m157xqO5011007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbYBEIAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 03:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tremyfr@yahoo.fr, ak@suse.de, mingo@elte.hu, rml@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-amd-thermal-interrupt-support fix 3
has been removed from the -mm tree.  Its filename was
     x86-amd-thermal-interrupt-support-fix-3.patch

This patch was dropped because it was folded into x86-amd-thermal-inter=
rupt-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86-amd-thermal-interrupt-support fix 3
=46rom: trem <tremyfr@yahoo.fr>

I've got an error when I compile 2.6.24-mm1 on x86_64 :

  CC      arch/x86/kernel/cpu/mcheck/mce_amd_64.o
  CC      kernel/posix-cpu-timers.o
arch/x86/kernel/cpu/mcheck/mce_amd_64.c: In function =91smp_thermal_int=
errupt_init=92:
arch/x86/kernel/cpu/mcheck/mce_amd_64.c:876: erreur: lvalue required as=
 unary =91&=92 operand
make[3]: *** [arch/x86/kernel/cpu/mcheck/mce_amd_64.o] Erreur 1
make[2]: *** [arch/x86/kernel/cpu/mcheck] Erreur 2
make[1]: *** [arch/x86/kernel/cpu] Erreur 2

Cc: Russell Leidich <rml@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_amd_64.c~x86-amd-thermal-inter=
rupt-support-fix-3 arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c~x86-amd-thermal-interrupt=
-support-fix-3
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -873,7 +873,7 @@ static int smp_thermal_interrupt_init(vo
 	/*
 	 * Call thermal_apic_init() on each core.
 	 */
-	on_each_cpu(&thermal_apic_init, NULL, 1, 0);
+	on_each_cpu(thermal_apic_init, NULL, 1, 0);
 	smp_thermal_early_throttle_check();
 out:
 	return 0;
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

x86-amd-thermal-interrupt-support.patch
x86-amd-thermal-interrupt-support-fix-3.patch
