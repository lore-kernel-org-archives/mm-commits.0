From: akpm@linux-foundation.org
Subject: + ipmi-fix-si-address-space-settings.patch added to -mm tree
Date: Fri, 11 May 2007 12:59:59 -0700
Message-ID: <200705111959.l4BJxxnn025351@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758918AbXEKUBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 16:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org, Patrick.Schoeller@hp.com, stable@kernel.org


The patch titled
     IPMI: fix SI address space settings
has been added to the -mm tree.  Its filename is
     ipmi-fix-si-address-space-settings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
ipmi-fix-si-address-space-settings.patch
ipmi-add-ppc-openfirmware-unregister.patch
use-menuconfig-objects-ii-ipmi.patch
