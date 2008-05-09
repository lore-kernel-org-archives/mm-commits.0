From: akpm@linux-foundation.org
Subject: + ipmi-support-i-o-resources-in-of-driver.patch added to -mm tree
Date: Thu, 08 May 2008 18:42:57 -0700
Message-ID: <200805090142.m491gvOc016470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934798AbYEIBoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 21:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ncase@xes-inc.com, cminyard@mvista.com


The patch titled
     ipmi: support I/O resources in OF driver
has been added to the -mm tree.  Its filename is
     ipmi-support-i-o-resources-in-of-driver.patch

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
Subject: ipmi: support I/O resources in OF driver
From: Nate Case <ncase@xes-inc.com>

The current OF probing assumes that the resource is IORESOURCE_MEM.  This
checks for the IORESOURCE_IO flag and behaves appropriately.  An I/O resource
can exist with an ipmi device node on a legacy ISA bus.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-support-i-o-resources-in-of-driver drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-support-i-o-resources-in-of-driver
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2352,10 +2352,16 @@ static int __devinit ipmi_of_probe(struc
 
 	info->si_type		= (enum si_type) match->data;
 	info->addr_source	= "device-tree";
-	info->io_setup		= mem_setup;
 	info->irq_setup		= std_irq_setup;
 
-	info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	if (resource.flags & IORESOURCE_IO) {
+		info->io_setup		= port_setup;
+		info->io.addr_type	= IPMI_IO_ADDR_SPACE;
+	} else {
+		info->io_setup		= mem_setup;
+		info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	}
+
 	info->io.addr_data	= resource.start;
 
 	info->io.regsize	= regsize ? *regsize : DEFAULT_REGSIZE;
_

Patches currently in -mm which might be from ncase@xes-inc.com are

ipmi-support-i-o-resources-in-of-driver.patch

