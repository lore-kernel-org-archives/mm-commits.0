From: akpm@linux-foundation.org
Subject: + x86_64-fix-default_do_nmi-missing-return-after-a-if.patch added to -mm tree
Date: Wed, 09 May 2007 18:26:03 -0700
Message-ID: <200705100126.l4A1Q34o008914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbXEJB0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 21:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de


The patch titled
     x86_64: fix default_do_nmi() missing return after an if ()
has been added to the -mm tree.  Its filename is
     x86_64-fix-default_do_nmi-missing-return-after-a-if.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
