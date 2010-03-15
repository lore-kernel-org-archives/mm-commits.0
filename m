From: akpm@linux-foundation.org
Subject: [merged] ipmi-fix-slave_addrs-setting-to-actually-work.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:36 -0400
Message-ID: <201003150702.o2F729Ge016849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blubkin@vmware.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: fix slave_addrs setting to actually work
has been removed from the -mm tree.  Its filename was
     ipmi-fix-slave_addrs-setting-to-actually-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: fix slave_addrs setting to actually work
From: Bela Lubkin <blubkin@vmware.com>

Actually use the slave_addrs module parameter if it is specified, and make
things consistent about passing zero in for the slave address for the
default.

Signed-off-by: Bela Lubkin <blubkin@vmware.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-slave_addrs-setting-to-actually-work drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-slave_addrs-setting-to-actually-work
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1201,7 +1201,7 @@ static int           regsizes[SI_MAX_PAR
 static unsigned int num_regsizes;
 static int           regshifts[SI_MAX_PARMS];
 static unsigned int num_regshifts;
-static int slave_addrs[SI_MAX_PARMS];
+static int slave_addrs[SI_MAX_PARMS]; /* Leaving 0 chooses the default value */
 static unsigned int num_slave_addrs;
 
 #define IPMI_IO_ADDR_SPACE  0
@@ -1669,7 +1669,7 @@ static int hotmod_handler(const char *va
 		regsize = 1;
 		regshift = 0;
 		irq = 0;
-		ipmb = 0x20;
+		ipmb = 0; /* Choose the default if not specified */
 
 		next = strchr(curr, ':');
 		if (next) {
@@ -1861,6 +1861,7 @@ static __devinit void hardcode_find_bmc(
 		info->irq = irqs[i];
 		if (info->irq)
 			info->irq_setup = std_irq_setup;
+		info->slave_addr = slave_addrs[i];
 
 		try_smi_init(info);
 	}
_

Patches currently in -mm which might be from blubkin@vmware.com are

origin.patch

