From: akpm@linux-foundation.org
Subject: + fix-interchanged-parameters-to-release_evntselperfctr_nmi.patch added to -mm tree
Date: Thu, 07 Jun 2007 23:40:22 -0700
Message-ID: <200706080640.l586eM10021573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698AbXFHGkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, ak@suse.de, eranian@hpl.hp.com


The patch titled
     perfctr-watchdog: fix interchanged parameters to release_{evntsel,perfctr}_nmi
has been added to the -mm tree.  Its filename is
     fix-interchanged-parameters-to-release_evntselperfctr_nmi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: perfctr-watchdog: fix interchanged parameters to release_{evntsel,perfctr}_nmi
From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

Fix oops triggered during: echo 0 > /proc/sys/kernel/nmi_watchdog

The culprit seems to be 09198e68501a7e34737cd9264d266f42429abcdc:
[PATCH] i386: Clean up NMI watchdog code

In two places, the parameters to release_{evntsel,perfctr}_nmi
got interchanged during the cleanup.

Fix interchanged parameters to release_{evntsel,perfctr}_nmi.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~fix-interchanged-parameters-to-release_evntselperfctr_nmi arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~fix-interchanged-parameters-to-release_evntselperfctr_nmi
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -276,8 +276,8 @@ static int single_msr_reserve(void)
 
 static void single_msr_unreserve(void)
 {
-	release_evntsel_nmi(wd_ops->perfctr);
-	release_perfctr_nmi(wd_ops->evntsel);
+	release_evntsel_nmi(wd_ops->evntsel);
+	release_perfctr_nmi(wd_ops->perfctr);
 }
 
 static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
@@ -475,10 +475,10 @@ static void p4_unreserve(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings > 1)
-		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
+		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
 #endif
-	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
-	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
+	release_evntsel_nmi(MSR_P4_CRU_ESCR0);
+	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
 }
 
 static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

fix-interchanged-parameters-to-release_evntselperfctr_nmi.patch
