From: akpm@linux-foundation.org
Subject: [obsolete] clk-rockchip-add-restart-handler.patch removed from
 -mm tree
Date: Tue, 30 Sep 2014 15:33:13 -0700
Message-ID: <542b2fa9.G0tGJ/jCOyj0HGD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaI3WdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 18:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, jonas.jensen@gmail.com, linux@arm.linux.org.uk, linux@roeck-us.net, maxime.ripard@free-electrons.com, mingo@kernel.org, mturquette@linaro.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, tomasz.figa@gmail.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: rockchip: add restart handler
has been removed from the -mm tree.  Its filename was
     clk-rockchip-add-restart-handler.patch

This patch was dropped because it is obsolete

------------------------------------------------------
=46rom: Heiko St=FCbner <heiko@sntech.de>
Subject: clk: rockchip: add restart handler

Add infrastructure to write the correct value to the restart register a=
nd
register the restart notifier for both rk3188 (including rk3066) and rk=
3288.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/rockchip/clk-rk3188.c |    2 ++
 drivers/clk/rockchip/clk-rk3288.c |    2 ++
 drivers/clk/rockchip/clk.c        |   25 +++++++++++++++++++++++++
 drivers/clk/rockchip/clk.h        |    1 +
 4 files changed, 30 insertions(+)

diff -puN drivers/clk/rockchip/clk-rk3188.c~clk-rockchip-add-restart-ha=
ndler drivers/clk/rockchip/clk-rk3188.c
--- a/drivers/clk/rockchip/clk-rk3188.c~clk-rockchip-add-restart-handle=
r
+++ a/drivers/clk/rockchip/clk-rk3188.c
@@ -735,6 +735,8 @@ static void __init rk3188_common_clk_ini
=20
 	rockchip_register_softrst(np, 9, reg_base + RK2928_SOFTRST_CON(0),
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
+
+	rockchip_register_restart_notifier(RK2928_GLB_SRST_FST);
 }
=20
 static void __init rk3066a_clk_init(struct device_node *np)
diff -puN drivers/clk/rockchip/clk-rk3288.c~clk-rockchip-add-restart-ha=
ndler drivers/clk/rockchip/clk-rk3288.c
--- a/drivers/clk/rockchip/clk-rk3288.c~clk-rockchip-add-restart-handle=
r
+++ a/drivers/clk/rockchip/clk-rk3288.c
@@ -808,5 +808,7 @@ static void __init rk3288_clk_init(struc
=20
 	rockchip_register_softrst(np, 12, reg_base + RK3288_SOFTRST_CON(0),
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
+
+	rockchip_register_restart_notifier(RK3288_GLB_SRST_FST);
 }
 CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);
diff -puN drivers/clk/rockchip/clk.c~clk-rockchip-add-restart-handler d=
rivers/clk/rockchip/clk.c
--- a/drivers/clk/rockchip/clk.c~clk-rockchip-add-restart-handler
+++ a/drivers/clk/rockchip/clk.c
@@ -25,6 +25,7 @@
 #include <linux/clk-provider.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/reboot.h>
 #include "clk.h"
=20
 /**
@@ -330,3 +331,27 @@ void __init rockchip_clk_protect_critica
 			clk_prepare_enable(clk);
 	}
 }
+
+static unsigned int reg_restart;
+static int rockchip_restart_notify(struct notifier_block *this,
+				   unsigned long mode, void *cmd)
+{
+	writel(0xfdb9, reg_base + reg_restart);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rockchip_restart_handler =3D {
+	.notifier_call =3D rockchip_restart_notify,
+	.priority =3D 128,
+};
+
+void __init rockchip_register_restart_notifier(unsigned int reg)
+{
+	int ret;
+
+	reg_restart =3D reg;
+	ret =3D register_restart_handler(&rockchip_restart_handler);
+	if (ret)
+		pr_err("%s: cannot register restart handler, %d\n",
+		       __func__, ret);
+}
diff -puN drivers/clk/rockchip/clk.h~clk-rockchip-add-restart-handler d=
rivers/clk/rockchip/clk.h
--- a/drivers/clk/rockchip/clk.h~clk-rockchip-add-restart-handler
+++ a/drivers/clk/rockchip/clk.h
@@ -366,6 +366,7 @@ void rockchip_clk_register_armclk(unsign
 			const struct rockchip_cpuclk_reg_data *reg_data,
 			const struct rockchip_cpuclk_rate_table *rates,
 			int nrates);
+void rockchip_register_restart_notifier(unsigned int reg);
 void rockchip_clk_protect_critical(const char *clocks[], int nclocks);
=20
 #define ROCKCHIP_SOFTRST_HIWORD_MASK	BIT(0)
_

Patches currently in -mm which might be from heiko@sntech.de are

rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
