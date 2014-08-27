From: akpm@linux-foundation.org
Subject: + clk-rockchip-add-restart-handler.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:24:46 -0700
Message-ID: <53fe4c9e.cM5t/SiczbuX9f6e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36827 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0VYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:24:49 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so102948qcz.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:24:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, jonas.jensen@gmail.com, linux@arm.linux.org.uk, linux@roeck-us.net, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: rockchip: add restart handler
has been added to the -mm tree.  Its filename is
     clk-rockchip-add-restart-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clk-rockchip-add-restart-h=
andler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clk-rockchip-add-restart-h=
andler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -631,6 +631,8 @@ static void __init rk3188_common_clk_ini
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
@@ -713,5 +713,7 @@ static void __init rk3288_clk_init(struc
=20
 	rockchip_register_softrst(np, 9, reg_base + RK3288_SOFTRST_CON(0),
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
@@ -242,3 +243,27 @@ void __init rockchip_clk_register_branch
 		rockchip_clk_add_lookup(clk, list->id);
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
@@ -329,6 +329,7 @@ void rockchip_clk_register_branches(stru
 				    unsigned int nr_clk);
 void rockchip_clk_register_plls(struct rockchip_pll_clock *pll_list,
 				unsigned int nr_pll, int grf_lock_offset);
+void rockchip_register_restart_notifier(unsigned int reg);
=20
 #define ROCKCHIP_SOFTRST_HIWORD_MASK	BIT(0)
=20
_

Patches currently in -mm which might be from heiko@sntech.de are

kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.pa=
tch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.=
patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.pat=
ch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
