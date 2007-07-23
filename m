From: akpm@linux-foundation.org
Subject: + pm-rename-struct-pm_ops-and-related-things.patch added to -mm tree
Date: Mon, 23 Jul 2007 15:11:47 -0700
Message-ID: <200707232211.l6NMBl00014653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760931AbXGWWMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 18:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz


The patch titled
     PM: Rename struct pm_ops and related things
has been added to the -mm tree.  Its filename is
     pm-rename-struct-pm_ops-and-related-things.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: PM: Rename struct pm_ops and related things
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

The name of 'struct pm_ops' suggests that it is related to the power
management in general, but in fact it is only related to suspend.  =A0M=
oreover,
its name should indicate what this structure is used for, so it seems
reasonable to change it to 'struct platform_suspend_ops'.  =A0In that c=
ase, the
name of the global variable of this type used by the PM core and the na=
mes of
related functions should be changed accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/interface.txt        |    2 -
 arch/arm/common/sharpsl_pm.c             |    8 ++--
 arch/arm/mach-at91/pm.c                  |    4 +-
 arch/arm/mach-omap1/pm.c                 |    6 +--
 arch/arm/mach-omap2/pm.c                 |    6 +--
 arch/arm/mach-pnx4008/pm.c               |    4 +-
 arch/arm/mach-pxa/pm.c                   |    4 +-
 arch/arm/mach-pxa/pxa25x.c               |    2 -
 arch/arm/mach-sa1100/pm.c                |    6 +--
 arch/arm/plat-s3c24xx/pm.c               |    6 +--
 arch/blackfin/mach-common/pm.c           |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |    4 +-
 arch/sh/boards/hp6xx/pm.c                |    6 +--
 drivers/acpi/sleep/main.c                |    6 +--
 include/linux/suspend.h                  |   20 ++++++------
 kernel/power/main.c                      |   34 ++++++++++-----------
 16 files changed, 61 insertions(+), 61 deletions(-)

diff -puN Documentation/power/interface.txt~pm-rename-struct-pm_ops-and=
-related-things Documentation/power/interface.txt
--- a/Documentation/power/interface.txt~pm-rename-struct-pm_ops-and-rel=
ated-things
+++ a/Documentation/power/interface.txt
@@ -20,7 +20,7 @@ states.
 /sys/power/disk controls the operating mode of the suspend-to-disk
 mechanism. Suspend-to-disk can be handled in several ways. We have a
 few options for putting the system to sleep - using the platform drive=
r
-(e.g. ACPI or other pm_ops), powering off the system or rebooting the
+(e.g. ACPI or other suspend_ops), powering off the system or rebooting=
 the
 system (for testing).
=20
 Additionally, /sys/power/disk can be used to turn on one of the two te=
sting
diff -puN arch/arm/common/sharpsl_pm.c~pm-rename-struct-pm_ops-and-rela=
ted-things arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~pm-rename-struct-pm_ops-and-related-=
things
+++ a/arch/arm/common/sharpsl_pm.c
@@ -766,9 +766,9 @@ static void sharpsl_apm_get_power_status
 	info->battery_life =3D sharpsl_pm.battstat.mainbat_percent;
 }
=20
-static struct pm_ops sharpsl_pm_ops =3D {
+static struct platform_suspend_ops sharpsl_pm_ops =3D {
 	.enter		=3D corgi_pxa_pm_enter,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 static int __init sharpsl_pm_probe(struct platform_device *pdev)
@@ -800,7 +800,7 @@ static int __init sharpsl_pm_probe(struc
=20
 	apm_get_power_status =3D sharpsl_apm_get_power_status;
=20
-	pm_set_ops(&sharpsl_pm_ops);
+	suspend_set_ops(&sharpsl_pm_ops);
=20
 	mod_timer(&sharpsl_pm.ac_timer, jiffies + msecs_to_jiffies(250));
=20
@@ -809,7 +809,7 @@ static int __init sharpsl_pm_probe(struc
=20
 static int sharpsl_pm_remove(struct platform_device *pdev)
 {
-	pm_set_ops(NULL);
+	suspend_set_ops(NULL);
=20
 	device_remove_file(&pdev->dev, &dev_attr_battery_percentage);
 	device_remove_file(&pdev->dev, &dev_attr_battery_voltage);
diff -puN arch/arm/mach-at91/pm.c~pm-rename-struct-pm_ops-and-related-t=
hings arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~pm-rename-struct-pm_ops-and-related-thing=
s
+++ a/arch/arm/mach-at91/pm.c
@@ -198,7 +198,7 @@ error:
 }
=20
=20
-static struct pm_ops at91_pm_ops =3D{
+static struct platform_suspend_ops at91_pm_ops =3D{
 	.valid		=3D at91_pm_valid_state,
 	.set_target	=3D at91_pm_set_target,
 	.enter		=3D at91_pm_enter,
@@ -219,7 +219,7 @@ static int __init at91_pm_init(void)
 	/* Disable SDRAM low-power mode.  Cannot be used with self-refresh. *=
/
 	at91_sys_write(AT91_SDRAMC_LPR, 0);
=20
-	pm_set_ops(&at91_pm_ops);
+	suspend_set_ops(&at91_pm_ops);
=20
 	return 0;
 }
diff -puN arch/arm/mach-omap1/pm.c~pm-rename-struct-pm_ops-and-related-=
things arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~pm-rename-struct-pm_ops-and-related-thin=
gs
+++ a/arch/arm/mach-omap1/pm.c
@@ -687,11 +687,11 @@ static struct irqaction omap_wakeup_irq=20
=20
=20
=20
-static struct pm_ops omap_pm_ops =3D{
+static struct platform_suspend_ops omap_pm_ops =3D{
 	.prepare	=3D omap_pm_prepare,
 	.enter		=3D omap_pm_enter,
 	.finish		=3D omap_pm_finish,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 static int __init omap_pm_init(void)
@@ -748,7 +748,7 @@ static int __init omap_pm_init(void)
 	else if (cpu_is_omap16xx())
 		omap_writel(OMAP1610_IDLECT3_VAL, OMAP1610_IDLECT3);
=20
-	pm_set_ops(&omap_pm_ops);
+	suspend_set_ops(&omap_pm_ops);
=20
 #if defined(DEBUG) && defined(CONFIG_PROC_FS)
 	omap_pm_init_proc();
diff -puN arch/arm/mach-omap2/pm.c~pm-rename-struct-pm_ops-and-related-=
things arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~pm-rename-struct-pm_ops-and-related-thin=
gs
+++ a/arch/arm/mach-omap2/pm.c
@@ -362,11 +362,11 @@ static int omap2_pm_finish(suspend_state
 	return 0;
 }
=20
-static struct pm_ops omap_pm_ops =3D {
+static struct platform_suspend_ops omap_pm_ops =3D {
 	.prepare	=3D omap2_pm_prepare,
 	.enter		=3D omap2_pm_enter,
 	.finish		=3D omap2_pm_finish,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 int __init omap2_pm_init(void)
@@ -390,7 +390,7 @@ int __init omap2_pm_init(void)
 	omap2_sram_suspend =3D omap_sram_push(omap24xx_cpu_suspend,
 					    omap24xx_cpu_suspend_sz);
=20
-	pm_set_ops(&omap_pm_ops);
+	suspend_set_ops(&omap_pm_ops);
 	pm_idle =3D omap2_pm_idle;
=20
 	pmdomain_init();
diff -puN arch/arm/mach-pnx4008/pm.c~pm-rename-struct-pm_ops-and-relate=
d-things arch/arm/mach-pnx4008/pm.c
--- a/arch/arm/mach-pnx4008/pm.c~pm-rename-struct-pm_ops-and-related-th=
ings
+++ a/arch/arm/mach-pnx4008/pm.c
@@ -117,7 +117,7 @@ static int pnx4008_pm_valid(suspend_stat
 	       (state =3D=3D PM_SUSPEND_MEM);
 }
=20
-static struct pm_ops pnx4008_pm_ops =3D {
+static struct platform_suspend_ops pnx4008_pm_ops =3D {
 	.enter =3D pnx4008_pm_enter,
 	.valid =3D pnx4008_pm_valid,
 };
@@ -146,7 +146,7 @@ static int __init pnx4008_pm_init(void)
 		return -ENOMEM;
 	}
=20
-	pm_set_ops(&pnx4008_pm_ops);
+	suspend_set_ops(&pnx4008_pm_ops);
 	return 0;
 }
=20
diff -puN arch/arm/mach-pxa/pm.c~pm-rename-struct-pm_ops-and-related-th=
ings arch/arm/mach-pxa/pm.c
--- a/arch/arm/mach-pxa/pm.c~pm-rename-struct-pm_ops-and-related-things
+++ a/arch/arm/mach-pxa/pm.c
@@ -86,7 +86,7 @@ static int pxa_pm_valid(suspend_state_t=20
 	return -EINVAL;
 }
=20
-static struct pm_ops pxa_pm_ops =3D {
+static struct platform_suspend_ops pxa_pm_ops =3D {
 	.valid		=3D pxa_pm_valid,
 	.enter		=3D pxa_pm_enter,
 };
@@ -104,7 +104,7 @@ static int __init pxa_pm_init(void)
 		return -ENOMEM;
 	}
=20
-	pm_set_ops(&pxa_pm_ops);
+	suspend_set_ops(&pxa_pm_ops);
 	return 0;
 }
=20
diff -puN arch/arm/mach-pxa/pxa25x.c~pm-rename-struct-pm_ops-and-relate=
d-things arch/arm/mach-pxa/pxa25x.c
--- a/arch/arm/mach-pxa/pxa25x.c~pm-rename-struct-pm_ops-and-related-th=
ings
+++ a/arch/arm/mach-pxa/pxa25x.c
@@ -193,7 +193,7 @@ static void pxa25x_cpu_pm_enter(suspend_
=20
 static struct pxa_cpu_pm_fns pxa25x_cpu_pm_fns =3D {
 	.save_size	=3D SLEEP_SAVE_SIZE,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 	.save		=3D pxa25x_cpu_pm_save,
 	.restore	=3D pxa25x_cpu_pm_restore,
 	.enter		=3D pxa25x_cpu_pm_enter,
diff -puN arch/arm/mach-sa1100/pm.c~pm-rename-struct-pm_ops-and-related=
-things arch/arm/mach-sa1100/pm.c
--- a/arch/arm/mach-sa1100/pm.c~pm-rename-struct-pm_ops-and-related-thi=
ngs
+++ a/arch/arm/mach-sa1100/pm.c
@@ -122,14 +122,14 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
=20
-static struct pm_ops sa11x0_pm_ops =3D {
+static struct platform_suspend_ops sa11x0_pm_ops =3D {
 	.enter		=3D sa11x0_pm_enter,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 static int __init sa11x0_pm_init(void)
 {
-	pm_set_ops(&sa11x0_pm_ops);
+	suspend_set_ops(&sa11x0_pm_ops);
 	return 0;
 }
=20
diff -puN arch/arm/plat-s3c24xx/pm.c~pm-rename-struct-pm_ops-and-relate=
d-things arch/arm/plat-s3c24xx/pm.c
--- a/arch/arm/plat-s3c24xx/pm.c~pm-rename-struct-pm_ops-and-related-th=
ings
+++ a/arch/arm/plat-s3c24xx/pm.c
@@ -612,9 +612,9 @@ static int s3c2410_pm_enter(suspend_stat
 	return 0;
 }
=20
-static struct pm_ops s3c2410_pm_ops =3D {
+static struct platform_suspend_ops s3c2410_pm_ops =3D {
 	.enter		=3D s3c2410_pm_enter,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 /* s3c2410_pm_init
@@ -628,6 +628,6 @@ int __init s3c2410_pm_init(void)
 {
 	printk("S3C2410 Power Management, (c) 2004 Simtec Electronics\n");
=20
-	pm_set_ops(&s3c2410_pm_ops);
+	suspend_set_ops(&s3c2410_pm_ops);
 	return 0;
 }
diff -puN arch/blackfin/mach-common/pm.c~pm-rename-struct-pm_ops-and-re=
lated-things arch/blackfin/mach-common/pm.c
--- a/arch/blackfin/mach-common/pm.c~pm-rename-struct-pm_ops-and-relate=
d-things
+++ a/arch/blackfin/mach-common/pm.c
@@ -158,7 +158,7 @@ static int bfin_pm_finish(suspend_state_
 	return 0;
 }
=20
-struct pm_ops bfin_pm_ops =3D {
+struct platform_suspend_ops bfin_pm_ops =3D {
 	.prepare =3D bfin_pm_prepare,
 	.enter =3D bfin_pm_enter,
 	.finish =3D bfin_pm_finish,
@@ -166,7 +166,7 @@ struct pm_ops bfin_pm_ops =3D {
=20
 static int __init bfin_pm_init(void)
 {
-	pm_set_ops(&bfin_pm_ops);
+	suspend_set_ops(&bfin_pm_ops);
 	return 0;
 }
=20
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rename-struct-pm_=
ops-and-related-things arch/powerpc/platforms/52xx/mpc52xx_pm.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rename-struct-pm_ops-=
and-related-things
+++ a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -177,7 +177,7 @@ int mpc52xx_pm_finish(suspend_state_t st
 	return 0;
 }
=20
-static struct pm_ops mpc52xx_pm_ops =3D {
+static struct platform_suspend_ops mpc52xx_pm_ops =3D {
 	.valid		=3D mpc52xx_pm_valid,
 	.prepare	=3D mpc52xx_pm_prepare,
 	.enter		=3D mpc52xx_pm_enter,
@@ -186,6 +186,6 @@ static struct pm_ops mpc52xx_pm_ops =3D {
=20
 int __init mpc52xx_pm_init(void)
 {
-	pm_set_ops(&mpc52xx_pm_ops);
+	suspend_set_ops(&mpc52xx_pm_ops);
 	return 0;
 }
diff -puN arch/sh/boards/hp6xx/pm.c~pm-rename-struct-pm_ops-and-related=
-things arch/sh/boards/hp6xx/pm.c
--- a/arch/sh/boards/hp6xx/pm.c~pm-rename-struct-pm_ops-and-related-thi=
ngs
+++ a/arch/sh/boards/hp6xx/pm.c
@@ -67,14 +67,14 @@ static int hp6x0_pm_enter(suspend_state_
 	return 0;
 }
=20
-static struct pm_ops hp6x0_pm_ops =3D {
+static struct platform_suspend_ops hp6x0_pm_ops =3D {
 	.enter		=3D hp6x0_pm_enter,
-	.valid		=3D pm_valid_only_mem,
+	.valid		=3D suspend_valid_only_mem,
 };
=20
 static int __init hp6x0_pm_init(void)
 {
-	pm_set_ops(&hp6x0_pm_ops);
+	suspend_set_ops(&hp6x0_pm_ops);
 	return 0;
 }
=20
diff -puN drivers/acpi/sleep/main.c~pm-rename-struct-pm_ops-and-related=
-things drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-rename-struct-pm_ops-and-related-thi=
ngs
+++ a/drivers/acpi/sleep/main.c
@@ -21,7 +21,7 @@
=20
 u8 sleep_states[ACPI_S_STATE_COUNT];
=20
-static struct pm_ops acpi_pm_ops;
+static struct platform_suspend_ops acpi_pm_ops;
=20
 extern void do_suspend_lowlevel(void);
=20
@@ -193,7 +193,7 @@ static int acpi_pm_state_valid(suspend_s
 	}
 }
=20
-static struct pm_ops acpi_pm_ops =3D {
+static struct platform_suspend_ops acpi_pm_ops =3D {
 	.valid =3D acpi_pm_state_valid,
 	.set_target =3D acpi_pm_set_target,
 	.prepare =3D acpi_pm_prepare,
@@ -371,7 +371,7 @@ int __init acpi_sleep_init(void)
 	}
 	printk(")\n");
=20
-	pm_set_ops(&acpi_pm_ops);
+	suspend_set_ops(&acpi_pm_ops);
=20
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	if (sleep_states[ACPI_STATE_S4])
diff -puN include/linux/suspend.h~pm-rename-struct-pm_ops-and-related-t=
hings include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rename-struct-pm_ops-and-related-thing=
s
+++ a/include/linux/suspend.h
@@ -26,16 +26,16 @@ typedef int __bitwise suspend_state_t;
 #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
=20
 /**
- * struct pm_ops - Callbacks for managing platform dependent system sl=
eep
- *	states.
+ * struct platform_suspend_ops - Callbacks for managing platform depen=
dent
+ *	system sleep states.
  *
  * @valid: Callback to determine if given system sleep state is suppor=
ted by
  *	the platform.
  *	Valid (ie. supported) states are advertised in /sys/power/state.  N=
ote
  *	that it still may be impossible to enter given system sleep state i=
f the
  *	conditions aren't right.
- *	There is the %pm_valid_only_mem function available that can be assi=
gned
- *	to this if the platform only supports mem sleep.
+ *	There is the %suspend_valid_only_mem function available that can be
+ *	assigned to this if the platform only supports mem sleep.
  *
  * @set_target: Tell the platform which system sleep state is going to=
 be
  *	entered.
@@ -72,7 +72,7 @@ typedef int __bitwise suspend_state_t;
  *	that implement @prepare().  If implemented, it is always called aft=
er
  *	@enter() (even if @enter() fails).
  */
-struct pm_ops {
+struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*set_target)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
@@ -80,14 +80,14 @@ struct pm_ops {
 	int (*finish)(suspend_state_t state);
 };
=20
-extern struct pm_ops *pm_ops;
+extern struct platform_suspend_ops *suspend_ops;
=20
 /**
- * pm_set_ops - set platform dependent power management ops
- * @pm_ops: The new power management operations to set.
+ * suspend_set_ops - set platform dependent suspend operations
+ * @ops: The new suspend operations to set.
  */
-extern void pm_set_ops(struct pm_ops *pm_ops);
-extern int pm_valid_only_mem(suspend_state_t state);
+extern void suspend_set_ops(struct platform_suspend_ops *ops);
+extern int suspend_valid_only_mem(suspend_state_t state);
=20
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
diff -puN kernel/power/main.c~pm-rename-struct-pm_ops-and-related-thing=
s kernel/power/main.c
--- a/kernel/power/main.c~pm-rename-struct-pm_ops-and-related-things
+++ a/kernel/power/main.c
@@ -30,28 +30,28 @@ BLOCKING_NOTIFIER_HEAD(pm_chain_head);
=20
 DEFINE_MUTEX(pm_mutex);
=20
-struct pm_ops *pm_ops;
+struct platform_suspend_ops *suspend_ops;
=20
 /**
- *	pm_set_ops - Set the global power method table.=20
+ *	suspend_set_ops - Set the global suspend method table.
  *	@ops:	Pointer to ops structure.
  */
=20
-void pm_set_ops(struct pm_ops * ops)
+void suspend_set_ops(struct platform_suspend_ops *ops)
 {
 	mutex_lock(&pm_mutex);
-	pm_ops =3D ops;
+	suspend_ops =3D ops;
 	mutex_unlock(&pm_mutex);
 }
=20
 /**
- * pm_valid_only_mem - generic memory-only valid callback
+ * suspend_valid_only_mem - generic memory-only valid callback
  *
- * pm_ops drivers that implement mem suspend only and only need
+ * Platform drivers that implement mem suspend only and only need
  * to check for that in their .valid callback can use this instead
  * of rolling their own .valid callback.
  */
-int pm_valid_only_mem(suspend_state_t state)
+int suspend_valid_only_mem(suspend_state_t state)
 {
 	return state =3D=3D PM_SUSPEND_MEM;
 }
@@ -59,8 +59,8 @@ int pm_valid_only_mem(suspend_state_t st
=20
 static inline void pm_finish(suspend_state_t state)
 {
-	if (pm_ops->finish)
-		pm_ops->finish(state);
+	if (suspend_ops->finish)
+		suspend_ops->finish(state);
 }
=20
 /**
@@ -74,7 +74,7 @@ static int suspend_prepare(void)
 	int error;
 	unsigned int free_pages;
=20
-	if (!pm_ops || !pm_ops->enter)
+	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
=20
 	error =3D pm_notifier_call_chain(PM_SUSPEND_PREPARE);
@@ -137,7 +137,7 @@ int suspend_enter(suspend_state_t state)
 		printk(KERN_ERR "Some devices failed to power down\n");
 		goto Done;
 	}
-	error =3D pm_ops->enter(state);
+	error =3D suspend_ops->enter(state);
 	device_power_up();
  Done:
 	arch_suspend_enable_irqs();
@@ -154,11 +154,11 @@ int suspend_devices_and_enter(suspend_st
 {
 	int error;
=20
-	if (!pm_ops)
+	if (!suspend_ops)
 		return -ENOSYS;
=20
-	if (pm_ops->set_target) {
-		error =3D pm_ops->set_target(state);
+	if (suspend_ops->set_target) {
+		error =3D suspend_ops->set_target(state);
 		if (error)
 			return error;
 	}
@@ -168,8 +168,8 @@ int suspend_devices_and_enter(suspend_st
 		printk(KERN_ERR "Some devices failed to suspend\n");
 		goto Resume_console;
 	}
-	if (pm_ops->prepare) {
-		error =3D pm_ops->prepare(state);
+	if (suspend_ops->prepare) {
+		error =3D suspend_ops->prepare(state);
 		if (error)
 			goto Resume_devices;
 	}
@@ -212,7 +212,7 @@ static inline int valid_state(suspend_st
 	/* All states need lowlevel support and need to be valid
 	 * to the lowlevel implementation, no valid callback
 	 * implies that none are valid. */
-	if (!pm_ops || !pm_ops->valid || !pm_ops->valid(state))
+	if (!suspend_ops || !suspend_ops->valid || !suspend_ops->valid(state)=
)
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
