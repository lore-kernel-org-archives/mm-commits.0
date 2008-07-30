From: akpm@linux-foundation.org
Subject: + agp-use-dev_printk-when-possible.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:38:20 -0700
Message-ID: <200807300038.m6U0cKKL030431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYG3AjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     agp: use dev_printk when possible
has been added to the -mm tree.  Its filename is
     agp-use-dev_printk-when-possible.patch

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
Subject: agp: use dev_printk when possible
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert printks to use dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ali-agp.c      |   10 ++--
 drivers/char/agp/amd-k7-agp.c   |   10 ++--
 drivers/char/agp/amd64-agp.c    |   36 ++++++++--------
 drivers/char/agp/ati-agp.c      |    7 +--
 drivers/char/agp/backend.c      |   26 +++++++-----
 drivers/char/agp/generic.c      |   13 ++----
 drivers/char/agp/intel-agp.c    |   64 ++++++++++++++++--------------
 drivers/char/agp/isoch.c        |   37 ++++++++---------
 drivers/char/agp/sis-agp.c      |   15 +++----
 drivers/char/agp/sworks-agp.c   |   25 ++++++-----
 drivers/char/agp/uninorth-agp.c |   32 +++++++--------
 11 files changed, 141 insertions(+), 134 deletions(-)

diff -puN drivers/char/agp/ali-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/ali-agp.c
--- a/drivers/char/agp/ali-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/ali-agp.c
@@ -110,7 +110,8 @@ static int ali_configure(void)
 
 		nlvm_addr+= agp_bridge->gart_bus_addr;
 		nlvm_addr|=(agp_bridge->gart_bus_addr>>12);
-		printk(KERN_INFO PFX "nlvm top &base = %8x\n",nlvm_addr);
+		dev_info(&agp_bridge->dev->dev, "nlvm top &base = %8x\n",
+			 nlvm_addr);
 	}
 #endif
 
@@ -315,8 +316,8 @@ static int __devinit agp_ali_probe(struc
 			goto found;
 	}
 
-	printk(KERN_ERR PFX "Unsupported ALi chipset (device id: %04x)\n",
-	     pdev->device);
+	dev_err(&pdev->dev, "unsupported ALi chipset [%04x/%04x])\n",
+		pdev->vendor, pdev->device);
 	return -ENODEV;
 
 
@@ -361,8 +362,7 @@ found:
 		bridge->driver = &ali_generic_bridge;
 	}
 
-	printk(KERN_INFO PFX "Detected ALi %s chipset\n",
-			devs[j].chipset_name);
+	dev_info(&pdev->dev, "ALi %s chipset\n", devs[j].chipset_name);
 
 	/* Fill in the mode register */
 	pci_read_config_dword(pdev,
diff -puN drivers/char/agp/amd-k7-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -419,8 +419,8 @@ static int __devinit agp_amdk7_probe(str
 		return -ENODEV;
 
 	j = ent - agp_amdk7_pci_table;
-	printk(KERN_INFO PFX "Detected AMD %s chipset\n",
-	       amd_agp_device_ids[j].chipset_name);
+	dev_info(&pdev->dev, "AMD %s chipset\n",
+		 amd_agp_device_ids[j].chipset_name);
 
 	bridge = agp_alloc_bridge();
 	if (!bridge)
@@ -442,7 +442,7 @@ static int __devinit agp_amdk7_probe(str
 		while (!cap_ptr) {
 			gfxcard = pci_get_class(PCI_CLASS_DISPLAY_VGA<<8, gfxcard);
 			if (!gfxcard) {
-				printk (KERN_INFO PFX "Couldn't find an AGP VGA controller.\n");
+				dev_info(&pdev->dev, "no AGP VGA controller\n");
 				return -ENODEV;
 			}
 			cap_ptr = pci_find_capability(gfxcard, PCI_CAP_ID_AGP);
@@ -453,7 +453,7 @@ static int __devinit agp_amdk7_probe(str
 		   (if necessary at all). */
 		if (gfxcard->vendor == PCI_VENDOR_ID_NVIDIA) {
 			agp_bridge->flags |= AGP_ERRATA_1X;
-			printk (KERN_INFO PFX "AMD 751 chipset with NVidia GeForce detected. Forcing to 1X due to errata.\n");
+			dev_info(&pdev->dev, "AMD 751 chipset with NVidia GeForce; forcing 1X due to errata\n");
 		}
 		pci_dev_put(gfxcard);
 	}
@@ -469,7 +469,7 @@ static int __devinit agp_amdk7_probe(str
 			agp_bridge->flags = AGP_ERRATA_FASTWRITES;
 			agp_bridge->flags |= AGP_ERRATA_SBA;
 			agp_bridge->flags |= AGP_ERRATA_1X;
-			printk (KERN_INFO PFX "AMD 761 chipset with errata detected - disabling AGP fast writes & SBA and forcing to 1X.\n");
+			dev_info(&pdev->dev, "AMD 761 chipset with errata; disabling AGP fast writes & SBA and forcing to 1X\n");
 		}
 	}
 
diff -puN drivers/char/agp/amd64-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/amd64-agp.c
@@ -294,12 +294,13 @@ static __devinit int fix_northbridge(str
 	 * so let double check that order, and lets trust the AMD NB settings
 	 */
 	if (order >=0 && aper + (32ULL<<(20 + order)) > 0x100000000ULL) {
-		printk(KERN_INFO "Aperture size %u MB is not right, using settings from NB\n",
-				  32 << order);
+		dev_info(&agp->dev, "aperture size %u MB is not right, using settings from NB\n",
+			 32 << order);
 		order = nb_order;
 	}
 
-	printk(KERN_INFO PFX "Aperture from AGP @ %Lx size %u MB\n", aper, 32 << order);
+	dev_info(&agp->dev, "aperture from AGP @ %Lx size %u MB\n",
+		 aper, 32 << order);
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
 
@@ -320,10 +321,10 @@ static __devinit int cache_nbs (struct p
 	for (i = 0; i < num_k8_northbridges; i++) {
 		struct pci_dev *dev = k8_northbridges[i];
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
-			printk(KERN_ERR PFX "No usable aperture found.\n");
+			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
 			/* should port this to i386 */
-			printk(KERN_ERR PFX "Consider rebooting with iommu=memaper=2 to get a good aperture.\n");
+			dev_err(&dev->dev, "consider rebooting with iommu=memaper=2 to get a good aperture\n");
 #endif
 			return -1;
 		}
@@ -346,14 +347,14 @@ static void __devinit amd8151_init(struc
 	default:   revstring="??"; break;
 	}
 
-	printk (KERN_INFO PFX "Detected AMD 8151 AGP Bridge rev %s\n", revstring);
+	dev_info(&pdev->dev, "AMD 8151 AGP Bridge rev %s\n", revstring);
 
 	/*
 	 * Work around errata.
 	 * Chips before B2 stepping incorrectly reporting v3.5
 	 */
 	if (pdev->revision < 0x13) {
-		printk (KERN_INFO PFX "Correcting AGP revision (reports 3.5, is really 3.0)\n");
+		dev_info(&pdev->dev, "correcting AGP revision (reports 3.5, is really 3.0)\n");
 		bridge->major_version = 3;
 		bridge->minor_version = 0;
 	}
@@ -376,11 +377,11 @@ static int __devinit uli_agp_init(struct
 	struct pci_dev *dev1;
 	int i;
 	unsigned size = amd64_fetch_size();
-	printk(KERN_INFO "Setting up ULi AGP.\n");
+
+	dev_info(&pdev->dev, "setting up ULi AGP\n");
 	dev1 = pci_get_slot (pdev->bus,PCI_DEVFN(0,0));
 	if (dev1 == NULL) {
-		printk(KERN_INFO PFX "Detected a ULi chipset, "
-			"but could not fine the secondary device.\n");
+		dev_info(&pdev->dev, "can't find ULi secondary device\n");
 		return -ENODEV;
 	}
 
@@ -389,7 +390,7 @@ static int __devinit uli_agp_init(struct
 			break;
 
 	if (i == ARRAY_SIZE(uli_sizes)) {
-		printk(KERN_INFO PFX "No ULi size found for %d\n", size);
+		dev_info(&pdev->dev, "no ULi size found for %d\n", size);
 		return -ENODEV;
 	}
 
@@ -434,13 +435,11 @@ static int nforce3_agp_init(struct pci_d
 	int i;
 	unsigned size = amd64_fetch_size();
 
-	printk(KERN_INFO PFX "Setting up Nforce3 AGP.\n");
+	dev_info(&pdev->dev, "setting up Nforce3 AGP\n");
 
 	dev1 = pci_get_slot(pdev->bus, PCI_DEVFN(11, 0));
 	if (dev1 == NULL) {
-		printk(KERN_INFO PFX "agpgart: Detected an NVIDIA "
-			"nForce3 chipset, but could not find "
-			"the secondary device.\n");
+		dev_info(&pdev->dev, "can't find Nforce3 secondary device\n");
 		return -ENODEV;
 	}
 
@@ -449,7 +448,7 @@ static int nforce3_agp_init(struct pci_d
 			break;
 
 	if (i == ARRAY_SIZE(nforce3_sizes)) {
-		printk(KERN_INFO PFX "No NForce3 size found for %d\n", size);
+		dev_info(&pdev->dev, "no NForce3 size found for %d\n", size);
 		return -ENODEV;
 	}
 
@@ -463,7 +462,7 @@ static int nforce3_agp_init(struct pci_d
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
-		printk(KERN_INFO PFX "aperture base > 4G\n");
+		dev_info(&pdev->dev, "aperture base > 4G\n");
 		return -ENODEV;
 	}
 
@@ -506,7 +505,8 @@ static int __devinit agp_amd64_probe(str
 	    pdev->device == PCI_DEVICE_ID_AMD_8151_0) {
 		amd8151_init(pdev, bridge);
 	} else {
-		printk(KERN_INFO PFX "Detected AGP bridge %x\n", pdev->devfn);
+		dev_info(&pdev->dev, "AGP bridge [%04x/%04x]\n",
+			 pdev->vendor, pdev->device);
 	}
 
 	bridge->driver = &amd_8151_driver;
diff -puN drivers/char/agp/ati-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/ati-agp.c
@@ -486,8 +486,8 @@ static int __devinit agp_ati_probe(struc
 			goto found;
 	}
 
-	printk(KERN_ERR PFX
-	     "Unsupported Ati chipset (device id: %04x)\n", pdev->device);
+	dev_err(&pdev->dev, "unsupported Ati chipset [%04x/%04x])\n",
+		pdev->vendor, pdev->device);
 	return -ENODEV;
 
 found:
@@ -500,8 +500,7 @@ found:
 
 	bridge->driver = &ati_generic_bridge;
 
-	printk(KERN_INFO PFX "Detected Ati %s chipset\n",
-			devs[j].chipset_name);
+	dev_info(&pdev->dev, "Ati %s chipset\n", devs[j].chipset_name);
 
 	/* Fill in the mode register */
 	pci_read_config_dword(pdev,
diff -puN drivers/char/agp/backend.c~agp-use-dev_printk-when-possible drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/backend.c
@@ -144,7 +144,8 @@ static int agp_backend_initialize(struct
 		void *addr = bridge->driver->agp_alloc_page(bridge);
 
 		if (!addr) {
-			printk(KERN_ERR PFX "unable to get memory for scratch page.\n");
+			dev_err(&bridge->dev->dev,
+				"can't get memory for scratch page\n");
 			return -ENOMEM;
 		}
 
@@ -155,13 +156,13 @@ static int agp_backend_initialize(struct
 
 	size_value = bridge->driver->fetch_size();
 	if (size_value == 0) {
-		printk(KERN_ERR PFX "unable to determine aperture size.\n");
+		dev_err(&bridge->dev->dev, "can't determine aperture size\n");
 		rc = -EINVAL;
 		goto err_out;
 	}
 	if (bridge->driver->create_gatt_table(bridge)) {
-		printk(KERN_ERR PFX
-		    "unable to get memory for graphics translation table.\n");
+		dev_err(&bridge->dev->dev,
+			"can't get memory for graphics translation table\n");
 		rc = -ENOMEM;
 		goto err_out;
 	}
@@ -169,7 +170,8 @@ static int agp_backend_initialize(struct
 
 	bridge->key_list = vmalloc(PAGE_SIZE * 4);
 	if (bridge->key_list == NULL) {
-		printk(KERN_ERR PFX "error allocating memory for key lists.\n");
+		dev_err(&bridge->dev->dev,
+			"can't allocate memory for key lists\n");
 		rc = -ENOMEM;
 		goto err_out;
 	}
@@ -179,7 +181,7 @@ static int agp_backend_initialize(struct
 	memset(bridge->key_list, 0, PAGE_SIZE * 4);
 
 	if (bridge->driver->configure()) {
-		printk(KERN_ERR PFX "error configuring host chipset.\n");
+		dev_err(&bridge->dev->dev, "error configuring host chipset\n");
 		rc = -EINVAL;
 		goto err_out;
 	}
@@ -269,25 +271,27 @@ int agp_add_bridge(struct agp_bridge_dat
 
 	/* Grab reference on the chipset driver. */
 	if (!try_module_get(bridge->driver->owner)) {
-		printk (KERN_INFO PFX "Couldn't lock chipset driver.\n");
+		dev_info(&bridge->dev->dev, "can't lock chipset driver\n");
 		return -EINVAL;
 	}
 
 	error = agp_backend_initialize(bridge);
 	if (error) {
-		printk (KERN_INFO PFX "agp_backend_initialize() failed.\n");
+		dev_info(&bridge->dev->dev,
+			 "agp_backend_initialize() failed\n");
 		goto err_out;
 	}
 
 	if (list_empty(&agp_bridges)) {
 		error = agp_frontend_initialize();
 		if (error) {
-			printk (KERN_INFO PFX "agp_frontend_initialize() failed.\n");
+			dev_info(&bridge->dev->dev,
+				 "agp_frontend_initialize() failed\n");
 			goto frontend_err;
 		}
 
-		printk(KERN_INFO PFX "AGP aperture is %dM @ 0x%lx\n",
-			bridge->driver->fetch_size(), bridge->gart_bus_addr);
+		dev_info(&bridge->dev->dev, "AGP aperture is %dM @ 0x%lx\n",
+			 bridge->driver->fetch_size(), bridge->gart_bus_addr);
 
 	}
 
diff -puN drivers/char/agp/generic.c~agp-use-dev_printk-when-possible drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/generic.c
@@ -771,8 +771,8 @@ void agp_device_command(u32 bridge_agpst
 		if (!agp)
 			continue;
 
-		printk(KERN_INFO PFX "Putting AGP V%d device at %s into %dx mode\n",
-				agp_v3 ? 3 : 2, pci_name(device), mode);
+		dev_info(&device->dev, "putting AGP V%d device into %dx mode\n",
+			 agp_v3 ? 3 : 2, mode);
 		pci_write_config_dword(device, agp + PCI_AGP_COMMAND, bridge_agpstat);
 	}
 }
@@ -800,10 +800,8 @@ void agp_generic_enable(struct agp_bridg
 
 	get_agp_version(agp_bridge);
 
-	printk(KERN_INFO PFX "Found an AGP %d.%d compliant device at %s.\n",
-				agp_bridge->major_version,
-				agp_bridge->minor_version,
-				pci_name(agp_bridge->dev));
+	dev_info(&agp_bridge->dev->dev, "AGP %d.%d bridge\n",
+		 agp_bridge->major_version, agp_bridge->minor_version);
 
 	pci_read_config_dword(agp_bridge->dev,
 		      agp_bridge->capndx + PCI_AGP_STATUS, &bridge_agpstat);
@@ -832,8 +830,7 @@ void agp_generic_enable(struct agp_bridg
 		    pci_write_config_dword(bridge->dev,
 					bridge->capndx+AGPCTRL, temp);
 
-		    printk(KERN_INFO PFX "Device is in legacy mode,"
-				" falling back to 2.x\n");
+		    dev_info(&bridge->dev->dev, "bridge is in legacy mode, falling back to 2.x\n");
 		}
 	}
 
diff -puN drivers/char/agp/intel-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/intel-agp.c
@@ -161,7 +161,7 @@ static int intel_i810_fetch_size(void)
 	values = A_SIZE_FIX(agp_bridge->driver->aperture_sizes);
 
 	if ((smram_miscc & I810_GMS) == I810_GMS_DISABLE) {
-		printk(KERN_WARNING PFX "i810 is disabled\n");
+		dev_warn(&agp_bridge->dev->dev, "i810 is disabled\n");
 		return 0;
 	}
 	if ((smram_miscc & I810_GFX_MEM_WIN_SIZE) == I810_GFX_MEM_WIN_32M) {
@@ -193,7 +193,8 @@ static int intel_i810_configure(void)
 
 		intel_private.registers = ioremap(temp, 128 * 4096);
 		if (!intel_private.registers) {
-			printk(KERN_ERR PFX "Unable to remap memory.\n");
+			dev_err(&intel_private.pcidev->dev,
+				"can't remap memory\n");
 			return -ENOMEM;
 		}
 	}
@@ -201,7 +202,8 @@ static int intel_i810_configure(void)
 	if ((readl(intel_private.registers+I810_DRAM_CTL)
 		& I810_DRAM_ROW_0) == I810_DRAM_ROW_0_SDRAM) {
 		/* This will need to be dynamically assigned */
-		printk(KERN_INFO PFX "detected 4MB dedicated video ram.\n");
+		dev_info(&intel_private.pcidev->dev,
+			 "detected 4MB dedicated video ram\n");
 		intel_private.num_dcache_entries = 1024;
 	}
 	pci_read_config_dword(intel_private.pcidev, I810_GMADDR, &temp);
@@ -500,8 +502,8 @@ static void intel_i830_init_gtt_entries(
 			size = 1024 + 512;
 			break;
 		default:
-			printk(KERN_INFO PFX "Unknown page table size, "
-			       "assuming 512KB\n");
+			dev_info(&intel_private.pcidev->dev,
+				 "unknown page table size, assuming 512KB\n");
 			size = 512;
 		}
 		size += 4; /* add in BIOS popup space */
@@ -515,8 +517,8 @@ static void intel_i830_init_gtt_entries(
 			size = 2048;
 			break;
 		default:
-			printk(KERN_INFO PFX "Unknown page table size 0x%x, "
-				"assuming 512KB\n",
+			dev_info(&agp_bridge->dev->dev,
+				 "unknown page table size 0x%x, assuming 512KB\n",
 				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
 			size = 512;
 		}
@@ -627,11 +629,11 @@ static void intel_i830_init_gtt_entries(
 		}
 	}
 	if (gtt_entries > 0)
-		printk(KERN_INFO PFX "Detected %dK %s memory.\n",
+		dev_info(&agp_bridge->dev->dev, "detected %dK %s memory\n",
 		       gtt_entries / KB(1), local ? "local" : "stolen");
 	else
-		printk(KERN_INFO PFX
-		       "No pre-allocated video memory detected.\n");
+		dev_info(&agp_bridge->dev->dev,
+		       "no pre-allocated video memory detected\n");
 	gtt_entries /= KB(4);
 
 	intel_private.gtt_entries = gtt_entries;
@@ -801,10 +803,12 @@ static int intel_i830_insert_entries(str
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
 	if (pg_start < intel_private.gtt_entries) {
-		printk(KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
-				pg_start, intel_private.gtt_entries);
+		dev_printk(KERN_DEBUG, &intel_private.pcidev->dev,
+			   "pg_start == 0x%.8lx, intel_private.gtt_entries == 0x%.8x\n",
+			   pg_start, intel_private.gtt_entries);
 
-		printk(KERN_INFO PFX "Trying to insert into local/stolen memory\n");
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to insert into local/stolen memory\n");
 		goto out_err;
 	}
 
@@ -851,7 +855,8 @@ static int intel_i830_remove_entries(str
 		return 0;
 
 	if (pg_start < intel_private.gtt_entries) {
-		printk(KERN_INFO PFX "Trying to disable local/stolen memory\n");
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
@@ -957,7 +962,7 @@ static void intel_i9xx_setup_flush(void)
 	if (intel_private.ifp_resource.start) {
 		intel_private.i9xx_flush_page = ioremap_nocache(intel_private.ifp_resource.start, PAGE_SIZE);
 		if (!intel_private.i9xx_flush_page)
-			printk(KERN_INFO "unable to ioremap flush  page - no chipset flushing");
+			dev_info(&intel_private.pcidev->dev, "can't ioremap flush page - no chipset flushing");
 	}
 }
 
@@ -1028,10 +1033,12 @@ static int intel_i915_insert_entries(str
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
 	if (pg_start < intel_private.gtt_entries) {
-		printk(KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
-				pg_start, intel_private.gtt_entries);
+		dev_printk(KERN_DEBUG, &intel_private.pcidev->dev,
+			   "pg_start == 0x%.8lx, intel_private.gtt_entries == 0x%.8x\n",
+			   pg_start, intel_private.gtt_entries);
 
-		printk(KERN_INFO PFX "Trying to insert into local/stolen memory\n");
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to insert into local/stolen memory\n");
 		goto out_err;
 	}
 
@@ -1078,7 +1085,8 @@ static int intel_i915_remove_entries(str
 		return 0;
 
 	if (pg_start < intel_private.gtt_entries) {
-		printk(KERN_INFO PFX "Trying to disable local/stolen memory\n");
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
@@ -1379,7 +1387,7 @@ static int intel_815_configure(void)
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
 	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
-		printk(KERN_EMERG PFX "gatt bus addr too high");
+		dev_emerg(&agp_bridge->dev->dev, "gatt bus addr too high");
 		return -EINVAL;
 	}
 
@@ -2163,8 +2171,8 @@ static int __devinit agp_intel_probe(str
 
 	if (intel_agp_chipsets[i].name == NULL) {
 		if (cap_ptr)
-			printk(KERN_WARNING PFX "Unsupported Intel chipset"
-			       "(device id: %04x)\n", pdev->device);
+			dev_warn(&pdev->dev, "unsupported Intel chipset [%04x/%04x]\n",
+				 pdev->vendor, pdev->device);
 		agp_put_bridge(bridge);
 		return -ENODEV;
 	}
@@ -2172,9 +2180,8 @@ static int __devinit agp_intel_probe(str
 	if (bridge->driver == NULL) {
 		/* bridge has no AGP and no IGD detected */
 		if (cap_ptr)
-			printk(KERN_WARNING PFX "Failed to find bridge device "
-				"(chip_id: %04x)\n",
-				intel_agp_chipsets[i].gmch_chip_id);
+			dev_warn(&pdev->dev, "can't find bridge device (chip_id: %04x)\n",
+				 intel_agp_chipsets[i].gmch_chip_id);
 		agp_put_bridge(bridge);
 		return -ENODEV;
 	}
@@ -2183,8 +2190,7 @@ static int __devinit agp_intel_probe(str
 	bridge->capndx = cap_ptr;
 	bridge->dev_private_data = &intel_private;
 
-	printk(KERN_INFO PFX "Detected an Intel %s Chipset.\n",
-		intel_agp_chipsets[i].name);
+	dev_info(&pdev->dev, "Intel %s Chipset\n", intel_agp_chipsets[i].name);
 
 	/*
 	* The following fixes the case where the BIOS has "forgotten" to
@@ -2194,7 +2200,7 @@ static int __devinit agp_intel_probe(str
 	r = &pdev->resource[0];
 	if (!r->start && r->end) {
 		if (pci_assign_resource(pdev, 0)) {
-			printk(KERN_ERR PFX "could not assign resource 0\n");
+			dev_err(&pdev->dev, "can't assign resource 0\n");
 			agp_put_bridge(bridge);
 			return -ENODEV;
 		}
@@ -2206,7 +2212,7 @@ static int __devinit agp_intel_probe(str
 	* 20030610 - hamish@zot.org
 	*/
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR PFX "Unable to Enable PCI device\n");
+		dev_err(&pdev->dev, "can't enable PCI device\n");
 		agp_put_bridge(bridge);
 		return -ENODEV;
 	}
diff -puN drivers/char/agp/isoch.c~agp-use-dev_printk-when-possible drivers/char/agp/isoch.c
--- a/drivers/char/agp/isoch.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/isoch.c
@@ -153,7 +153,7 @@ static int agp_3_5_isochronous_node_enab
 
 	/* Check if this configuration has any chance of working */
 	if (tot_bw > target.maxbw) {
-		printk(KERN_ERR PFX "isochronous bandwidth required "
+		dev_err(&td->dev, "isochronous bandwidth required "
 			"by AGP 3.0 devices exceeds that which is supported by "
 			"the AGP 3.0 bridge!\n");
 		ret = -ENODEV;
@@ -188,7 +188,7 @@ static int agp_3_5_isochronous_node_enab
 	/* Exit if the minimal ISOCH_N allocation among the masters is more
 	 * than the target can handle. */
 	if (tot_n > target.n) {
-		printk(KERN_ERR PFX "number of isochronous "
+		dev_err(&td->dev, "number of isochronous "
 			"transactions per period required by AGP 3.0 devices "
 			"exceeds that which is supported by the AGP 3.0 "
 			"bridge!\n");
@@ -229,7 +229,7 @@ static int agp_3_5_isochronous_node_enab
 	/* Exit if the minimal RQ needs of the masters exceeds what the target
 	 * can provide. */
 	if (tot_rq > rq_isoch) {
-		printk(KERN_ERR PFX "number of request queue slots "
+		dev_err(&td->dev, "number of request queue slots "
 			"required by the isochronous bandwidth requested by "
 			"AGP 3.0 devices exceeds the number provided by the "
 			"AGP 3.0 bridge!\n");
@@ -359,8 +359,9 @@ int agp_3_5_enable(struct agp_bridge_dat
 			case 0x0001:    /* Unclassified device */
 				/* Don't know what this is, but log it for investigation. */
 				if (mcapndx != 0) {
-					printk (KERN_INFO PFX "Wacky, found unclassified AGP device. %x:%x\n",
-						dev->vendor, dev->device);
+					dev_info(&td->dev, "wacky, found unclassified AGP device %s [%04x/%04x]\n",
+						 pci_name(dev),
+						 dev->vendor, dev->device);
 				}
 				continue;
 
@@ -407,17 +408,18 @@ int agp_3_5_enable(struct agp_bridge_dat
 		}
 
 		if (mcapndx == 0) {
-			printk(KERN_ERR PFX "woah!  Non-AGP device "
-				"found on the secondary bus of an AGP 3.5 bridge!\n");
+			dev_err(&td->dev, "woah!  Non-AGP device %s on "
+				"secondary bus of AGP 3.5 bridge!\n",
+				pci_name(dev));
 			ret = -ENODEV;
 			goto free_and_exit;
 		}
 
 		mmajor = (ncapid >> AGP_MAJOR_VERSION_SHIFT) & 0xf;
 		if (mmajor < 3) {
-			printk(KERN_ERR PFX "woah!  AGP 2.0 device "
-				"found on the secondary bus of an AGP 3.5 "
-				"bridge operating with AGP 3.0 electricals!\n");
+			dev_err(&td->dev, "woah!  AGP 2.0 device %s on "
+				"secondary bus of AGP 3.5 bridge operating "
+				"with AGP 3.0 electricals!\n", pci_name(dev));
 			ret = -ENODEV;
 			goto free_and_exit;
 		}
@@ -427,10 +429,10 @@ int agp_3_5_enable(struct agp_bridge_dat
 		pci_read_config_dword(dev, cur->capndx+AGPSTAT, &mstatus);
 
 		if (((mstatus >> 3) & 0x1) == 0) {
-			printk(KERN_ERR PFX "woah!  AGP 3.x device "
-				"not operating in AGP 3.x mode found on the "
-				"secondary bus of an AGP 3.5 bridge operating "
-				"with AGP 3.0 electricals!\n");
+			dev_err(&td->dev, "woah!  AGP 3.x device %s not "
+				"operating in AGP 3.x mode on secondary bus "
+				"of AGP 3.5 bridge operating with AGP 3.0 "
+				"electricals!\n", pci_name(dev));
 			ret = -ENODEV;
 			goto free_and_exit;
 		}
@@ -444,9 +446,9 @@ int agp_3_5_enable(struct agp_bridge_dat
 	if (isoch) {
 		ret = agp_3_5_isochronous_node_enable(bridge, dev_list, ndevs);
 		if (ret) {
-			printk(KERN_INFO PFX "Something bad happened setting "
-			       "up isochronous xfers.  Falling back to "
-			       "non-isochronous xfer mode.\n");
+			dev_info(&td->dev, "something bad happened setting "
+				 "up isochronous xfers; falling back to "
+				 "non-isochronous xfer mode\n");
 		} else {
 			goto free_and_exit;
 		}
@@ -466,4 +468,3 @@ free_and_exit:
 get_out:
 	return ret;
 }
-
diff -puN drivers/char/agp/sis-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/sis-agp.c
--- a/drivers/char/agp/sis-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/sis-agp.c
@@ -79,10 +79,8 @@ static void sis_delayed_enable(struct ag
 	u32 command;
 	int rate;
 
-	printk(KERN_INFO PFX "Found an AGP %d.%d compliant device at %s.\n",
-		agp_bridge->major_version,
-		agp_bridge->minor_version,
-		pci_name(agp_bridge->dev));
+	dev_info(&agp_bridge->dev->dev, "AGP %d.%d bridge\n",
+		 agp_bridge->major_version, agp_bridge->minor_version);
 
 	pci_read_config_dword(agp_bridge->dev, agp_bridge->capndx + PCI_AGP_STATUS, &command);
 	command = agp_collect_device_status(bridge, mode, command);
@@ -94,8 +92,8 @@ static void sis_delayed_enable(struct ag
 		if (!agp)
 			continue;
 
-		printk(KERN_INFO PFX "Putting AGP V3 device at %s into %dx mode\n",
-			pci_name(device), rate);
+		dev_info(&agp_bridge->dev->dev, "putting AGP V3 device at %s into %dx mode\n",
+			 pci_name(device), rate);
 
 		pci_write_config_dword(device, agp + PCI_AGP_COMMAND, command);
 
@@ -105,7 +103,7 @@ static void sis_delayed_enable(struct ag
 		 * cannot be configured
 		 */
 		if (device->device == bridge->dev->device) {
-			printk(KERN_INFO PFX "SiS delay workaround: giving bridge time to recover.\n");
+			dev_info(&agp_bridge->dev->dev, "SiS delay workaround: giving bridge time to recover\n");
 			msleep(10);
 		}
 	}
@@ -190,7 +188,8 @@ static int __devinit agp_sis_probe(struc
 		return -ENODEV;
 
 
-	printk(KERN_INFO PFX "Detected SiS chipset - id:%i\n", pdev->device);
+	dev_info(&pdev->dev, "SiS chipset [%04x/%04x]\n",
+		 pdev->vendor, pdev->device);
 	bridge = agp_alloc_bridge();
 	if (!bridge)
 		return -ENOMEM;
diff -puN drivers/char/agp/sworks-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/sworks-agp.c
--- a/drivers/char/agp/sworks-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/sworks-agp.c
@@ -241,7 +241,8 @@ static void serverworks_tlbflush(struct 
 	while (readb(serverworks_private.registers+SVWRKS_POSTFLUSH) == 1) {
 		cpu_relax();
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR PFX "TLB post flush took more than 3 seconds\n");
+			dev_err(&serverworks_private.svrwrks_dev->dev,
+				"TLB post flush took more than 3 seconds\n");
 			break;
 		}
 	}
@@ -251,7 +252,8 @@ static void serverworks_tlbflush(struct 
 	while (readl(serverworks_private.registers+SVWRKS_DIRFLUSH) == 1) {
 		cpu_relax();
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR PFX "TLB Dir flush took more than 3 seconds\n");
+			dev_err(&serverworks_private.svrwrks_dev->dev,
+				"TLB Dir flush took more than 3 seconds\n");
 			break;
 		}
 	}
@@ -271,7 +273,7 @@ static int serverworks_configure(void)
 	temp = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 	serverworks_private.registers = (volatile u8 __iomem *) ioremap(temp, 4096);
 	if (!serverworks_private.registers) {
-		printk (KERN_ERR PFX "Unable to ioremap() memory.\n");
+		dev_err(&agp_bridge->dev->dev, "can't ioremap(%#x)\n", temp);
 		return -ENOMEM;
 	}
 
@@ -451,7 +453,7 @@ static int __devinit agp_serverworks_pro
 
 	switch (pdev->device) {
 	case 0x0006:
-		printk (KERN_ERR PFX "ServerWorks CNB20HE is unsupported due to lack of documentation.\n");
+		dev_err(&pdev->dev, "ServerWorks CNB20HE is unsupported due to lack of documentation\n");
 		return -ENODEV;
 
 	case PCI_DEVICE_ID_SERVERWORKS_HE:
@@ -461,8 +463,8 @@ static int __devinit agp_serverworks_pro
 
 	default:
 		if (cap_ptr)
-			printk(KERN_ERR PFX "Unsupported Serverworks chipset "
-					"(device id: %04x)\n", pdev->device);
+			dev_err(&pdev->dev, "unsupported Serverworks chipset "
+				"[%04x/%04x]\n", pdev->vendor, pdev->device);
 		return -ENODEV;
 	}
 
@@ -470,8 +472,7 @@ static int __devinit agp_serverworks_pro
 	bridge_dev = pci_get_bus_and_slot((unsigned int)pdev->bus->number,
 			PCI_DEVFN(0, 1));
 	if (!bridge_dev) {
-		printk(KERN_INFO PFX "Detected a Serverworks chipset "
-		       "but could not find the secondary device.\n");
+		dev_info(&pdev->dev, "can't find secondary device\n");
 		return -ENODEV;
 	}
 
@@ -482,8 +483,8 @@ static int __devinit agp_serverworks_pro
 	if (temp & PCI_BASE_ADDRESS_MEM_TYPE_64) {
 		pci_read_config_dword(pdev, SVWRKS_APSIZE + 4, &temp2);
 		if (temp2 != 0) {
-			printk(KERN_INFO PFX "Detected 64 bit aperture address, "
-			       "but top bits are not zero.  Disabling agp\n");
+			dev_info(&pdev->dev, "64 bit aperture address, "
+				 "but top bits are not zero; disabling AGP\n");
 			return -ENODEV;
 		}
 		serverworks_private.mm_addr_ofs = 0x18;
@@ -495,8 +496,8 @@ static int __devinit agp_serverworks_pro
 		pci_read_config_dword(pdev,
 				serverworks_private.mm_addr_ofs + 4, &temp2);
 		if (temp2 != 0) {
-			printk(KERN_INFO PFX "Detected 64 bit MMIO address, "
-			       "but top bits are not zero.  Disabling agp\n");
+			dev_info(&pdev->dev, "64 bit MMIO address, but top "
+				 "bits are not zero; disabling AGP\n");
 			return -ENODEV;
 		}
 	}
diff -puN drivers/char/agp/uninorth-agp.c~agp-use-dev_printk-when-possible drivers/char/agp/uninorth-agp.c
--- a/drivers/char/agp/uninorth-agp.c~agp-use-dev_printk-when-possible
+++ a/drivers/char/agp/uninorth-agp.c
@@ -46,8 +46,8 @@ static int uninorth_fetch_size(void)
 				break;
 
 		if (i == agp_bridge->driver->num_aperture_sizes) {
-			printk(KERN_ERR PFX "Invalid aperture size, using"
-			       " default\n");
+			dev_err(&agp_bridge->dev->dev, "invalid aperture size, "
+				"using default\n");
 			size = 0;
 			aperture = NULL;
 		}
@@ -108,8 +108,8 @@ static int uninorth_configure(void)
 
 	current_size = A_SIZE_32(agp_bridge->current_size);
 
-	printk(KERN_INFO PFX "configuring for size idx: %d\n",
-	       current_size->size_value);
+	dev_info(&agp_bridge->dev->dev, "configuring for size idx: %d\n",
+		 current_size->size_value);
 
 	/* aperture size and gatt addr */
 	pci_write_config_dword(agp_bridge->dev,
@@ -197,8 +197,9 @@ static int u3_insert_memory(struct agp_m
 	gp = (u32 *) &agp_bridge->gatt_table[pg_start];
 	for (i = 0; i < mem->page_count; ++i) {
 		if (gp[i]) {
-			printk("u3_insert_memory: entry 0x%x occupied (%x)\n",
-			       i, gp[i]);
+			dev_info(&agp_bridge->dev->dev,
+				 "u3_insert_memory: entry 0x%x occupied (%x)\n",
+				 i, gp[i]);
 			return -EBUSY;
 		}
 	}
@@ -276,8 +277,8 @@ static void uninorth_agp_enable(struct a
 				       &scratch);
 	} while ((scratch & PCI_AGP_COMMAND_AGP) == 0 && ++timeout < 1000);
 	if ((scratch & PCI_AGP_COMMAND_AGP) == 0)
-		printk(KERN_ERR PFX "failed to write UniNorth AGP"
-		       " command register\n");
+		dev_err(&bridge->dev->dev, "can't write UniNorth AGP "
+			"command register\n");
 
 	if (uninorth_rev >= 0x30) {
 		/* This is an AGP V3 */
@@ -330,8 +331,8 @@ static int agp_uninorth_suspend(struct p
 		pci_read_config_dword(device, agp + PCI_AGP_COMMAND, &cmd);
 		if (!(cmd & PCI_AGP_COMMAND_AGP))
 			continue;
-		printk("uninorth-agp: disabling AGP on device %s\n",
-				pci_name(device));
+		dev_info(&pdev->dev, "disabling AGP on device %s\n",
+			 pci_name(device));
 		cmd &= ~PCI_AGP_COMMAND_AGP;
 		pci_write_config_dword(device, agp + PCI_AGP_COMMAND, cmd);
 	}
@@ -341,8 +342,7 @@ static int agp_uninorth_suspend(struct p
 	pci_read_config_dword(pdev, agp + PCI_AGP_COMMAND, &cmd);
 	bridge->dev_private_data = (void *)(long)cmd;
 	if (cmd & PCI_AGP_COMMAND_AGP) {
-		printk("uninorth-agp: disabling AGP on bridge %s\n",
-				pci_name(pdev));
+		dev_info(&pdev->dev, "disabling AGP on bridge\n");
 		cmd &= ~PCI_AGP_COMMAND_AGP;
 		pci_write_config_dword(pdev, agp + PCI_AGP_COMMAND, cmd);
 	}
@@ -591,14 +591,14 @@ static int __devinit agp_uninorth_probe(
 	/* probe for known chipsets */
 	for (j = 0; devs[j].chipset_name != NULL; ++j) {
 		if (pdev->device == devs[j].device_id) {
-			printk(KERN_INFO PFX "Detected Apple %s chipset\n",
-			       devs[j].chipset_name);
+			dev_info(&pdev->dev, "Apple %s chipset\n",
+				 devs[j].chipset_name);
 			goto found;
 		}
 	}
 
-	printk(KERN_ERR PFX "Unsupported Apple chipset (device id: %04x).\n",
-		pdev->device);
+	dev_err(&pdev->dev, "unsupported Apple chipset [%04x/%04x]\n",
+		pdev->vendor, pdev->device);
 	return -ENODEV;
 
  found:
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

mm-only-enforce-acpi-resource-conflict-checks.patch
amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails.patch
agp-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

