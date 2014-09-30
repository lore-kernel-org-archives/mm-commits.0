From: akpm@linux-foundation.org
Subject: + watchdog-s3c2410-add-restart-handler.patch added to -mm tree
Date: Tue, 30 Sep 2014 14:18:30 -0700
Message-ID: <542b1e26.GEZtgcEpf2+48CYh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI3VSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, jonas.jensen@gmail.com, linux@arm.linux.org.uk, linux@roeck-us.net, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: s3c2410: add restart handler
has been added to the -mm tree.  Its filename is
     watchdog-s3c2410-add-restart-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-s3c2410-add-resta=
rt-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-s3c2410-add-resta=
rt-handler.patch

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
Subject: watchdog: s3c2410: add restart handler

On a lot of Samsung systems the watchdog is responsible for restarting =
the
system and until now this code was contained in plat-samsung/watchdog-r=
eset.c.

With the introduction of the restart handlers, this code can now move i=
nto
driver itself, removing the need for arch-specific code.

Tested on a S3C2442 based GTA02

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

 drivers/watchdog/s3c2410_wdt.c |   36 +++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-add-restart-h=
andler drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-add-restart-handl=
er
+++ a/drivers/watchdog/s3c2410_wdt.c
@@ -41,6 +41,8 @@
 #include <linux/of.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/reboot.h>
+#include <linux/delay.h>
=20
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -128,6 +130,7 @@ struct s3c2410_wdt {
 	unsigned long		wtdat_save;
 	struct watchdog_device	wdt_device;
 	struct notifier_block	freq_transition;
+	struct notifier_block	restart_handler;
 	struct s3c2410_wdt_variant *drv_data;
 	struct regmap *pmureg;
 };
@@ -449,6 +452,31 @@ static inline void s3c2410wdt_cpufreq_de
 }
 #endif
=20
+static int s3c2410wdt_restart(struct notifier_block *this,
+			      unsigned long mode, void *cmd)
+{
+	struct s3c2410_wdt *wdt =3D container_of(this, struct s3c2410_wdt,
+					       restart_handler);
+	void __iomem *wdt_base =3D wdt->reg_base;
+
+	/* disable watchdog, to be safe  */
+	writel(0, wdt_base + S3C2410_WTCON);
+
+	/* put initial values into count and data */
+	writel(0x80, wdt_base + S3C2410_WTCNT);
+	writel(0x80, wdt_base + S3C2410_WTDAT);
+
+	/* set the watchdog to go and reset... */
+	writel(S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV16 |
+		S3C2410_WTCON_RSTEN | S3C2410_WTCON_PRESCALE(0x20),
+		wdt_base + S3C2410_WTCON);
+
+	/* wait for reset to assert... */
+	mdelay(500);
+
+	return NOTIFY_DONE;
+}
+
 static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wd=
t *wdt)
 {
 	unsigned int rst_stat;
@@ -603,6 +631,12 @@ static int s3c2410wdt_probe(struct platf
=20
 	platform_set_drvdata(pdev, wdt);
=20
+	wdt->restart_handler.notifier_call =3D s3c2410wdt_restart;
+	wdt->restart_handler.priority =3D 128;
+	ret =3D register_restart_handler(&wdt->restart_handler);
+	if (ret)
+		pr_err("cannot register restart handler, %d\n", ret);
+
 	/* print out a statement of readiness */
=20
 	wtcon =3D readl(wdt->reg_base + S3C2410_WTCON);
@@ -632,6 +666,8 @@ static int s3c2410wdt_remove(struct plat
 	int ret;
 	struct s3c2410_wdt *wdt =3D platform_get_drvdata(dev);
=20
+	unregister_restart_handler(&wdt->restart_handler);
+
 	ret =3D s3c2410wdt_mask_and_disable_reset(wdt, true);
 	if (ret < 0)
 		return ret;
_

Patches currently in -mm which might be from heiko@sntech.de are

rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
