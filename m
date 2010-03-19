From: akpm@linux-foundation.org
Subject: + ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch added to -mm tree
Date: Fri, 19 Mar 2010 14:23:55 -0700
Message-ID: <201003192123.o2JLNtWK013156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab0CSVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 17:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: myron.stowe@hp.com, bjorn.helgaas@hp.com, lenb@kernel.org, minyard@acm.org, yakui.zhao@intel.com


The patch titled
     ipmi: update driver to use 'dev_printk()' and its constructs
has been added to the -mm tree.  Its filename is
     ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

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
Subject: ipmi: update driver to use 'dev_printk()' and its constructs
From: Myron Stowe <myron.stowe@hp.com>

Update core IPMI driver printk()'s with dev_printk(), and its constructs,
to provide additional device topology information.

An example of the additional device topology for a PNP device -
  ipmi_si 00:02: probing via ACPI
  ipmi_si 00:02: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
  ipmi_si 00:02: Found new BMC (man_id: 0x00000b, prod_id: 0x0000, ...
  ipmi_si 00:02: IPMI kcs interface initialized

and for a PCI device -
  ipmi_si 0000:01:04.6: probing via PCI
  ipmi_si 0000:01:04.6: PCI INT A -> GSI 21 (level, low) -> IRQ 21
  ipmi_si 0000:01:04.6: [mem 0xf1ef0000-0xf1ef00ff] regsize 1 spaci...
  ipmi_si 0000:01:04.6: IPMI kcs interface initialized

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   11 -
 drivers/char/ipmi/ipmi_si_intf.c    |  188 +++++++++++---------------
 2 files changed, 87 insertions(+), 112 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-to-use-dev_printk-and-its-constructs drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-to-use-dev_printk-and-its-constructs
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -2505,12 +2505,11 @@ static int ipmi_bmc_register(ipmi_smi_t 
 			return rv;
 		}
 
-		printk(KERN_INFO
-		       "ipmi: Found new BMC (man_id: 0x%6.6x, "
-		       " prod_id: 0x%4.4x, dev_id: 0x%2.2x)\n",
-		       bmc->id.manufacturer_id,
-		       bmc->id.product_id,
-		       bmc->id.device_id);
+		dev_info(intf->si_dev, "Found new BMC (man_id: 0x%6.6x, "
+			 "prod_id: 0x%4.4x, dev_id: 0x%2.2x)\n",
+			 bmc->id.manufacturer_id,
+			 bmc->id.product_id,
+			 bmc->id.device_id);
 	}
 
 	/*
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-update-driver-to-use-dev_printk-and-its-constructs drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-update-driver-to-use-dev_printk-and-its-constructs
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -576,9 +576,8 @@ static void handle_transaction_done(stru
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 3);
 		if (msg[2] != 0) {
 			/* Error clearing flags */
-			printk(KERN_WARNING
-			       "ipmi_si: Error clearing flags: %2.2x\n",
-			       msg[2]);
+			dev_warn(smi_info->dev,
+				 "Error clearing flags: %2.2x\n", msg[2]);
 		}
 		if (smi_info->si_state == SI_CLEARING_FLAGS_THEN_SET_IRQ)
 			start_enable_irq(smi_info);
@@ -670,9 +669,8 @@ static void handle_transaction_done(stru
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			printk(KERN_WARNING
-			       "ipmi_si: Could not enable interrupts"
-			       ", failed get, using polled mode.\n");
+			dev_warn(smi_info->dev, "Could not enable interrupts"
+				 ", failed get, using polled mode.\n");
 			smi_info->si_state = SI_NORMAL;
 		} else {
 			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
@@ -694,9 +692,8 @@ static void handle_transaction_done(stru
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			printk(KERN_WARNING
-			       "ipmi_si: Could not enable interrupts"
-			       ", failed set, using polled mode.\n");
+			dev_warn(smi_info->dev, "Could not enable interrupts"
+				 ", failed set, using polled mode.\n");
 		}
 		smi_info->si_state = SI_NORMAL;
 		break;
@@ -709,9 +706,8 @@ static void handle_transaction_done(stru
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			printk(KERN_WARNING
-			       "ipmi_si: Could not disable interrupts"
-			       ", failed get.\n");
+			dev_warn(smi_info->dev, "Could not disable interrupts"
+				 ", failed get.\n");
 			smi_info->si_state = SI_NORMAL;
 		} else {
 			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
@@ -733,9 +729,8 @@ static void handle_transaction_done(stru
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			printk(KERN_WARNING
-			       "ipmi_si: Could not disable interrupts"
-			       ", failed set.\n");
+			dev_warn(smi_info->dev, "Could not disable interrupts"
+				 ", failed set.\n");
 		}
 		smi_info->si_state = SI_NORMAL;
 		break;
@@ -1144,10 +1139,10 @@ static int smi_start_processing(void    
 		new_smi->thread = kthread_run(ipmi_thread, new_smi,
 					      "kipmi%d", new_smi->intf_num);
 		if (IS_ERR(new_smi->thread)) {
-			printk(KERN_NOTICE "ipmi_si_intf: Could not start"
-			       " kernel thread due to error %ld, only using"
-			       " timers to drive the interface\n",
-			       PTR_ERR(new_smi->thread));
+			dev_notice(new_smi->dev, "Could not start"
+				   " kernel thread due to error %ld, only using"
+				   " timers to drive the interface\n",
+				   PTR_ERR(new_smi->thread));
 			new_smi->thread = NULL;
 		}
 	}
@@ -1308,8 +1303,7 @@ static int std_irq_setup(struct smi_info
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
-		printk(KERN_WARNING
-		       "ipmi_si: %s unable to claim interrupt %d,"
+		printk(KERN_WARNING PFX "%s unable to claim interrupt %d,"
 		       " running polled\n",
 		       DEVICE_NAME, info->irq);
 		info->irq = 0;
@@ -1406,7 +1400,7 @@ static int port_setup(struct smi_info *i
 		info->io.outputb = port_outl;
 		break;
 	default:
-		printk(KERN_WARNING "ipmi_si: Invalid register size: %d\n",
+		printk(KERN_WARNING PFX "Invalid register size: %d\n",
 		       info->io.regsize);
 		return -EINVAL;
 	}
@@ -1529,7 +1523,7 @@ static int mem_setup(struct smi_info *in
 		break;
 #endif
 	default:
-		printk(KERN_WARNING "ipmi_si: Invalid register size: %d\n",
+		printk(KERN_WARNING PFX "Invalid register size: %d\n",
 		       info->io.regsize);
 		return -EINVAL;
 	}
@@ -1814,6 +1808,7 @@ static __devinit void hardcode_find_bmc(
 			return;
 
 		info->addr_source = "hardcoded";
+		printk(KERN_INFO PFX "probing via %s\n", info->addr_source);
 
 		if (!si_type[i] || strcmp(si_type[i], "kcs") == 0) {
 			info->si_type = SI_KCS;
@@ -1822,8 +1817,7 @@ static __devinit void hardcode_find_bmc(
 		} else if (strcmp(si_type[i], "bt") == 0) {
 			info->si_type = SI_BT;
 		} else {
-			printk(KERN_WARNING
-			       "ipmi_si: Interface type specified "
+			printk(KERN_WARNING PFX "Interface type specified "
 			       "for interface %d, was invalid: %s\n",
 			       i, si_type[i]);
 			kfree(info);
@@ -1841,11 +1835,9 @@ static __devinit void hardcode_find_bmc(
 			info->io.addr_data = addrs[i];
 			info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 		} else {
-			printk(KERN_WARNING
-			       "ipmi_si: Interface type specified "
-			       "for interface %d, "
-			       "but port and address were not set or "
-			       "set to zero.\n", i);
+			printk(KERN_WARNING PFX "Interface type specified "
+			       "for interface %d, but port and address were "
+			       "not set or set to zero.\n", i);
 			kfree(info);
 			continue;
 		}
@@ -1923,10 +1915,8 @@ static int acpi_gpe_irq_setup(struct smi
 					  &ipmi_acpi_gpe,
 					  info);
 	if (status != AE_OK) {
-		printk(KERN_WARNING
-		       "ipmi_si: %s unable to claim ACPI GPE %d,"
-		       " running polled\n",
-		       DEVICE_NAME, info->irq);
+		printk(KERN_WARNING PFX "%s unable to claim ACPI GPE %d,"
+		       " running polled\n", DEVICE_NAME, info->irq);
 		info->irq = 0;
 		return -EINVAL;
 	} else {
@@ -1989,8 +1979,8 @@ static __devinit int try_init_spmi(struc
 	u8 		 addr_space;
 
 	if (spmi->IPMIlegacy != 1) {
-	    printk(KERN_INFO "IPMI: Bad SPMI legacy %d\n", spmi->IPMIlegacy);
-	    return -ENODEV;
+		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
+		return -ENODEV;
 	}
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
@@ -2000,11 +1990,12 @@ static __devinit int try_init_spmi(struc
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		printk(KERN_ERR "ipmi_si: Could not allocate SI data (3)\n");
+		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
 		return -ENOMEM;
 	}
 
 	info->addr_source = "SPMI";
+	printk(KERN_INFO PFX " probing via %s\n", info->addr_source);
 
 	/* Figure out the interface type. */
 	switch (spmi->InterfaceType) {
@@ -2018,8 +2009,8 @@ static __devinit int try_init_spmi(struc
 		info->si_type = SI_BT;
 		break;
 	default:
-		printk(KERN_INFO "ipmi_si: Unknown ACPI/SPMI SI type %d\n",
-			spmi->InterfaceType);
+		printk(KERN_INFO PFX "Unknown ACPI/SPMI SI type %d\n",
+		       spmi->InterfaceType);
 		kfree(info);
 		return -EIO;
 	}
@@ -2055,8 +2046,7 @@ static __devinit int try_init_spmi(struc
 		info->io.addr_type = IPMI_IO_ADDR_SPACE;
 	} else {
 		kfree(info);
-		printk(KERN_WARNING
-		       "ipmi_si: Unknown ACPI I/O Address type\n");
+		printk(KERN_WARNING PFX "Unknown ACPI I/O Address type\n");
 		return -EIO;
 	}
 	info->io.addr_data = spmi->addr.address;
@@ -2093,6 +2083,7 @@ static int __devinit ipmi_pnp_probe(stru
 {
 	struct acpi_device *acpi_dev;
 	struct smi_info *info;
+	struct resource *res;
 	acpi_handle handle;
 	acpi_status status;
 	unsigned long long tmp;
@@ -2106,6 +2097,7 @@ static int __devinit ipmi_pnp_probe(stru
 		return -ENOMEM;
 
 	info->addr_source = "ACPI";
+	dev_info(&dev->dev, "probing via %s\n", info->addr_source);
 
 	handle = acpi_dev->handle;
 
@@ -2125,22 +2117,26 @@ static int __devinit ipmi_pnp_probe(stru
 		info->si_type = SI_BT;
 		break;
 	default:
-		dev_info(&dev->dev, "unknown interface type %lld\n", tmp);
+		dev_info(&dev->dev, "unknown IPMI type %lld\n", tmp);
 		goto err_free;
 	}
 
-	if (pnp_port_valid(dev, 0)) {
+	res = pnp_get_resource(dev, IORESOURCE_IO, 0);
+	if (res) {
 		info->io_setup = port_setup;
 		info->io.addr_type = IPMI_IO_ADDR_SPACE;
-		info->io.addr_data = pnp_port_start(dev, 0);
-	} else if (pnp_mem_valid(dev, 0)) {
-		info->io_setup = mem_setup;
-		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
-		info->io.addr_data = pnp_mem_start(dev, 0);
 	} else {
+		res = pnp_get_resource(dev, IORESOURCE_MEM, 0);
+		if (res) {
+			info->io_setup = mem_setup;
+			info->io.addr_type = IPMI_MEM_ADDR_SPACE;
+		}
+	}
+	if (!res) {
 		dev_err(&dev->dev, "no I/O or memory address\n");
 		goto err_free;
 	}
+	info->io.addr_data = res->start;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
 	info->io.regsize = DEFAULT_REGSPACING;
@@ -2159,6 +2155,10 @@ static int __devinit ipmi_pnp_probe(stru
 	info->dev = &dev->dev;
 	pnp_set_drvdata(dev, info);
 
+	dev_info(info->dev, "%pR regsize %d spacing %d irq %d\n",
+		 res, info->io.regsize, info->io.regspacing,
+		 info->irq);
+
 	return try_smi_init(info);
 
 err_free:
@@ -2264,12 +2264,12 @@ static __devinit void try_init_dmi(struc
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		printk(KERN_ERR
-		       "ipmi_si: Could not allocate SI data\n");
+		printk(KERN_ERR PFX "Could not allocate SI data\n");
 		return;
 	}
 
 	info->addr_source = "SMBIOS";
+	printk(KERN_INFO PFX "probing via %s\n", info->addr_source);
 
 	switch (ipmi_data->type) {
 	case 0x01: /* KCS */
@@ -2299,8 +2299,7 @@ static __devinit void try_init_dmi(struc
 
 	default:
 		kfree(info);
-		printk(KERN_WARNING
-		       "ipmi_si: Unknown SMBIOS I/O Address type: %d.\n",
+		printk(KERN_WARNING PFX "Unknown SMBIOS I/O Address type: %d\n",
 		       ipmi_data->addr_space);
 		return;
 	}
@@ -2369,6 +2368,7 @@ static int __devinit ipmi_pci_probe(stru
 		return -ENOMEM;
 
 	info->addr_source = "PCI";
+	dev_info(&pdev->dev, "probing via %s\n", info->addr_source);
 
 	switch (class_type) {
 	case PCI_ERMC_CLASSCODE_TYPE_SMIC:
@@ -2385,15 +2385,13 @@ static int __devinit ipmi_pci_probe(stru
 
 	default:
 		kfree(info);
-		printk(KERN_INFO "ipmi_si: %s: Unknown IPMI type: %d\n",
-		       pci_name(pdev), class_type);
+		dev_info(&pdev->dev, "Unknown IPMI type: %d\n", class_type);
 		return -ENOMEM;
 	}
 
 	rv = pci_enable_device(pdev);
 	if (rv) {
-		printk(KERN_ERR "ipmi_si: %s: couldn't enable PCI device\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "couldn't enable PCI device\n");
 		kfree(info);
 		return rv;
 	}
@@ -2421,6 +2419,10 @@ static int __devinit ipmi_pci_probe(stru
 	info->dev = &pdev->dev;
 	pci_set_drvdata(pdev, info);
 
+	dev_info(&pdev->dev, "%pR regsize %d spacing %d irq %d\n",
+		&pdev->resource[0], info->io.regsize, info->io.regspacing,
+		info->irq);
+
 	return try_smi_init(info);
 }
 
@@ -2528,7 +2530,7 @@ static int __devinit ipmi_of_probe(struc
 	info->irq		= irq_of_parse_and_map(dev->node, 0);
 	info->dev		= &dev->dev;
 
-	dev_dbg(&dev->dev, "addr 0x%lx regsize %d spacing %d irq %x\n",
+	dev_dbg(&dev->dev, "addr 0x%lx regsize %d spacing %d irq %d\n",
 		info->io.addr_data, info->io.regsize, info->io.regspacing,
 		info->irq);
 
@@ -2640,9 +2642,8 @@ static int try_enable_event_buffer(struc
 
 	rv = wait_for_msg_done(smi_info);
 	if (rv) {
-		printk(KERN_WARNING
-		       "ipmi_si: Error getting response from get global,"
-		       " enables command, the event buffer is not"
+		printk(KERN_WARNING PFX "Error getting response from get"
+		       " global, enables command, the event buffer is not"
 		       " enabled.\n");
 		goto out;
 	}
@@ -2654,10 +2655,8 @@ static int try_enable_event_buffer(struc
 			resp[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2 ||
 			resp[1] != IPMI_GET_BMC_GLOBAL_ENABLES_CMD   ||
 			resp[2] != 0) {
-		printk(KERN_WARNING
-		       "ipmi_si: Invalid return from get global"
-		       " enables command, cannot enable the event"
-		       " buffer.\n");
+		printk(KERN_WARNING PFX "Invalid return from get global"
+		       " enables command, cannot enable the event buffer.\n");
 		rv = -EINVAL;
 		goto out;
 	}
@@ -2673,9 +2672,8 @@ static int try_enable_event_buffer(struc
 
 	rv = wait_for_msg_done(smi_info);
 	if (rv) {
-		printk(KERN_WARNING
-		       "ipmi_si: Error getting response from set global,"
-		       " enables command, the event buffer is not"
+		printk(KERN_WARNING PFX "Error getting response from set"
+		       " global, enables command, the event buffer is not"
 		       " enabled.\n");
 		goto out;
 	}
@@ -2686,10 +2684,8 @@ static int try_enable_event_buffer(struc
 	if (resp_len < 3 ||
 			resp[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2 ||
 			resp[1] != IPMI_SET_BMC_GLOBAL_ENABLES_CMD) {
-		printk(KERN_WARNING
-		       "ipmi_si: Invalid return from get global,"
-		       "enables command, not enable the event"
-		       " buffer.\n");
+		printk(KERN_WARNING PFX "Invalid return from get global,"
+		       "enables command, not enable the event buffer.\n");
 		rv = -EINVAL;
 		goto out;
 	}
@@ -2962,8 +2958,8 @@ static __devinit void default_find_bmc(v
 
 		if (try_smi_init(info) == 0) {
 			/* Found one... */
-			printk(KERN_INFO "ipmi_si: Found default %s state"
-			       " machine at %s address 0x%lx\n",
+			printk(KERN_INFO PFX "Found default %s state machine "
+			       "at %s address 0x%lx\n",
 			       si_to_str[info->si_type],
 			       addr_space_to_str[info->io.addr_type],
 			       info->io.addr_data);
@@ -2991,20 +2987,9 @@ static int try_smi_init(struct smi_info 
 	int rv;
 	int i;
 
-	if (new_smi->addr_source) {
-		printk(KERN_INFO "ipmi_si: Trying %s-specified %s state"
-		       " machine at %s address 0x%lx, slave address 0x%x,"
-		       " irq %d\n",
-		       new_smi->addr_source,
-		       si_to_str[new_smi->si_type],
-		       addr_space_to_str[new_smi->io.addr_type],
-		       new_smi->io.addr_data,
-		       new_smi->slave_addr, new_smi->irq);
-	}
-
 	mutex_lock(&smi_infos_lock);
 	if (!is_new_interface(new_smi)) {
-		printk(KERN_WARNING "ipmi_si: duplicate interface\n");
+		printk(KERN_WARNING PFX "duplicate interface\n");
 		rv = -EBUSY;
 		goto out_err;
 	}
@@ -3056,8 +3041,7 @@ static int try_smi_init(struct smi_info 
 	/* Do low-level detection first. */
 	if (new_smi->handlers->detect(new_smi->si_sm)) {
 		if (new_smi->addr_source)
-			printk(KERN_INFO "ipmi_si: Interface detection"
-			       " failed\n");
+			printk(KERN_INFO PFX "Interface detection failed\n");
 		rv = -ENODEV;
 		goto out_err;
 	}
@@ -3069,7 +3053,7 @@ static int try_smi_init(struct smi_info 
 	rv = try_get_dev_id(new_smi);
 	if (rv) {
 		if (new_smi->addr_source)
-			printk(KERN_INFO "ipmi_si: There appears to be no BMC"
+			printk(KERN_INFO PFX "There appears to be no BMC"
 			       " at this location\n");
 		goto out_err;
 	}
@@ -3138,9 +3122,8 @@ static int try_smi_init(struct smi_info 
 			       "bmc",
 			       new_smi->slave_addr);
 	if (rv) {
-		printk(KERN_ERR
-		       "ipmi_si: Unable to register device: error %d\n",
-		       rv);
+		dev_err(new_smi->dev, "Unable to register device: error %d\n",
+			rv);
 		goto out_err_stop_timer;
 	}
 
@@ -3148,9 +3131,7 @@ static int try_smi_init(struct smi_info 
 				     type_file_read_proc,
 				     new_smi);
 	if (rv) {
-		printk(KERN_ERR
-		       "ipmi_si: Unable to create proc entry: %d\n",
-		       rv);
+		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
 		goto out_err_stop_timer;
 	}
 
@@ -3158,9 +3139,7 @@ static int try_smi_init(struct smi_info 
 				     stat_file_read_proc,
 				     new_smi);
 	if (rv) {
-		printk(KERN_ERR
-		       "ipmi_si: Unable to create proc entry: %d\n",
-		       rv);
+		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
 		goto out_err_stop_timer;
 	}
 
@@ -3168,9 +3147,7 @@ static int try_smi_init(struct smi_info 
 				     param_read_proc,
 				     new_smi);
 	if (rv) {
-		printk(KERN_ERR
-		       "ipmi_si: Unable to create proc entry: %d\n",
-		       rv);
+		dev_err(new_smi->dev, "Unable to create proc entry: %d\n", rv);
 		goto out_err_stop_timer;
 	}
 
@@ -3178,8 +3155,8 @@ static int try_smi_init(struct smi_info 
 
 	mutex_unlock(&smi_infos_lock);
 
-	printk(KERN_INFO "IPMI %s interface initialized\n",
-	       si_to_str[new_smi->si_type]);
+	dev_info(new_smi->dev, "IPMI %s interface initialized\n",
+		 si_to_str[new_smi->si_type]);
 
 	return 0;
 
@@ -3306,8 +3283,8 @@ static __devinit int init_ipmi_si(void)
 		of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 		driver_unregister(&ipmi_driver.driver);
-		printk(KERN_WARNING
-		       "ipmi_si: Unable to find any System Interface(s)\n");
+		printk(KERN_WARNING PFX
+		       "Unable to find any System Interface(s)\n");
 		return -ENODEV;
 	} else {
 		mutex_unlock(&smi_infos_lock);
@@ -3364,8 +3341,7 @@ static void cleanup_one_si(struct smi_in
 
 	rv = ipmi_unregister_smi(to_clean->intf);
 	if (rv) {
-		printk(KERN_ERR
-		       "ipmi_si: Unable to unregister device: errno=%d\n",
+		printk(KERN_ERR PFX "Unable to unregister device: errno=%d\n",
 		       rv);
 	}
 
_

Patches currently in -mm which might be from myron.stowe@hp.com are

ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

