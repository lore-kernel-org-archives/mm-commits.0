From: akpm@linux-foundation.org
Subject: + format-security-move-static-strings-to-const.patch added to -mm tree
Date: Wed, 05 Apr 2017 15:05:10 -0700
Message-ID: <58e56a16.ENH6FMnAgDDs32VT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbdDEWFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2017 18:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a@unstable.cc, airlied@linux.ie, andrey.shvetsov@k2l.de, arnd@arndb.de, christian.gromm@microchip.com, colin.king@canonical.com, daniel.vetter@intel.com, davem@davemloft.net, dmitry.torokhov@gmail.com, edumazet@google.com, felipe.balbi@linux.intel.com, fw@strlen.de, gregkh@linuxfoundation.org, huangdaode@hisilicon.com, james.hogan@imgtec.com, jani.nikula@linux.intel.com, jarod@redhat.com, jes@trained-monkey.org, jlitzingerdev@gmail.com, jslaby@suse.com, linux@armlinux.org.uk, linux@rasmusvillemoes.dk, macro@linux-mips.org, matt.redfearn@imgtec.com, mingo@kernel.org, mugunthanvnm@ti.com, patrice.chotard@st.com, paul.burton@imgtec.com, pbonzini@redhat.com, ralf@linux-mips.org, rjw@rjwysocki.net, salil.mehta@huawei.com, seanpaul@chromium.org, tony@atomid


The patch titled
     Subject: format-security: move static strings to const
has been added to the -mm tree.  Its filename is
     format-security-move-static-strings-to-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/format-security-move-static-strings-to-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/format-security-move-static-strings-to-const.patch

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
Subject: format-security: move static strings to const

While examining output from trial builds with -Wformat-security enabled,
many strings were found that should be defined as "const", or as a char
array instead of char pointer.  This makes some static analysis easier, by
producing fewer false positives.

As these are all trivial changes, it seemed best to put them all in a
single patch rather than chopping them up per maintainer.

Link: http://lkml.kernel.org/r/20170405214711.GA5711@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kejian Yan <yankejian@huawei.com>
Cc: Daode Huang <huangdaode@hisilicon.com>
Cc: Qianqian Xie <xieqianqian@huawei.com>
Cc: Philippe Reynes <tremyfr@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Andrey Shvetsov <andrey.shvetsov@k2l.de>
Cc: Jason Litzinger <jlitzingerdev@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-n8x0.c                  |    2 +-
 arch/mips/dec/prom/init.c                         |    6 +++---
 arch/mips/kernel/traps.c                          |    4 ++--
 drivers/char/dsp56k.c                             |    2 +-
 drivers/cpufreq/powernow-k8.c                     |    3 ++-
 drivers/gpu/drm/drm_fb_helper.c                   |    2 +-
 drivers/net/ethernet/amd/atarilance.c             |    4 ++--
 drivers/net/ethernet/amd/declance.c               |    2 +-
 drivers/net/ethernet/amd/sun3lance.c              |    3 ++-
 drivers/net/ethernet/cirrus/mac89x0.c             |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h |    2 +-
 drivers/net/ethernet/natsemi/sonic.h              |    2 +-
 drivers/net/ethernet/toshiba/tc35815.c            |    2 +-
 drivers/net/fddi/defxx.c                          |    2 +-
 drivers/net/hippi/rrunner.c                       |    3 ++-
 drivers/staging/most/mostcore/core.c              |    2 +-
 drivers/tty/n_hdlc.c                              |   10 +++++-----
 drivers/tty/serial/st-asc.c                       |    2 +-
 net/decnet/af_decnet.c                            |    3 ++-
 19 files changed, 31 insertions(+), 27 deletions(-)

diff -puN arch/arm/mach-omap2/board-n8x0.c~format-security-move-static-strings-to-const arch/arm/mach-omap2/board-n8x0.c
--- a/arch/arm/mach-omap2/board-n8x0.c~format-security-move-static-strings-to-const
+++ a/arch/arm/mach-omap2/board-n8x0.c
@@ -117,7 +117,7 @@ static struct musb_hdrc_platform_data tu
 static void __init n8x0_usb_init(void)
 {
 	int ret = 0;
-	static char	announce[] __initdata = KERN_INFO "TUSB 6010\n";
+	static const char announce[] __initconst = KERN_INFO "TUSB 6010\n";
 
 	/* PM companion chip power control pin */
 	ret = gpio_request_one(TUSB6010_GPIO_ENABLE, GPIOF_OUT_INIT_LOW,
diff -puN arch/mips/dec/prom/init.c~format-security-move-static-strings-to-const arch/mips/dec/prom/init.c
--- a/arch/mips/dec/prom/init.c~format-security-move-static-strings-to-const
+++ a/arch/mips/dec/prom/init.c
@@ -88,7 +88,7 @@ void __init which_prom(s32 magic, s32 *p
 void __init prom_init(void)
 {
 	extern void dec_machine_halt(void);
-	static char cpu_msg[] __initdata =
+	static const char cpu_msg[] __initconst =
 		"Sorry, this kernel is compiled for a wrong CPU type!\n";
 	s32 argc = fw_arg0;
 	s32 *argv = (void *)fw_arg1;
@@ -111,7 +111,7 @@ void __init prom_init(void)
 #if defined(CONFIG_CPU_R3000)
 	if ((current_cpu_type() == CPU_R4000SC) ||
 	    (current_cpu_type() == CPU_R4400SC)) {
-		static char r4k_msg[] __initdata =
+		static const char r4k_msg[] __initconst =
 			"Please recompile with \"CONFIG_CPU_R4x00 = y\".\n";
 		printk(cpu_msg);
 		printk(r4k_msg);
@@ -122,7 +122,7 @@ void __init prom_init(void)
 #if defined(CONFIG_CPU_R4X00)
 	if ((current_cpu_type() == CPU_R3000) ||
 	    (current_cpu_type() == CPU_R3000A)) {
-		static char r3k_msg[] __initdata =
+		static const char r3k_msg[] __initconst =
 			"Please recompile with \"CONFIG_CPU_R3000 = y\".\n";
 		printk(cpu_msg);
 		printk(r3k_msg);
diff -puN arch/mips/kernel/traps.c~format-security-move-static-strings-to-const arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~format-security-move-static-strings-to-const
+++ a/arch/mips/kernel/traps.c
@@ -2256,8 +2256,8 @@ void set_handler(unsigned long offset, v
 	local_flush_icache_range(ebase + offset, ebase + offset + size);
 }
 
-static char panic_null_cerr[] =
-	"Trying to set NULL cache error exception handler";
+static const char panic_null_cerr[] =
+	"Trying to set NULL cache error exception handler\n";
 
 /*
  * Install uncached CPU exception handler.
diff -puN drivers/char/dsp56k.c~format-security-move-static-strings-to-const drivers/char/dsp56k.c
--- a/drivers/char/dsp56k.c~format-security-move-static-strings-to-const
+++ a/drivers/char/dsp56k.c
@@ -489,7 +489,7 @@ static const struct file_operations dsp5
 
 /****** Init and module functions ******/
 
-static char banner[] __initdata = KERN_INFO "DSP56k driver installed\n";
+static const char banner[] __initconst = KERN_INFO "DSP56k driver installed\n";
 
 static int __init dsp56k_init_driver(void)
 {
diff -puN drivers/cpufreq/powernow-k8.c~format-security-move-static-strings-to-const drivers/cpufreq/powernow-k8.c
--- a/drivers/cpufreq/powernow-k8.c~format-security-move-static-strings-to-const
+++ a/drivers/cpufreq/powernow-k8.c
@@ -1171,7 +1171,8 @@ static struct cpufreq_driver cpufreq_amd
 
 static void __request_acpi_cpufreq(void)
 {
-	const char *cur_drv, *drv = "acpi-cpufreq";
+	const char drv[] = "acpi-cpufreq";
+	const char *cur_drv;
 
 	cur_drv = cpufreq_get_current_driver();
 	if (!cur_drv)
diff -puN drivers/gpu/drm/drm_fb_helper.c~format-security-move-static-strings-to-const drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~format-security-move-static-strings-to-const
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -2423,7 +2423,7 @@ EXPORT_SYMBOL(drm_fb_helper_hotplug_even
 int __init drm_fb_helper_modinit(void)
 {
 #if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
-	const char *name = "fbcon";
+	const char name[] = "fbcon";
 	struct module *fbcon;
 
 	mutex_lock(&module_mutex);
diff -puN drivers/net/ethernet/amd/atarilance.c~format-security-move-static-strings-to-const drivers/net/ethernet/amd/atarilance.c
--- a/drivers/net/ethernet/amd/atarilance.c~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/amd/atarilance.c
@@ -42,8 +42,8 @@
 
 */
 
-static char version[] = "atarilance.c: v1.3 04/04/96 "
-					   "Roman.Hodek@informatik.uni-erlangen.de\n";
+static const char version[] = "atarilance.c: v1.3 04/04/96 "
+			      "Roman.Hodek@informatik.uni-erlangen.de\n";
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/net/ethernet/amd/declance.c~format-security-move-static-strings-to-const drivers/net/ethernet/amd/declance.c
--- a/drivers/net/ethernet/amd/declance.c~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/amd/declance.c
@@ -72,7 +72,7 @@
 #include <asm/dec/machtype.h>
 #include <asm/dec/system.h>
 
-static char version[] =
+static const char version[] =
 "declance.c: v0.011 by Linux MIPS DECstation task force\n";
 
 MODULE_AUTHOR("Linux MIPS DECstation task force");
diff -puN drivers/net/ethernet/amd/sun3lance.c~format-security-move-static-strings-to-const drivers/net/ethernet/amd/sun3lance.c
--- a/drivers/net/ethernet/amd/sun3lance.c~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/amd/sun3lance.c
@@ -21,7 +21,8 @@
 
 */
 
-static char *version = "sun3lance.c: v1.2 1/12/2001  Sam Creasey (sammy@sammy.net)\n";
+static const char version[] =
+"sun3lance.c: v1.2 1/12/2001  Sam Creasey (sammy@sammy.net)\n";
 
 #include <linux/module.h>
 #include <linux/stddef.h>
diff -puN drivers/net/ethernet/cirrus/mac89x0.c~format-security-move-static-strings-to-const drivers/net/ethernet/cirrus/mac89x0.c
--- a/drivers/net/ethernet/cirrus/mac89x0.c~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/cirrus/mac89x0.c
@@ -56,7 +56,7 @@
   local_irq_{dis,en}able()
 */
 
-static char *version =
+static const char version[] =
 "cs89x0.c:v1.02 11/26/96 Russell Nelson <nelson@crynwr.com>\n";
 
 /* ======================= configure the driver here ======================= */
diff -puN drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h~format-security-move-static-strings-to-const drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
@@ -405,7 +405,7 @@ struct mac_driver {
 };
 
 struct mac_stats_string {
-	char desc[ETH_GSTRING_LEN];
+	const char desc[ETH_GSTRING_LEN];
 	unsigned long offset;
 };
 
diff -puN drivers/net/ethernet/natsemi/sonic.h~format-security-move-static-strings-to-const drivers/net/ethernet/natsemi/sonic.h
--- a/drivers/net/ethernet/natsemi/sonic.h~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/natsemi/sonic.h
@@ -444,7 +444,7 @@ static inline __u16 sonic_rra_get(struct
 			     (entry * SIZEOF_SONIC_RR) + offset);
 }
 
-static const char *version =
+static const char version[] =
     "sonic.c:v0.92 20.9.98 tsbogend@alpha.franken.de\n";
 
 #endif /* SONIC_H */
diff -puN drivers/net/ethernet/toshiba/tc35815.c~format-security-move-static-strings-to-const drivers/net/ethernet/toshiba/tc35815.c
--- a/drivers/net/ethernet/toshiba/tc35815.c~format-security-move-static-strings-to-const
+++ a/drivers/net/ethernet/toshiba/tc35815.c
@@ -23,7 +23,7 @@
  */
 
 #define DRV_VERSION	"1.39"
-static const char *version = "tc35815.c:v" DRV_VERSION "\n";
+static const char version[] = "tc35815.c:v" DRV_VERSION "\n";
 #define MODNAME			"tc35815"
 
 #include <linux/module.h>
diff -puN drivers/net/fddi/defxx.c~format-security-move-static-strings-to-const drivers/net/fddi/defxx.c
--- a/drivers/net/fddi/defxx.c~format-security-move-static-strings-to-const
+++ a/drivers/net/fddi/defxx.c
@@ -228,7 +228,7 @@
 #define DRV_VERSION "v1.11"
 #define DRV_RELDATE "2014/07/01"
 
-static char version[] =
+static const char version[] =
 	DRV_NAME ": " DRV_VERSION " " DRV_RELDATE
 	"  Lawrence V. Stefani and others\n";
 
diff -puN drivers/net/hippi/rrunner.c~format-security-move-static-strings-to-const drivers/net/hippi/rrunner.c
--- a/drivers/net/hippi/rrunner.c~format-security-move-static-strings-to-const
+++ a/drivers/net/hippi/rrunner.c
@@ -60,7 +60,8 @@ MODULE_AUTHOR("Jes Sorensen <jes@wildope
 MODULE_DESCRIPTION("Essential RoadRunner HIPPI driver");
 MODULE_LICENSE("GPL");
 
-static char version[] = "rrunner.c: v0.50 11/11/2002  Jes Sorensen (jes@wildopensource.com)\n";
+static const char version[] =
+"rrunner.c: v0.50 11/11/2002  Jes Sorensen (jes@wildopensource.com)\n";
 
 
 static const struct net_device_ops rr_netdev_ops = {
diff -puN drivers/staging/most/mostcore/core.c~format-security-move-static-strings-to-const drivers/staging/most/mostcore/core.c
--- a/drivers/staging/most/mostcore/core.c~format-security-move-static-strings-to-const
+++ a/drivers/staging/most/mostcore/core.c
@@ -82,7 +82,7 @@ struct most_inst_obj {
 
 static const struct {
 	int most_ch_data_type;
-	char *name;
+	const char *name;
 } ch_data_type[] = {
 	{ MOST_CH_CONTROL, "control\n" },
 	{ MOST_CH_ASYNC, "async\n" },
diff -puN drivers/tty/n_hdlc.c~format-security-move-static-strings-to-const drivers/tty/n_hdlc.c
--- a/drivers/tty/n_hdlc.c~format-security-move-static-strings-to-const
+++ a/drivers/tty/n_hdlc.c
@@ -939,11 +939,11 @@ static struct n_hdlc_buf *n_hdlc_buf_get
 	return buf;
 }	/* end of n_hdlc_buf_get() */
 
-static char hdlc_banner[] __initdata =
+static const char hdlc_banner[] __initconst =
 	KERN_INFO "HDLC line discipline maxframe=%u\n";
-static char hdlc_register_ok[] __initdata =
+static const char hdlc_register_ok[] __initconst =
 	KERN_INFO "N_HDLC line discipline registered.\n";
-static char hdlc_register_fail[] __initdata =
+static const char hdlc_register_fail[] __initconst =
 	KERN_ERR "error registering line discipline: %d\n";
 
 static int __init n_hdlc_init(void)
@@ -968,9 +968,9 @@ static int __init n_hdlc_init(void)
 	
 }	/* end of init_module() */
 
-static char hdlc_unregister_ok[] __exitdata =
+static const char hdlc_unregister_ok[] __exitdata =
 	KERN_INFO "N_HDLC: line discipline unregistered\n";
-static char hdlc_unregister_fail[] __exitdata =
+static const char hdlc_unregister_fail[] __exitdata =
 	KERN_ERR "N_HDLC: can't unregister line discipline (err = %d)\n";
 
 static void __exit n_hdlc_exit(void)
diff -puN drivers/tty/serial/st-asc.c~format-security-move-static-strings-to-const drivers/tty/serial/st-asc.c
--- a/drivers/tty/serial/st-asc.c~format-security-move-static-strings-to-const
+++ a/drivers/tty/serial/st-asc.c
@@ -984,7 +984,7 @@ static struct platform_driver asc_serial
 static int __init asc_init(void)
 {
 	int ret;
-	static char banner[] __initdata =
+	static const char banner[] __initconst =
 		KERN_INFO "STMicroelectronics ASC driver initialized\n";
 
 	printk(banner);
diff -puN net/decnet/af_decnet.c~format-security-move-static-strings-to-const net/decnet/af_decnet.c
--- a/net/decnet/af_decnet.c~format-security-move-static-strings-to-const
+++ a/net/decnet/af_decnet.c
@@ -2361,7 +2361,8 @@ MODULE_AUTHOR("Linux DECnet Project Team
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_DECnet);
 
-static char banner[] __initdata = KERN_INFO "NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team\n";
+static const char banner[] __initconst = KERN_INFO
+"NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team\n";
 
 static int __init decnet_init(void)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-remove-rodata_test_data-export-add-pr_fmt.patch
mm-add-additional-consistency-check.patch
reiserfs-use-designated-initializers.patch
format-security-move-static-strings-to-const.patch

