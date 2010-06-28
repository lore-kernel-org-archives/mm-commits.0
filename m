From: akpm@linux-foundation.org
Subject: + x86-calgary-increase-max-phb-number.patch added to -mm tree
Date: Mon, 28 Jun 2010 15:07:17 -0700
Message-ID: <201006282207.o5SM7HWA001323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab0F1WHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jun 2010 18:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, hpa@zytor.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     x86: calgary: increase max PHB number
has been added to the -mm tree.  Its filename is
     x86-calgary-increase-max-phb-number.patch

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
Subject: x86: calgary: increase max PHB number
From: "Darrick J. Wong" <djwong@us.ibm.com>

Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so
bump the limits up and provide an explanation of the requirements for each
class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~x86-calgary-increase-max-phb-number arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-calgary-increase-max-phb-number
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -103,11 +103,14 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
-#define PHBS_PER_CALGARY	4
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		384
 
 /* register offsets in Calgary's internal register space */
 static const unsigned long tar_offsets[] = {
_

Patches currently in -mm which might be from djwong@us.ibm.com are

x86-calgary-increase-max-phb-number.patch

