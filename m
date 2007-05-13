From: akpm@linux-foundation.org
Subject: - ipmi-fix-si-address-space-settings.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:42 -0700
Message-ID: <200705130514.l4D5Ef9S022726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXEMFQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, Patrick.Schoeller@hp.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix SI address space settings
has been removed from the -mm tree.  Its filename was
     ipmi-fix-si-address-space-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix SI address space settings
From: Corey Minyard <minyard@acm.org>

Fix a rather obvious error that Patrick found in the setup routines.  Need to
set the proper address space in the ACPI case.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-si-address-space-settings drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-si-address-space-settings
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1915,10 +1915,10 @@ static __devinit int try_init_acpi(struc
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		info->io_setup = mem_setup;
-		info->io.addr_type = IPMI_IO_ADDR_SPACE;
+		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 	} else if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
 		info->io_setup = port_setup;
-		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
+		info->io.addr_type = IPMI_IO_ADDR_SPACE;
 	} else {
 		kfree(info);
 		printk("ipmi_si: Unknown ACPI I/O Address type\n");
_

Patches currently in -mm which might be from minyard@acm.org are

use-menuconfig-objects-ii-ipmi.patch
