From: akpm@linux-foundation.org
Subject: + acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect.patch added to -mm tree
Date: Mon, 02 Feb 2009 23:24:44 -0800
Message-ID: <200902030724.n137OidB022831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZBCHYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, lenb@kernel.org, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com


The patch titled
     acpi: fix pmtimer overflow which makes Cx states time incorrect
has been added to the -mm tree.  Its filename is
     acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix pmtimer overflow which makes Cx states time incorrect
From: "alex.shi" <alex.shi@intel.com>

On most boxes the ACPI PM timer is 24-bit counter that runs on 3.579545MHz
clock.  In such case the max C-state sleep time should be less than 4687ms
when it is used to record C2/C3 duration time.

But on some boxes the max C-state sleep time is more than 4687ms.  In such
case the overflow happens and the C-state duration time can't be counted
accurately.

Use clocksource to get the C-state time instead of ACPI PM timer.  and use
div64_u64 to convert US_TO_PM_TIME_TICKS in i386 mode.

Asked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Tested-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Yakui.zhao <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   60 ++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect
+++ a/drivers/acpi/processor_idle.c
@@ -64,7 +64,8 @@
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_idle");
 #define ACPI_PROCESSOR_FILE_POWER	"power"
-#define US_TO_PM_TIMER_TICKS(t)		((t * (PM_TIMER_FREQUENCY/1000)) / 1000)
+#define US_TO_PM_TIMER_TICKS(t)		div64_u64(\
+	(t * (PM_TIMER_FREQUENCY/1000)), 1000ULL)
 #define PM_TIMER_TICK_NS		(1000000000ULL/PM_TIMER_FREQUENCY)
 #ifndef CONFIG_CPU_IDLE
 #define C2_OVERHEAD			4	/* 1us (3.579 ticks per us) */
@@ -376,8 +377,9 @@ static void acpi_processor_idle(void)
 	struct acpi_processor *pr = NULL;
 	struct acpi_processor_cx *cx = NULL;
 	struct acpi_processor_cx *next_state = NULL;
-	int sleep_ticks = 0;
-	u32 t1, t2 = 0;
+	s64 sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
 
 	/*
 	 * Interrupts must be disabled during bus mastering calculations and
@@ -524,14 +526,15 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C2:
 		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt1 = ktime_get_real();
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		/* Invoke C2 */
 		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt2 = ktime_get_real();
+		idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 		/* TSC halts in C2, so notify users */
@@ -539,7 +542,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = ticks_elapsed(t1, t2);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -585,13 +588,14 @@ static void acpi_processor_idle(void)
 		}
 
 		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt1 = ktime_get_real();
 		/* Invoke C3 */
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
-		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		kt2 = ktime_get_real();
+		idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 		if (pr->flags.bm_check && pr->flags.bm_control) {
 			/* Enable bus master arbitration */
 			atomic_dec(&c3_cpu_count);
@@ -604,7 +608,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = ticks_elapsed(t1, t2);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1424,7 +1428,8 @@ static inline void acpi_idle_do_entry(st
 static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 			      struct cpuidle_state *state)
 {
-	u32 t1, t2;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 
@@ -1442,14 +1447,15 @@ static int acpi_idle_enter_c1(struct cpu
 		return 0;
 	}
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	local_irq_enable();
 	cx->usage++;
 
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 /**
@@ -1462,8 +1468,9 @@ static int acpi_idle_enter_simple(struct
 {
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
-	u32 t1, t2;
-	int sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
+	s64 sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1496,18 +1503,19 @@ static int acpi_idle_enter_simple(struct
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -1519,7 +1527,7 @@ static int acpi_idle_enter_simple(struct
 
 	acpi_state_timer_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 static int c3_cpu_count;
@@ -1537,8 +1545,9 @@ static int acpi_idle_enter_bm(struct cpu
 {
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
-	u32 t1, t2;
-	int sleep_ticks = 0;
+	ktime_t  kt1, kt2;
+	s64 idle_time;
+	s64 sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1605,9 +1614,10 @@ static int acpi_idle_enter_bm(struct cpu
 		ACPI_FLUSH_CPU_CACHE();
 	}
 
-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	/* Re-enable bus master arbitration */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
@@ -1622,7 +1632,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1633,7 +1643,7 @@ static int acpi_idle_enter_bm(struct cpu
 
 	acpi_state_timer_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return ticks_elapsed_in_us(t1, t2);
+	return idle_time;
 }
 
 struct cpuidle_driver acpi_idle_driver = {
_

Patches currently in -mm which might be from alex.shi@intel.com are

acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect.patch

