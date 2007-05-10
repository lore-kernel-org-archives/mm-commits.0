From: akpm@linux-foundation.org
Subject: + working-3d-dri-intel-agpko-resume-for-i815-chip-update.patch added to -mm tree
Date: Thu, 10 May 2007 00:42:10 -0700
Message-ID: <200705100742.l4A7gAgT015292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756905AbXEJHmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 03:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andim2@users.sourceforge.net, andi@lisas.de, davej@codemonkey.org.uk


The patch titled
     working-3d-dri-intel-agpko-resume-for-i815-chip update
has been added to the -mm tree.  Its filename is
     working-3d-dri-intel-agpko-resume-for-i815-chip-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: working-3d-dri-intel-agpko-resume-for-i815-chip update
From: Andreas Mohr <andim2@users.sourceforge.net>

working 3D/DRI intel-agp.ko resume for i815 chip cleanup patch:

- revert register define name change to ease backporting etc.
- shorten resume issues warning message to two lines while still preserving
  all required information (use many shorter words)

I'm not ultimately sure about the register define names, since there's
a general inconsistency in naming here which perhaps would be a good idea
to resolve (my original renaming happened to decrease inconsistency but didn't
quite get rid of it, so it was kind of useless to do it...).

The warning message, while definitely ugly (and that's its job ;), IMHO is
very important to make knowledgeable people see where the problem is.
Those people, if they experience issues, WILL look at kernel logs...

Splitting the remember_state function in two parts isn't very useful given
that it's supposed to be a temporary, "make it work at all" measure only
until there's generic save/restore support (I want to keep this "debug"
code at a minimum). Once there's further chipset data and/or information
how to implement this cleanly, I'm definitely interested in continuing that.

Run-tested on 2.6.21-mm2, resumes fine.

Signed-off-by: Andreas Mohr <andi@lisas.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   72 +++++++++++++++++----------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-update drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-update
+++ a/drivers/char/agp/intel-agp.c
@@ -32,15 +32,15 @@ extern int agp_memory_reserved;
 
 
 /* Intel i815 registers, see Intel spec #29068801 */
-#define I815_GMCHCFG		0x50
-#define I815_APCONT		0x51
-#define I815_UNKNOWN_80		0x80
-#define I815_ATTBASE_MASK	~0x1FFFFFFF
-#define I815_SM_RCOMP		0x98 /* Sys Mem R Compensation Ctrl */
-#define I815_SM			0x9c /* System Memory Control Reg */
-#define I815_AGPCMD		0xa8 /* AGP Command Register */
-#define I815_ERRSTS		0xc8 /* undocumented in i815 spec; since this one is modified on resume and many other related chipsets have it, I assume it *is* ERRSTS */
-#define I815_UNKNOWN_E8		0xe8
+#define INTEL_I815_GMCHCFG	0x50
+#define INTEL_I815_APCONT	0x51
+#define INTEL_I815_UNKNOWN_80	0x80
+#define INTEL_I815_ATTBASE_MASK	~0x1FFFFFFF
+#define INTEL_I815_SM_RCOMP	0x98 /* Sys Mem R Compensation Ctrl */
+#define INTEL_I815_SM		0x9c /* System Memory Control Reg */
+#define INTEL_I815_AGPCMD	0xa8 /* AGP Command Register */
+#define INTEL_I815_ERRSTS	0xc8 /* undocumented in i815 spec; since this one is modified on resume and many other related chipsets have it, I assume it *is* ERRSTS */
+#define INTEL_I815_UNKNOWN_E8	0xe8
 
 /* Intel i820 registers */
 #define INTEL_I820_RDCR		0x51
@@ -1110,7 +1110,7 @@ static int intel_815_configure(void)
 	/* attbase - aperture base */
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
-	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
+	if (agp_bridge->gatt_bus_addr & INTEL_I815_ATTBASE_MASK) {
 		printk (KERN_EMERG PFX "gatt bus addr too high\n");
 		return -EINVAL;
 	}
@@ -1126,7 +1126,7 @@ static int intel_815_configure(void)
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
-	addr &= I815_ATTBASE_MASK;
+	addr &= INTEL_I815_ATTBASE_MASK;
 	addr |= agp_bridge->gatt_bus_addr;
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
 
@@ -1134,8 +1134,8 @@ static int intel_815_configure(void)
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
 
 	/* apcont */
-	pci_read_config_byte(agp_bridge->dev, I815_APCONT, &temp2);
-	pci_write_config_byte(agp_bridge->dev, I815_APCONT, temp2 | (1 << 1));
+	pci_read_config_byte(agp_bridge->dev, INTEL_I815_APCONT, &temp2);
+	pci_write_config_byte(agp_bridge->dev, INTEL_I815_APCONT, temp2 | (1 << 1));
 
 	/* clear any possible error conditions */
 	/* Oddness : this chipset seems to have no ERRSTS register ! */
@@ -2018,7 +2018,6 @@ static void __devexit agp_intel_remove(s
 }
 
 #ifdef CONFIG_PM
-
 static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
 {
 	typedef struct {
@@ -2030,18 +2029,18 @@ static int agp_i815_remember_state(struc
 	 * to be able to successfully restore X11 when AGP 3D is enabled
 	 * (register values given are after resume vs. before suspend):
 	 *
-	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global
-	 *              Enable) of I815_APCONT (0x51),
-	 *              thus use I815_GMCHCFG (0x50) as 32bit base register);
+	 * INTEL_I815_GMCHCFG (0x50; we need to set bit 1
+	 * (Aperture Access Global Enable) of INTEL_I815_APCONT (0x51),
+	 *  thus use INTEL_I815_GMCHCFG (0x50) as 32bit base register);
 	 *              0x4fdd0040 instead of 0x4fdd0240
 	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
-	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
-	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
-	 * I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
+	 * INTEL_I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
+	 * INTEL_I815_SM (0x9c); 0x00c48405 instead of 0x04848405
+	 * INTEL_I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
 	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
 	 * INTEL_APSIZE (0xb4);
 	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
-	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above);
+	 * INTEL_I815_ERRSTS?? (0xc8; undocumented for i815, see above);
 	 *              0x00000000 instead of 0x00000800
 	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
 	 *
@@ -2049,23 +2048,23 @@ static int agp_i815_remember_state(struc
 	 * a different set of registers to be properly saved.
 	 */
 	static saved_regs i815_saved_regs[] = {
-		{ I815_UNKNOWN_80, 0 },
-		{ I815_GMCHCFG, 0 },
-		{ I815_SM_RCOMP, 0 },
-		{ I815_SM, 0 },
-		{ I815_AGPCMD, 0 },
+		{ INTEL_I815_UNKNOWN_80, 0 },
+		{ INTEL_I815_GMCHCFG, 0 },
+		{ INTEL_I815_SM_RCOMP, 0 },
+		{ INTEL_I815_SM, 0 },
+		{ INTEL_I815_AGPCMD, 0 },
 		{ INTEL_AGPCTRL, 0 },
 		{ INTEL_APSIZE, 0 },
 		{ INTEL_ATTBASE, 0 },
-		{ I815_ERRSTS, 0 },
-		{ I815_UNKNOWN_E8, 0 },
+		{ INTEL_I815_ERRSTS, 0 },
+		{ INTEL_I815_UNKNOWN_E8, 0 },
 		{ 0, 0 }, /* DELIMITER */
 	};
 	saved_regs *p;
 
 	if (restore) {
 		u32 val;
-		for (p = i815_saved_regs; (p->reg != 0); p++) {
+		for (p = i815_saved_regs; p->reg; p++) {
 			pci_read_config_dword(pdev, p->reg, &val);
 			if (val != p->value) {
 				printk(KERN_DEBUG "AGP: Writing back config "
@@ -2078,7 +2077,7 @@ static int agp_i815_remember_state(struc
 			}
 		}
 	} else {
-		for (p = i815_saved_regs; (p->reg != 0); p++)
+		for (p = i815_saved_regs; p->reg; p++)
 			pci_read_config_dword(pdev, p->reg, &p->value);
 	}
 	return 1;
@@ -2285,11 +2284,16 @@ static int __init agp_intel_init(void)
 {
 	if (agp_off)
 		return -EINVAL;
-	/* let people know that this is an important place to investigate at in case of resume lockups */
+
+	/* let people know that this is an important place to investigate at
+	 * in case of resume lockups.
+	 * Let's hope we'll be able to kill this message in mid-2008 or so
+	 * once all/most problematic Intel chipset cases have proper 3D resume
+	 * after users reported details.
+	 */
 	printk(KERN_INFO PFX
-		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n"
-		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) active,\n"
-		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to investigate)\n"
+		"suspend/resume problematic: resume with 3D/DRI active may lockup X.Org\n"
+		"on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)\n"
 	);
 	return pci_register_driver(&agp_intel_pci_driver);
 }
_

Patches currently in -mm which might be from andim2@users.sourceforge.net are

working-3d-dri-intel-agpko-resume-for-i815-chip-update.patch
