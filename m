From: akpm@linux-foundation.org
Subject: [obsolete]
 clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch removed from -mm tree
Date: Tue, 30 Sep 2014 15:33:11 -0700
Message-ID: <542b2fa7.PM1ygrSMeIwJCXTY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaI3WdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 18:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, jonas.jensen@gmail.com, linux@arm.linux.org.uk, linux@roeck-us.net, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, tomasz.figa@gmail.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: samsung: register restart handlers for s3c2412 and s=
3c2443
has been removed from the -mm tree.  Its filename was
     clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patc=
h

This patch was dropped because it is obsolete

------------------------------------------------------
=46rom: Heiko St=FCbner <heiko@sntech.de>
Subject: clk: samsung: register restart handlers for s3c2412 and s3c244=
3

S3C2412, S3C2443 and their derivatives contain a special software-reset
register in their system-controller.

Therefore register a restart handler for those.

Tested on a s3c2416-based board, s3c2412 compile-tested.

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

 drivers/clk/samsung/clk-s3c2412.c |   29 ++++++++++++++++++++++++++++
 drivers/clk/samsung/clk-s3c2443.c |   19 ++++++++++++++++++
 2 files changed, 48 insertions(+)

diff -puN drivers/clk/samsung/clk-s3c2412.c~clk-samsung-register-restar=
t-handlers-for-s3c2412-and-s3c2443 drivers/clk/samsung/clk-s3c2412.c
--- a/drivers/clk/samsung/clk-s3c2412.c~clk-samsung-register-restart-ha=
ndlers-for-s3c2412-and-s3c2443
+++ a/drivers/clk/samsung/clk-s3c2412.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
=20
 #include <dt-bindings/clock/s3c2412.h>
=20
@@ -26,6 +27,7 @@
 #define CLKCON		0x0c
 #define CLKDIVN		0x14
 #define CLKSRC		0x1c
+#define SWRST		0x30
=20
 /* list of PLLs to be registered */
 enum s3c2412_plls {
@@ -204,6 +206,28 @@ struct samsung_clock_alias s3c2412_alias
 	ALIAS(MSYSCLK, NULL, "fclk"),
 };
=20
+static int s3c2412_restart(struct notifier_block *this,
+			   unsigned long mode, void *cmd)
+{
+	/* errata "Watch-dog/Software Reset Problem" specifies that
+	 * this reset must be done with the SYSCLK sourced from
+	 * EXTCLK instead of FOUT to avoid a glitch in the reset
+	 * mechanism.
+	 *
+	 * See the watchdog section of the S3C2412 manual for more
+	 * information on this fix.
+	 */
+
+	__raw_writel(0x00, reg_base + CLKSRC);
+	__raw_writel(0x533C2412, reg_base + SWRST);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block s3c2412_restart_handler =3D {
+	.notifier_call =3D s3c2412_restart,
+	.priority =3D 129,
+};
+
 /*
  * fixed rate clocks generated outside the soc
  * Only necessary until the devicetree-move is complete
@@ -233,6 +257,7 @@ void __init s3c2412_common_clk_init(stru
 				    unsigned long ext_f, void __iomem *base)
 {
 	struct samsung_clk_provider *ctx;
+	int ret;
 	reg_base =3D base;
=20
 	if (np) {
@@ -267,6 +292,10 @@ void __init s3c2412_common_clk_init(stru
 	s3c2412_clk_sleep_init();
=20
 	samsung_clk_of_add_provider(np, ctx);
+
+	ret =3D register_restart_handler(&s3c2412_restart_handler);
+	if (ret)
+		pr_warn("cannot register restart handler, %d\n", ret);
 }
=20
 static void __init s3c2412_clk_init(struct device_node *np)
diff -puN drivers/clk/samsung/clk-s3c2443.c~clk-samsung-register-restar=
t-handlers-for-s3c2412-and-s3c2443 drivers/clk/samsung/clk-s3c2443.c
--- a/drivers/clk/samsung/clk-s3c2443.c~clk-samsung-register-restart-ha=
ndlers-for-s3c2412-and-s3c2443
+++ a/drivers/clk/samsung/clk-s3c2443.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
=20
 #include <dt-bindings/clock/s3c2443.h>
=20
@@ -33,6 +34,7 @@
 #define HCLKCON		0x30
 #define PCLKCON		0x34
 #define SCLKCON		0x38
+#define SWRST		0x44
=20
 /* the soc types */
 enum supported_socs {
@@ -354,6 +356,18 @@ struct samsung_clock_alias s3c2450_alias
 	ALIAS(PCLK_I2C1, "s3c2410-i2c.1", "i2c"),
 };
=20
+static int s3c2443_restart(struct notifier_block *this,
+			   unsigned long mode, void *cmd)
+{
+	__raw_writel(0x533c2443, reg_base + SWRST);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block s3c2443_restart_handler =3D {
+	.notifier_call =3D s3c2443_restart,
+	.priority =3D 129,
+};
+
 /*
  * fixed rate clocks generated outside the soc
  * Only necessary until the devicetree-move is complete
@@ -378,6 +392,7 @@ void __init s3c2443_common_clk_init(stru
 				    void __iomem *base)
 {
 	struct samsung_clk_provider *ctx;
+	int ret;
 	reg_base =3D base;
=20
 	if (np) {
@@ -447,6 +462,10 @@ void __init s3c2443_common_clk_init(stru
 	s3c2443_clk_sleep_init();
=20
 	samsung_clk_of_add_provider(np, ctx);
+
+	ret =3D register_restart_handler(&s3c2443_restart_handler);
+	if (ret)
+		pr_warn("cannot register restart handler, %d\n", ret);
 }
=20
 static void __init s3c2416_clk_init(struct device_node *np)
_

Patches currently in -mm which might be from heiko@sntech.de are

rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch
clk-rockchip-add-restart-handler.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
