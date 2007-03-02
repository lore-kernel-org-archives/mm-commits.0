From: akpm@linux-foundation.org
Subject: + ipmi-check-if-default-ports-are-accessible-on-ppc.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:35:14 -0800
Message-ID: <200703022235.l22MZEfb021109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030654AbXCBWff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:35:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krafft@de.ibm.com, benh@kernel.crashing.org, michael@ellerman.id.au, minyard@acm.org, paulus@samba.org


The patch titled
     ipmi: check, if default ports are accessible on PPC
has been added to the -mm tree.  Its filename is
     ipmi-check-if-default-ports-are-accessible-on-ppc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+)

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

ipmi-check-if-default-ports-are-accessible-on-ppc.patch
ipmi-add-powerpc-openfirmware-sensing.patch
