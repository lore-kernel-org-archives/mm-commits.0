From: akpm@linux-foundation.org
Subject: + ia64-avoid-invoking-irq-handlers-on-offline-cpus.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:56:48 -0700
Message-ID: <200809022356.m82NumKL019412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYIBX45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, jes@trained-monkey.org, manfred@colorfullife.com, tony.luck@intel.com, vegard.nossum@gmail.com


The patch titled
     ia64: avoid invoking irq handlers on offline CPUs
has been added to the -mm tree.  Its filename is
     ia64-avoid-invoking-irq-handlers-on-offline-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: avoid invoking irq handlers on offline CPUs
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Make ia64 refrain from clearing a given to-be-offlined CPU's bit in the
cpu_online_mask until it has processed pending irqs.  This change prevents
other CPUs from being blindsided by an apparently offline CPU nevertheless
changing globally visible state.  Also remove the existing redundant
cpu_clear(cpu, cpu_online_map).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~ia64-avoid-invoking-irq-handlers-on-offline-cpus arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~ia64-avoid-invoking-irq-handlers-on-offline-cpus
+++ a/arch/ia64/kernel/smpboot.c
@@ -741,16 +741,14 @@ int __cpu_disable(void)
 			return -EBUSY;
 	}
 
-	cpu_clear(cpu, cpu_online_map);
