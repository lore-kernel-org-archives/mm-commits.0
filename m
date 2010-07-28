From: akpm@linux-foundation.org
Subject: + ipmi-fix-memleaking-for-add_smi-when-duplicating-happen.patch added to -mm tree
Date: Wed, 28 Jul 2010 12:28:21 -0700
Message-ID: <201007281928.o6SJSL3c030301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0G1T2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, len.brown@intel.com, minyard@acm.org, mjg@redhat.com, myron.stowe@hp.com


The patch titled
     ipmi: fix memleaking for add_smi when duplicating happen
has been added to the -mm tree.  Its filename is
     ipmi-fix-memleaking-for-add_smi-when-duplicating-happen.patch

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
Subject: ipmi: fix memleaking for add_smi when duplicating happen
From: Yinghai Lu <yinghai@kernel.org>

Free the temporary info struct when we have duplicated ones.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Corey Minyard <minyard@acm.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Myron Stowe <myron.stowe@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   35 +++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-memleaking-for-add_smi-when-duplicating-happen drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-memleaking-for-add_smi-when-duplicating-happen
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1804,9 +1804,12 @@ static int hotmod_handler(const char *va
 				info->irq_setup = std_irq_setup;
 			info->slave_addr = ipmb;
 
-			if (!add_smi(info))
+			if (!add_smi(info)) {
 				if (try_smi_init(info))
 					cleanup_one_si(info);
+			} else {
+				kfree(info);
+			}
 		} else {
 			/* remove */
 			struct smi_info *e, *tmp_e;
@@ -1890,9 +1893,12 @@ static __devinit void hardcode_find_bmc(
 			info->irq_setup = std_irq_setup;
 		info->slave_addr = slave_addrs[i];
 
-		if (!add_smi(info))
+		if (!add_smi(info)) {
 			if (try_smi_init(info))
 				cleanup_one_si(info);
+		} else {
+			kfree(info);
+		}
 	}
 }
 
@@ -2082,7 +2088,8 @@ static __devinit int try_init_spmi(struc
 	}
 	info->io.addr_data = spmi->addr.address;
 
-	add_smi(info);
+	if (add_smi(info))
+		kfree(info);
 
 	return 0;
 }
@@ -2198,7 +2205,10 @@ static int __devinit ipmi_pnp_probe(stru
 		 res, info->io.regsize, info->io.regspacing,
 		 info->irq);
 
-	return add_smi(info);
+	if (add_smi(info))
+		goto err_free;
+
+	return 0;
 
 err_free:
 	kfree(info);
@@ -2356,7 +2366,8 @@ static __devinit void try_init_dmi(struc
 	if (info->irq)
 		info->irq_setup = std_irq_setup;
 
-	add_smi(info);
+	if (add_smi(info))
+		kfree(info);
 }
 
 static void __devinit dmi_find_bmc(void)
@@ -2462,7 +2473,10 @@ static int __devinit ipmi_pci_probe(stru
 		&pdev->resource[0], info->io.regsize, info->io.regspacing,
 		info->irq);
 
-	return add_smi(info);
+	if (add_smi(info))
+		kfree(info);
+
+	return 0;
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
@@ -2575,7 +2589,12 @@ static int __devinit ipmi_of_probe(struc
 
 	dev_set_drvdata(&dev->dev, info);
 
-	return add_smi(info);
+	if (add_smi(info)) {
+		kfree(info);
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 static int __devexit ipmi_of_remove(struct of_device *dev)
@@ -3008,6 +3027,8 @@ static __devinit void default_find_bmc(v
 				info->io.addr_data);
 			} else
 				cleanup_one_si(info);
+		} else {
+			kfree(info);
 		}
 	}
 }
_

Patches currently in -mm which might be from yinghai@kernel.org are

ipmi-fix-acpi-detecting-with-regspacing.patch
linux-next.patch
kernel-range-remove-unused-definition-of-array_size.patch
ipmi-fix-memleaking-for-add_smi-when-duplicating-happen.patch
ipmi-print-info-for-spmi-and-smbios-paths-like-acpi-and-pci.patch

