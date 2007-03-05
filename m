From: akpm@linux-foundation.org
Subject: - ipmi-check-if-default-ports-are-accessible-on-ppc.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:49 -0800
Message-ID: <200703052355.l25NtnDA005212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42004 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXCEX4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, benh@kernel.crashing.org, michael@ellerman.id.au, minyard@acm.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: check, if default ports are accessible on PPC
has been removed from the -mm tree.  Its filename was
     ipmi-check-if-default-ports-are-accessible-on-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipmi: check, if default ports are accessible on PPC
From: Christian Krafft <krafft@de.ibm.com>

ipmi_si_intf tries to access default ports, if no device could be found
elsewhere.  On PPC we have a function to check, if these legacy IO ports
are accessible.  This patch adds a check for these ports on PPC.  This
patch fixes a breakage of IPMI module on PPC machines without a BMC.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Acked-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-check-if-default-ports-are-accessible-on-ppc drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-check-if-default-ports-are-accessible-on-ppc
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2478,6 +2478,11 @@ static __devinit void default_find_bmc(v
 		if (!info)
 			return;
 
+#ifdef CONFIG_PPC_MERGE
+		if (check_legacy_ioport(ipmi_defaults[i].port))
+			continue;
+#endif
+
 		info->addr_source = NULL;
 
 		info->si_type = ipmi_defaults[i].type;
_

Patches currently in -mm which might be from krafft@de.ibm.com are

origin.patch
ipmi-add-powerpc-openfirmware-sensing.patch
