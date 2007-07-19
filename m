From: akpm@linux-foundation.org
Subject: - x86-64-calgary-cleanup-of-unneeded-macros.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:25 -0700
Message-ID: <200707192009.l6JK9PFT020578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761620AbXGSUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guillaume.thouvenin@bull.net, ak@suse.de, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: cleanup of unneeded macros
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-cleanup-of-unneeded-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: cleanup of unneeded macros
From: Guillaume Thouvenin <guillaume.thouvenin@bull.net>

Cleanup unneeded macros used for register space address calculation.
Now we are using the EBDA to find the space address.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    5 -----
 1 files changed, 5 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-cleanup-of-unneeded-macros arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-cleanup-of-unneeded-macros
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -52,11 +52,6 @@ int use_calgary __read_mostly = 0;
 #define PCI_DEVICE_ID_IBM_CALGARY 0x02a1
 #define PCI_DEVICE_ID_IBM_CALIOC2 0x0308
 
-/* we need these for register space address calculation */
-#define START_ADDRESS           0xfe000000
-#define CHASSIS_BASE            0
-#define ONE_BASED_CHASSIS_NUM   1
-
 /* register offsets inside the host bridge space */
 #define CALGARY_CONFIG_REG	0x0108
 #define PHB_CSR_OFFSET		0x0110 /* Channel Status */
_

Patches currently in -mm which might be from guillaume.thouvenin@bull.net are
