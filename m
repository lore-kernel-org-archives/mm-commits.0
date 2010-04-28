From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:27:27 -0700
Message-ID: <201004281827.o3SIRRxv012093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520Ab0D1S2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, hpa@zytor.com, mingo@elte.hu, suresh.b.siddha@intel.com, tglx@linutronix.de


The patch titled
     arch/x86/kernel/apic/io_apic.c: fix NULL pointer for Xen guests
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/apic/io_apic.c: fix NULL pointer for Xen guests
From: Prarit Bhargava <prarit@redhat.com>

Upstream PV guests fail to boot because of a NULL pointer.  It is possible
that xen guests have irq_desc->chip_data = NULL.

Test for NULL chip_data pointer before attempting to complete an irq move.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
+	if (!cfg)
+		return;
+
 	__irq_complete_move(&desc, cfg->vector);
 }
 #else
_

Patches currently in -mm which might be from prarit@redhat.com are

arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests.patch

