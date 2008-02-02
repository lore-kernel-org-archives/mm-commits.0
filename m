From: akpm@linux-foundation.org
Subject: - working-3d-dri-intel-agpko-resume-for-i815-chip.patch removed from -mm tree
Date: Fri, 01 Feb 2008 16:02:38 -0800
Message-ID: <200802020011.m120BL2F006477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757900AbYBBALo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 19:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@rhlx01.fht-esslingen.de, airlied@linux.ie, andi@lisas.de, davej@codemonkey.org.uk, mjg59@srcf.ucam.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     working 3D/DRI intel-agp.ko resume for i815 chip
has been removed from the -mm tree.  Its filename was
     working-3d-dri-intel-agpko-resume-for-i815-chip.patch

This patch was dropped because maintainer somnolence

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: working 3D/DRI intel-agp.ko resume for i815 chip
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>

- add .suspend handler and pci_set_power_state() calls
- add i815-specific function agp_i815_remember_state() to remember important
  i815 register values
- add generic DEBUG_AGP_PM framework which will allow people to resume properly
  and help identify which registers need attention
- add obvious and detailed log message to make people sit up and take notice
  about long-standing AGP resume issues
- spelling fixes

My Inspiron 8000 (i815 with Radeon AGP card, internal Intel VGA unit NOT
active) resumes fine with both either i815-specific register saving or
generic DEBUG_AGP_PM mechanism enabled.  (of course my notebook needs
vbetool post and manual saving of video card PCI space, too, but even when
doing all this I still had X.org lockups before whenever DRI/3D was
enabled)

After resume I'm now still able to run both glxgears and glxinfo without
anomalies.

Right now all I care about is that this gets into mainline relatively soon,
since I'm rather certain that many other machines suffer from similar AGP
resume lockup issues that could be debugged this way (e.g.  some Thinkpads,
as witnessed accidentally via IRC chats, and from the well-known "don't
enable DRI, that will lock up on resume!" chants).

Yes, this code is a cludge and somewhat far from a nicely generic extended
PCI space resume framework, but we've spent almost 10 (TEN!) years without
anything even remotely resembling a working cludge for AGP suspend/resume
in combination with DRI, so...

Feel free to offer thoughts on how this missing generic extended PCI space

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Andreas Mohr <andi@lisas.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>

Davej says "I think this needs to redone in a much more generic manner before
it goes mainline."
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |  211 +++++++++++++++++++++++++++++++--
 1 file changed, 200 insertions(+), 11 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip
+++ a/drivers/char/agp/intel-agp.c
@@ -58,9 +58,16 @@
 extern int agp_memory_reserved;
 
 
-/* Intel 815 register */
-#define INTEL_815_APCONT	0x51
-#define INTEL_815_ATTBASE_MASK	~0x1FFFFFFF
+/* Intel i815 registers, see Intel spec #29068801 */
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
@@ -773,7 +780,7 @@ static int intel_i830_insert_entries(str
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
 
-	/* The i830 can't check the GTT for entries since its read only,
+	/* The i830 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
 
@@ -1000,7 +1007,7 @@ static int intel_i915_insert_entries(str
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
 
-	/* The i915 can't check the GTT for entries since its read only,
+	/* The i915 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
 
@@ -1329,7 +1336,7 @@ static int intel_815_configure(void)
 	/* attbase - aperture base */
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
-	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
+	if (agp_bridge->gatt_bus_addr & INTEL_I815_ATTBASE_MASK) {
 		printk(KERN_EMERG PFX "gatt bus addr too high");
 		return -EINVAL;
 	}
@@ -1345,7 +1352,7 @@ static int intel_815_configure(void)
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
-	addr &= INTEL_815_ATTBASE_MASK;
+	addr &= INTEL_I815_ATTBASE_MASK;
 	addr |= agp_bridge->gatt_bus_addr;
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
 
@@ -1353,8 +1360,8 @@ static int intel_815_configure(void)
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
 
 	/* apcont */
-	pci_read_config_byte(agp_bridge->dev, INTEL_815_APCONT, &temp2);
-	pci_write_config_byte(agp_bridge->dev, INTEL_815_APCONT, temp2 | (1 << 1));
+	pci_read_config_byte(agp_bridge->dev, INTEL_I815_APCONT, &temp2);
+	pci_write_config_byte(agp_bridge->dev, INTEL_I815_APCONT, temp2 | (1 << 1));
 
 	/* clear any possible error conditions */
 	/* Oddness : this chipset seems to have no ERRSTS register ! */
@@ -1583,7 +1590,7 @@ static int intel_7505_configure(void)
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
 
 	/* agpctrl */
-	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
+	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x00000000);
 
 	/* mchcfg */
 	pci_read_config_word(agp_bridge->dev, INTEL_I7505_MCHCFG, &temp2);
@@ -2180,12 +2187,180 @@ static void __devexit agp_intel_remove(s
 }
 
 #ifdef CONFIG_PM
+static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
+{
+	typedef struct {
+		int reg;
+		u32 value;
+	} saved_regs;
+
+	/* Dell Inspiron 8000 BIOS rev. A23 needs the following registers saved
+	 * to be able to successfully restore X11 when AGP 3D is enabled
+	 * (register values given are after resume vs. before suspend):
+	 *
+	 * INTEL_I815_GMCHCFG (0x50; we need to set bit 1
+	 * (Aperture Access Global Enable) of INTEL_I815_APCONT (0x51),
+	 *  thus use INTEL_I815_GMCHCFG (0x50) as 32bit base register);
+	 *              0x4fdd0040 instead of 0x4fdd0240
+	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
+	 * INTEL_I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
+	 * INTEL_I815_SM (0x9c); 0x00c48405 instead of 0x04848405
+	 * INTEL_I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
+	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
+	 * INTEL_APSIZE (0xb4);
+	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
+	 * INTEL_I815_ERRSTS?? (0xc8; undocumented for i815, see above);
+	 *              0x00000000 instead of 0x00000800
+	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
+	 *
+	 * Other machines/chipsets/BIOS versions may require
+	 * a different set of registers to be properly saved.
+	 */
+	static saved_regs i815_saved_regs[] = {
+		{ INTEL_I815_UNKNOWN_80, 0 },
+		{ INTEL_I815_GMCHCFG, 0 },
+		{ INTEL_I815_SM_RCOMP, 0 },
+		{ INTEL_I815_SM, 0 },
+		{ INTEL_I815_AGPCMD, 0 },
+		{ INTEL_AGPCTRL, 0 },
+		{ INTEL_APSIZE, 0 },
+		{ INTEL_ATTBASE, 0 },
+		{ INTEL_I815_ERRSTS, 0 },
+		{ INTEL_I815_UNKNOWN_E8, 0 },
+		{ 0, 0 }, /* DELIMITER */
+	};
+	saved_regs *p;
+
+	if (restore) {
+		u32 val;
+		for (p = i815_saved_regs; p->reg; p++) {
+			pci_read_config_dword(pdev, p->reg, &val);
+			if (val != p->value) {
+				printk(KERN_DEBUG "AGP: Writing back config "
+					"space on device %s at offset %x (was "
+					"%x, writing %x)\n",
+					pci_name(pdev), p->reg,
+					val, p->value);
+				pci_write_config_dword(pdev, p->reg,
+					p->value);
+			}
+		}
+	} else {
+		for (p = i815_saved_regs; p->reg; p++)
+			pci_read_config_dword(pdev, p->reg, &p->value);
+	}
+	return 1;
+}
+
+/*
+ * set DEBUG_AGP_PM to 1 if your AGP chipset has issues resuming
+ * (machine lockups due to non-restored hardware registered values),
+ * then figure out from the log which registers have to be restored manually,
+ * then add specific support for your chipset, similar to what already exists
+ * for i815 (Dell Inspiron) above.
+ * E.g. IBM X31 (i855PM) seems to still have intel-agp suspend issues, too.
+ *
+ * Once it's obvious which chipsets need which treatment
+ * (this is an important step to gain knowledge about all chipsets!)
+ * this stop-gap code handling (we need something that works NOW,
+ * since we could have had it almost a decade ago already!)
+ * should be cleaned up, probably by implementing a generic Linux
+ * PCI function to save/restore extended PCI config space
+ * by supplying a register array or so...
+ * At this point, it would also be nice to clean up the _suspend()/_resume()
+ * functions to use some non-ugly and nicely generic restore mechanism.
+ */
+#define DEBUG_AGP_PM 0
+
+#if DEBUG_AGP_PM
+static u32 pci_cfg_space[64];
+
+static void agp_intel_suspend_debug(struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+	for (i = 63; i >= 0; i--)
+		pci_read_config_dword(pdev, i * 4, &pci_cfg_space[i]);
+}
+
+static void agp_intel_resume_debug(struct pci_dev *pdev)
+{
+	int i;
+	int val;
+
+	/* Try first reading main PCI config space, then extended space;
+	 * this order should hopefully prevent any lockups that may easily
+	 * occur otherwise.
+	 */
+	for (i = 15; i >= 0; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			/* Who the *** decided (in PM code) that logging
+			 * register offsets in very weird offset notation
+			 * (extremely uncommon in PCI datasheet spheres) was a good idea?
+			 * Fixing this in this AGP-specific log message by multiplying offsets
+			 */
+			int reg = i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+	for (i = 63; i >= 16; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val != pci_cfg_space[i]) {
+			int reg = i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+}
+#else
+static inline void agp_intel_suspend_debug(struct pci_dev *pdev, pm_message_t state) { }
+static inline void agp_intel_resume_debug(struct pci_dev *pdev) { }
+#endif /* DEBUG_AGP_PM */
+
+
+static int agp_intel_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
+
+	if (bridge->driver == &intel_815_driver)
+		agp_i815_remember_state(pdev, 0);
+
+	agp_intel_suspend_debug(pdev, state);
+
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 
+	/* This ought to be enough meat in here to let us
+	 * resume successfully, at least when also being helped
+	 * by additional manual /sys/bus/pci/DEVICE recovering
+	 * of the graphics card and "vbetool post"
+	 * (the s2ram tool should do this nicely already)
+	 */
+
+	pci_set_power_state (pdev, PCI_D0);
 	pci_restore_state(pdev);
 
+	agp_intel_resume_debug(pdev);
+
+	if (bridge->driver == &intel_815_driver)
+		agp_i815_remember_state(pdev, 1);
+
 	/* We should restore our graphics device's config space,
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
@@ -2205,6 +2380,8 @@ static int agp_intel_resume(struct pci_d
 		intel_i915_configure();
 	else if (bridge->driver == &intel_830_driver)
 		intel_i830_configure();
+	/* Please no entry for i815 here since it already has
+	 * specific resume support above */
 	else if (bridge->driver == &intel_810_driver)
 		intel_i810_configure();
 	else if (bridge->driver == &intel_i965_driver)
@@ -2212,7 +2389,7 @@ static int agp_intel_resume(struct pci_d
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_PM */
 
 static struct pci_device_id agp_intel_pci_table[] = {
 #define ID(x)						\
@@ -2272,6 +2449,7 @@ static struct pci_driver agp_intel_pci_d
 	.probe		= agp_intel_probe,
 	.remove		= __devexit_p(agp_intel_remove),
 #ifdef CONFIG_PM
+	.suspend	= agp_intel_suspend,
 	.resume		= agp_intel_resume,
 #endif
 };
@@ -2280,6 +2458,17 @@ static int __init agp_intel_init(void)
 {
 	if (agp_off)
 		return -EINVAL;
+
+	/* let people know that this is an important place to investigate at
+	 * in case of resume lockups.
+	 * Let's hope we'll be able to kill this message in mid-2008 or so
+	 * once all/most problematic Intel chipset cases have proper 3D resume
+	 * after users reported details.
+	 */
+	printk(KERN_INFO PFX
+		"suspend/resume problematic: resume with 3D/DRI active may lockup X.Org\n"
+		"on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)\n"
+	);
 	return pci_register_driver(&agp_intel_pci_driver);
 }
 
_

Patches currently in -mm which might be from andi@rhlx01.fht-esslingen.de are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
