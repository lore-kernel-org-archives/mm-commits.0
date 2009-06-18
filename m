From: akpm@linux-foundation.org
Subject: [merged] edac-cpc925-mc-platform-device-setup.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:53 -0700
Message-ID: <200906182247.n5IMlrEf006988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717AbZFRWsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     edac: cpc925 MC platform device setup
has been removed from the -mm tree.  Its filename was
     edac-cpc925-mc-platform-device-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: cpc925 MC platform device setup
From: Harry Ciao <qingtao.cao@windriver.com>

Fix up the number of cells for the values of CPC925 Memory Controller,
and setup related platform device during system booting up, against
which CPC925 Memory Controller EDAC driver would be matched.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_init.c      |   40 ++++++++++++++++
 arch/powerpc/platforms/maple/setup.c |   59 +++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN arch/powerpc/kernel/prom_init.c~edac-cpc925-mc-platform-device-setup arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~edac-cpc925-mc-platform-device-setup
+++ a/arch/powerpc/kernel/prom_init.c
@@ -1947,8 +1947,47 @@ static void __init fixup_device_tree_map
 	prom_setprop(isa, name, "ranges",
 			isa_ranges, sizeof(isa_ranges));
 }
+
+#define CPC925_MC_START		0xf8000000
+#define CPC925_MC_LENGTH	0x1000000
+/* The values for memory-controller don't have right number of cells */
+static void __init fixup_device_tree_maple_memory_controller(void)
+{
+	phandle mc;
+	u32 mc_reg[4];
+	char *name = "/hostbridge@f8000000";
+	struct prom_t *_prom = &RELOC(prom);
+	u32 ac, sc;
+
+	mc = call_prom("finddevice", 1, 1, ADDR(name));
+	if (!PHANDLE_VALID(mc))
+		return;
+
+	if (prom_getproplen(mc, "reg") != 8)
+		return;
+
+	prom_getprop(_prom->root, "#address-cells", &ac, sizeof(ac));
+	prom_getprop(_prom->root, "#size-cells", &sc, sizeof(sc));
+	if ((ac != 2) || (sc != 2))
+		return;
+
+	if (prom_getprop(mc, "reg", mc_reg, sizeof(mc_reg)) == PROM_ERROR)
+		return;
+
+	if (mc_reg[0] != CPC925_MC_START || mc_reg[1] != CPC925_MC_LENGTH)
+		return;
+
+	prom_printf("Fixing up bogus hostbridge on Maple...\n");
+
+	mc_reg[0] = 0x0;
+	mc_reg[1] = CPC925_MC_START;
+	mc_reg[2] = 0x0;
+	mc_reg[3] = CPC925_MC_LENGTH;
+	prom_setprop(mc, name, "reg", mc_reg, sizeof(mc_reg));
+}
 #else
 #define fixup_device_tree_maple()
+#define fixup_device_tree_maple_memory_controller()
 #endif
 
 #ifdef CONFIG_PPC_CHRP
@@ -2189,6 +2228,7 @@ static void __init fixup_device_tree_efi
 static void __init fixup_device_tree(void)
 {
 	fixup_device_tree_maple();
+	fixup_device_tree_maple_memory_controller();
 	fixup_device_tree_chrp();
 	fixup_device_tree_pmac();
 	fixup_device_tree_efika();
diff -puN arch/powerpc/platforms/maple/setup.c~edac-cpc925-mc-platform-device-setup arch/powerpc/platforms/maple/setup.c
--- a/arch/powerpc/platforms/maple/setup.c~edac-cpc925-mc-platform-device-setup
+++ a/arch/powerpc/platforms/maple/setup.c
@@ -335,3 +335,62 @@ define_machine(maple) {
 	.progress		= maple_progress,
 	.power_save		= power4_idle,
 };
+
+#ifdef CONFIG_EDAC
+/*
+ * Register a platform device for CPC925 memory controller on
+ * Motorola ATCA-6101 blade.
+ */
+#define MAPLE_CPC925_MODEL	"Motorola,ATCA-6101"
+static int __init maple_cpc925_edac_setup(void)
+{
+	struct platform_device *pdev;
+	struct device_node *np = NULL;
+	struct resource r;
+	const unsigned char *model;
+	int ret;
+
+	np = of_find_node_by_path("/");
+	if (!np) {
+		printk(KERN_ERR "%s: Unable to get root node\n", __func__);
+		return -ENODEV;
+	}
+
+	model = (const unsigned char *)of_get_property(np, "model", NULL);
+	if (!model) {
+		printk(KERN_ERR "%s: Unabel to get model info\n", __func__);
+		return -ENODEV;
+	}
+
+	ret = strcmp(model, MAPLE_CPC925_MODEL);
+	of_node_put(np);
+
+	if (ret != 0)
+		return 0;
+
+	np = of_find_node_by_type(NULL, "memory-controller");
+	if (!np) {
+		printk(KERN_ERR "%s: Unable to find memory-controller node\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	of_node_put(np);
+
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Unable to get memory-controller reg\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	pdev = platform_device_register_simple("cpc925_edac", 0, &r, 1);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	printk(KERN_INFO "%s: CPC925 platform device created\n", __func__);
+
+	return 0;
+}
+machine_device_initcall(maple, maple_cpc925_edac_setup);
+#endif
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch

