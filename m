From: akpm@linux-foundation.org
Subject: + param-convert-some-on-off-users-to-strtobool.patch added to -mm tree
Date: Thu, 04 Feb 2016 13:40:46 -0800
Message-ID: <56b3c55e.WiWyv73GGrjsMDVz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbcBDVkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:40:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, kvalo@codeaurora.org, mingo@elte.hu, mpe@ellerman.id.au, nishants@marvell.com, sfrench@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: param: convert some "on"/"off" users to strtobool
has been added to the -mm tree.  Its filename is
     param-convert-some-on-off-users-to-strtobool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/param-convert-some-on-off-users-to-strtobool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/param-convert-some-on-off-users-to-strtobool.patch

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
Subject: param: convert some "on"/"off" users to strtobool

This changes several users of manual "on"/"off" parsing to use strtobool.
(Which means they will now parse y/n/1/0 meaningfully too.)

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtasd.c                  |    9 ++-------
 arch/powerpc/platforms/pseries/hotplug-cpu.c |   10 ++--------
 arch/s390/kernel/time.c                      |    8 ++------
 arch/s390/kernel/topology.c                  |    7 ++-----
 arch/x86/kernel/aperture_64.c                |   12 ++----------
 include/linux/tick.h                         |    2 +-
 kernel/time/hrtimer.c                        |   10 ++--------
 kernel/time/tick-sched.c                     |   10 ++--------
 8 files changed, 15 insertions(+), 53 deletions(-)

diff -puN arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool arch/powerpc/kernel/rtasd.c
--- a/arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool
+++ a/arch/powerpc/kernel/rtasd.c
@@ -49,7 +49,7 @@ static unsigned int rtas_error_log_buffe
 static unsigned int event_scan;
 static unsigned int rtas_event_scan_rate;
 
-static int full_rtas_msgs = 0;
+static bool full_rtas_msgs;
 
 /* Stop logging to nvram after first fatal error */
 static int logging_enabled; /* Until we initialize everything,
@@ -592,11 +592,6 @@ __setup("surveillance=", surveillance_se
 
 static int __init rtasmsgs_setup(char *str)
 {
-	if (strcmp(str, "on") == 0)
-		full_rtas_msgs = 1;
-	else if (strcmp(str, "off") == 0)
-		full_rtas_msgs = 0;
-
-	return 1;
+	return kstrtobool(str, 0, &full_rtas_msgs);
 }
 __setup("rtasmsgs=", rtasmsgs_setup);
diff -puN arch/powerpc/platforms/pseries/hotplug-cpu.c~param-convert-some-on-off-users-to-strtobool arch/powerpc/platforms/pseries/hotplug-cpu.c
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c~param-convert-some-on-off-users-to-strtobool
+++ a/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -47,20 +47,14 @@ static DEFINE_PER_CPU(enum cpu_state_val
 
 static enum cpu_state_vals default_offline_state = CPU_STATE_OFFLINE;
 
-static int cede_offline_enabled __read_mostly = 1;
+static bool cede_offline_enabled __read_mostly = true;
 
 /*
  * Enable/disable cede_offline when available.
  */
 static int __init setup_cede_offline(char *str)
 {
-	if (!strcmp(str, "off"))
-		cede_offline_enabled = 0;
-	else if (!strcmp(str, "on"))
-		cede_offline_enabled = 1;
-	else
-		return 0;
-	return 1;
+	return kstrtobool(str, 0, &cede_offline_enabled);
 }
 
 __setup("cede_offline=", setup_cede_offline);
diff -puN arch/s390/kernel/time.c~param-convert-some-on-off-users-to-strtobool arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~param-convert-some-on-off-users-to-strtobool
+++ a/arch/s390/kernel/time.c
@@ -1433,7 +1433,7 @@ device_initcall(etr_init_sysfs);
 /*
  * Server Time Protocol (STP) code.
  */
-static int stp_online;
+static bool stp_online;
 static struct stp_sstpi stp_info;
 static void *stp_page;
 
@@ -1444,11 +1444,7 @@ static struct timer_list stp_timer;
 
 static int __init early_parse_stp(char *p)
 {
-	if (strncmp(p, "off", 3) == 0)
-		stp_online = 0;
-	else if (strncmp(p, "on", 2) == 0)
-		stp_online = 1;
-	return 0;
+	return kstrtobool(p, 0, &stp_online);
 }
 early_param("stp", early_parse_stp);
 
diff -puN arch/s390/kernel/topology.c~param-convert-some-on-off-users-to-strtobool arch/s390/kernel/topology.c
--- a/arch/s390/kernel/topology.c~param-convert-some-on-off-users-to-strtobool
+++ a/arch/s390/kernel/topology.c
@@ -37,7 +37,7 @@ static void set_topology_timer(void);
 static void topology_work_fn(struct work_struct *work);
 static struct sysinfo_15_1_x *tl_info;
 
-static int topology_enabled = 1;
+static bool topology_enabled = true;
 static DECLARE_WORK(topology_work, topology_work_fn);
 
 /*
@@ -444,10 +444,7 @@ static const struct cpumask *cpu_book_ma
 
 static int __init early_parse_topology(char *p)
 {
-	if (strncmp(p, "off", 3))
-		return 0;
-	topology_enabled = 0;
-	return 0;
+	return kstrtobool(p, 0, &topology_enabled);
 }
 early_param("topology", early_parse_topology);
 
diff -puN arch/x86/kernel/aperture_64.c~param-convert-some-on-off-users-to-strtobool arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~param-convert-some-on-off-users-to-strtobool
+++ a/arch/x86/kernel/aperture_64.c
@@ -227,19 +227,11 @@ static u32 __init search_agp_bridge(u32
 	return 0;
 }
 
-static int gart_fix_e820 __initdata = 1;
+static bool gart_fix_e820 __initdata = true;
 
 static int __init parse_gart_mem(char *p)
 {
-	if (!p)
-		return -EINVAL;
-
-	if (!strncmp(p, "off", 3))
-		gart_fix_e820 = 0;
-	else if (!strncmp(p, "on", 2))
-		gart_fix_e820 = 1;
-
-	return 0;
+	return kstrtobool(p, 0, &gart_fix_e820);
 }
 early_param("gart_fix_e820", parse_gart_mem);
 
diff -puN include/linux/tick.h~param-convert-some-on-off-users-to-strtobool include/linux/tick.h
--- a/include/linux/tick.h~param-convert-some-on-off-users-to-strtobool
+++ a/include/linux/tick.h
@@ -98,7 +98,7 @@ static inline void tick_broadcast_exit(v
 }
 
 #ifdef CONFIG_NO_HZ_COMMON
-extern int tick_nohz_enabled;
+extern bool tick_nohz_enabled;
 extern int tick_nohz_tick_stopped(void);
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
diff -puN kernel/time/hrtimer.c~param-convert-some-on-off-users-to-strtobool kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~param-convert-some-on-off-users-to-strtobool
+++ a/kernel/time/hrtimer.c
@@ -515,7 +515,7 @@ static inline ktime_t hrtimer_update_bas
 /*
  * High resolution timer enabled ?
  */
-static int hrtimer_hres_enabled __read_mostly  = 1;
+static bool hrtimer_hres_enabled __read_mostly  = true;
 unsigned int hrtimer_resolution __read_mostly = LOW_RES_NSEC;
 EXPORT_SYMBOL_GPL(hrtimer_resolution);
 
@@ -524,13 +524,7 @@ EXPORT_SYMBOL_GPL(hrtimer_resolution);
  */
 static int __init setup_hrtimer_hres(char *str)
 {
-	if (!strcmp(str, "off"))
-		hrtimer_hres_enabled = 0;
-	else if (!strcmp(str, "on"))
-		hrtimer_hres_enabled = 1;
-	else
-		return 0;
-	return 1;
+	return kstrtobool(str, 0, &hrtimer_hres_enabled);
 }
 
 __setup("highres=", setup_hrtimer_hres);
diff -puN kernel/time/tick-sched.c~param-convert-some-on-off-users-to-strtobool kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~param-convert-some-on-off-users-to-strtobool
+++ a/kernel/time/tick-sched.c
@@ -389,20 +389,14 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-int tick_nohz_enabled __read_mostly = 1;
+bool tick_nohz_enabled __read_mostly  = true;
 unsigned long tick_nohz_active  __read_mostly;
 /*
  * Enable / Disable tickless mode
  */
 static int __init setup_tick_nohz(char *str)
 {
-	if (!strcmp(str, "off"))
-		tick_nohz_enabled = 0;
-	else if (!strcmp(str, "on"))
-		tick_nohz_enabled = 1;
-	else
-		return 0;
-	return 1;
+	return kstrtobool(str, 0, &tick_nohz_enabled);
 }
 
 __setup("nohz=", setup_tick_nohz);
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-add-on-off-support-to-kstrtobool.patch
param-convert-some-on-off-users-to-strtobool.patch

