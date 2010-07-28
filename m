From: akpm@linux-foundation.org
Subject: + ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci.patch added to -mm tree
Date: Wed, 28 Jul 2010 12:28:23 -0700
Message-ID: <201007281928.o6SJSNZh030305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0G1T2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 15:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, len.brown@intel.com, minyard@acm.org, mjg@redhat.com, myron.stowe@hp.com


The patch titled
     ipmi: print info for spmi and smbios paths like acpi and pci
has been added to the -mm tree.  Its filename is
     ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci.patch

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
Subject: ipmi: print info for spmi and smbios paths like acpi and pci
From: Yinghai Lu <yinghai@kernel.org>

Print out the reg spacing and size for spmi and smbios so BIOS developers
can make them consistent.

Also remove extra PFX on the duplicating path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Corey Minyard <minyard@acm.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Myron Stowe <myron.stowe@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2088,6 +2088,11 @@ static __devinit int try_init_spmi(struc
 	}
 	info->io.addr_data = spmi->addr.address;
 
+	pr_info("ipmi_si: SPMI: %s %#lx regsize %d spacing %d irq %d\n",
+		 (info->io.addr_type == IPMI_IO_ADDR_SPACE) ? "io" : "mem",
+		 info->io.addr_data, info->io.regsize, info->io.regspacing,
+		 info->irq);
+
 	if (add_smi(info))
 		kfree(info);
 
@@ -2366,6 +2371,11 @@ static __devinit void try_init_dmi(struc
 	if (info->irq)
 		info->irq_setup = std_irq_setup;
 
+	pr_info("ipmi_si: SMBIOS: %s %#lx regsize %d spacing %d irq %d\n",
+		 (info->io.addr_type == IPMI_IO_ADDR_SPACE) ? "io" : "mem",
+		 info->io.addr_data, info->io.regsize, info->io.regspacing,
+		 info->irq);
+
 	if (add_smi(info))
 		kfree(info);
 }
@@ -3056,7 +3066,7 @@ static int add_smi(struct smi_info *new_
 			si_to_str[new_smi->si_type]);
 	mutex_lock(&smi_infos_lock);
 	if (!is_new_interface(new_smi)) {
-		printk(KERN_CONT PFX "duplicate interface\n");
+		printk(KERN_CONT " duplicate interface\n");
 		rv = -EBUSY;
 		goto out_err;
 	}
_

Patches currently in -mm which might be from yinghai@kernel.org are

ipmi-fix-acpi-detecting-with-regspacing.patch
linux-next.patch
kernel-range-remove-unused-definition-of-array_size.patch
ipmi-fix-memleaking-for-add_smi-when-duplicating-happen.patch
ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci.patch

