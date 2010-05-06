From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:35 -0400
Message-ID: <201005061910.o46JA6YY008493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0EFTKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, hpa@zytor.com, mingo@elte.hu, stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/apic/io_apic.c: fix NULL pointer for Xen guests
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-apic-io_apicc-fix-null-pointer-for-xen-guests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@kernel.org>
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

origin.patch

