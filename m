From: akpm@linux-foundation.org
Subject: + clk_register_clkdev-handle-callers-needing-format-string.patch
 added to -mm tree
Date: Mon, 27 Jul 2015 16:13:53 -0700
Message-ID: <55b6bb31.4Ss+MkB4Aibid76t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbG0XNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 19:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, linux@arm.linux.org.uk, mturquette@baylibre.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: clk_register_clkdev(): handle callers needing format string
has been added to the -mm tree.  Its filename is
     clk_register_clkdev-handle-callers-needing-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clk_register_clkdev-handle-callers-needing-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clk_register_clkdev-handle-callers-needing-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: clk_register_clkdev(): handle callers needing format string

Many callers either use NULL or const strings for the third argument of
clk_register_clkdev.  For those that do not, this is a risk for format
strings being accidentally processed (for example in device names).  This
adds the missing "%s" arguments to make sure format strings will not leak
into the clkdev.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-vexpress/spc.c                  |    2 +-
 arch/powerpc/platforms/512x/clock-commonclk.c |    4 ++--
 drivers/acpi/acpi_apd.c                       |    3 ++-
 drivers/acpi/acpi_lpss.c                      |    2 +-
 drivers/clk/clk-mb86s7x.c                     |    2 +-
 drivers/clk/clk-moxart.c                      |    4 ++--
 drivers/clk/samsung/clk-pll.c                 |    2 +-
 drivers/clk/samsung/clk.c                     |    9 +++++----
 drivers/clk/tegra/clk-tegra-pmc.c             |    2 +-
 drivers/clk/tegra/clk.c                       |    2 +-
 10 files changed, 17 insertions(+), 15 deletions(-)

diff -puN arch/arm/mach-vexpress/spc.c~clk_register_clkdev-handle-callers-needing-format-string arch/arm/mach-vexpress/spc.c
--- a/arch/arm/mach-vexpress/spc.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/arch/arm/mach-vexpress/spc.c
@@ -577,7 +577,7 @@ static int __init ve_spc_clk_init(void)
 			pr_warn("failed to register cpu%d clock\n", cpu);
 			continue;
 		}
-		if (clk_register_clkdev(clk, NULL, dev_name(cpu_dev))) {
+		if (clk_register_clkdev(clk, NULL, "%s", dev_name(cpu_dev))) {
 			pr_warn("failed to register cpu%d clock lookup\n", cpu);
 			continue;
 		}
diff -puN arch/powerpc/platforms/512x/clock-commonclk.c~clk_register_clkdev-handle-callers-needing-format-string arch/powerpc/platforms/512x/clock-commonclk.c
--- a/arch/powerpc/platforms/512x/clock-commonclk.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/arch/powerpc/platforms/512x/clock-commonclk.c
@@ -992,9 +992,9 @@ static void mpc5121_clk_provide_migratio
 	clk = of_clk_get_by_name(np, clkname); \
 	if (IS_ERR(clk)) { \
 		clk = clkitem; \
-		clk_register_clkdev(clk, clkname, devname); \
+		clk_register_clkdev(clk, clkname, "%s", devname); \
 		if (regnode) \
-			clk_register_clkdev(clk, clkname, np->name); \
+			clk_register_clkdev(clk, clkname, "%s", np->name); \
 		did_register |= DID_REG_ ## regflag; \
 		pr_debug("clock alias name '%s' for dev '%s' pointer %p\n", \
 			 clkname, devname, clk); \
diff -puN drivers/acpi/acpi_apd.c~clk_register_clkdev-handle-callers-needing-format-string drivers/acpi/acpi_apd.c
--- a/drivers/acpi/acpi_apd.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/acpi/acpi_apd.c
@@ -65,7 +65,8 @@ static int acpi_apd_setup(struct apd_pri
 					dev_name(&pdata->adev->dev),
 					NULL, CLK_IS_ROOT,
 					dev_desc->fixed_clk_rate);
-		clk_register_clkdev(clk, NULL, dev_name(&pdata->adev->dev));
+		clk_register_clkdev(clk, NULL, "%s",
+				    dev_name(&pdata->adev->dev));
 		pdata->clk = clk;
 	}
 
diff -puN drivers/acpi/acpi_lpss.c~clk_register_clkdev-handle-callers-needing-format-string drivers/acpi/acpi_lpss.c
--- a/drivers/acpi/acpi_lpss.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/acpi/acpi_lpss.c
@@ -316,7 +316,7 @@ out:
 		return PTR_ERR(clk);
 
 	pdata->clk = clk;
-	clk_register_clkdev(clk, dev_desc->clk_con_id, devname);
+	clk_register_clkdev(clk, dev_desc->clk_con_id, "%s", devname);
 	return 0;
 }
 
diff -puN drivers/clk/clk-mb86s7x.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/clk-mb86s7x.c
--- a/drivers/clk/clk-mb86s7x.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/clk-mb86s7x.c
@@ -370,7 +370,7 @@ static int mb86s7x_clclk_of_init(void)
 			pr_err("failed to register cpu%d clock\n", cpu);
 			continue;
 		}
-		if (clk_register_clkdev(clk, NULL, dev_name(cpu_dev))) {
+		if (clk_register_clkdev(clk, NULL, "%s", dev_name(cpu_dev))) {
 			pr_err("failed to register cpu%d clock lookup\n", cpu);
 			continue;
 		}
diff -puN drivers/clk/clk-moxart.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/clk-moxart.c
--- a/drivers/clk/clk-moxart.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/clk-moxart.c
@@ -47,7 +47,7 @@ static void __init moxart_of_pll_clk_ini
 		return;
 	}
 
-	clk_register_clkdev(clk, NULL, name);
+	clk_register_clkdev(clk, NULL, "%s", name);
 	of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
 CLK_OF_DECLARE(moxart_pll_clock, "moxa,moxart-pll-clock",
@@ -90,7 +90,7 @@ static void __init moxart_of_apb_clk_ini
 		return;
 	}
 
-	clk_register_clkdev(clk, NULL, name);
+	clk_register_clkdev(clk, NULL, "%s", name);
 	of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
 CLK_OF_DECLARE(moxart_apb_clock, "moxa,moxart-apb-clock",
diff -puN drivers/clk/samsung/clk-pll.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/samsung/clk-pll.c
--- a/drivers/clk/samsung/clk-pll.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/samsung/clk-pll.c
@@ -1296,7 +1296,7 @@ static void __init _samsung_clk_register
 	if (!pll_clk->alias)
 		return;
 
-	ret = clk_register_clkdev(clk, pll_clk->alias, pll_clk->dev_name);
+	ret = clk_register_clkdev(clk, pll_clk->alias, "%s", pll_clk->dev_name);
 	if (ret)
 		pr_err("%s: failed to register lookup for %s : %d",
 			__func__, pll_clk->name, ret);
diff -puN drivers/clk/samsung/clk.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/samsung/clk.c
--- a/drivers/clk/samsung/clk.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/samsung/clk.c
@@ -123,7 +123,8 @@ void __init samsung_clk_register_alias(s
 			continue;
 		}
 
-		ret = clk_register_clkdev(clk, list->alias, list->dev_name);
+		ret = clk_register_clkdev(clk, list->alias, "%s",
+					  list->dev_name);
 		if (ret)
 			pr_err("%s: failed to register lookup %s\n",
 					__func__, list->alias);
@@ -203,7 +204,7 @@ void __init samsung_clk_register_mux(str
 
 		/* register a clock lookup only if a clock alias is specified */
 		if (list->alias) {
-			ret = clk_register_clkdev(clk, list->alias,
+			ret = clk_register_clkdev(clk, list->alias, "%s",
 						list->dev_name);
 			if (ret)
 				pr_err("%s: failed to register lookup %s\n",
@@ -242,7 +243,7 @@ void __init samsung_clk_register_div(str
 
 		/* register a clock lookup only if a clock alias is specified */
 		if (list->alias) {
-			ret = clk_register_clkdev(clk, list->alias,
+			ret = clk_register_clkdev(clk, list->alias, "%s",
 						list->dev_name);
 			if (ret)
 				pr_err("%s: failed to register lookup %s\n",
@@ -271,7 +272,7 @@ void __init samsung_clk_register_gate(st
 
 		/* register a clock lookup only if a clock alias is specified */
 		if (list->alias) {
-			ret = clk_register_clkdev(clk, list->alias,
+			ret = clk_register_clkdev(clk, list->alias, "%s",
 							list->dev_name);
 			if (ret)
 				pr_err("%s: failed to register lookup %s\n",
diff -puN drivers/clk/tegra/clk-tegra-pmc.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/tegra/clk-tegra-pmc.c
--- a/drivers/clk/tegra/clk-tegra-pmc.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/tegra/clk-tegra-pmc.c
@@ -110,7 +110,7 @@ void __init tegra_pmc_clk_init(void __io
 					0, pmc_base + PMC_CLK_OUT_CNTRL,
 					data->gate_shift, 0, &clk_out_lock);
 		*dt_clk = clk;
-		clk_register_clkdev(clk, data->dev_name, data->gate_name);
+		clk_register_clkdev(clk, data->dev_name, "%s", data->gate_name);
 	}
 
 	/* blink */
diff -puN drivers/clk/tegra/clk.c~clk_register_clkdev-handle-callers-needing-format-string drivers/clk/tegra/clk.c
--- a/drivers/clk/tegra/clk.c~clk_register_clkdev-handle-callers-needing-format-string
+++ a/drivers/clk/tegra/clk.c
@@ -296,7 +296,7 @@ void __init tegra_register_devclks(struc
 
 	for (i = 0; i < num; i++, dev_clks++)
 		clk_register_clkdev(clks[dev_clks->dt_id], dev_clks->con_id,
-				dev_clks->dev_id);
+				"%s", dev_clks->dev_id);
 
 	for (i = 0; i < clk_num; i++) {
 		if (!IS_ERR_OR_NULL(clks[i]))
_

Patches currently in -mm which might be from keescook@chromium.org are

capabilities-ambient-capabilities.patch
capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
clk_register_clkdev-handle-callers-needing-format-string.patch
scripts-spellingtxt-adding-misspelled-word-for-check.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
lib-vsprintf-add-%pt-format-specifier.patch
lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch
sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch
linux-next.patch

