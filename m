From: akpm@linux-foundation.org
Subject: - x86_64-fix-default_do_nmi-missing-return-after-a-if.patch removed from -mm tree
Date: Fri, 11 May 2007 22:14:55 -0700
Message-ID: <200705120514.l4C5Etgm001696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbXELFPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix default_do_nmi() missing return after an if ()
has been removed from the -mm tree.  Its filename was
     x86_64-fix-default_do_nmi-missing-return-after-a-if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix default_do_nmi() missing return after an if ()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/traps.c~x86_64-fix-default_do_nmi-missing-return-after-a-if arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~x86_64-fix-default_do_nmi-missing-return-after-a-if
+++ a/arch/x86_64/kernel/traps.c
@@ -778,6 +778,7 @@ asmlinkage __kprobes void default_do_nmi
 			return;
 		if (notify_die(DIE_NMI_POST, "nmi_post", regs, reason, 2, 0)
 								== NOTIFY_STOP)
+			return;
 		if (!do_nmi_callback(regs,cpu))
 			unknown_nmi_error(reason, regs);
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
