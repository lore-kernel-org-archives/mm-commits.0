From: akpm@linux-foundation.org
Subject: + ntp-add-hardpps-implementation.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:37 -0700
Message-ID: <201008042338.o74Ncbok017020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758564Ab0HEAFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 20:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     ntp: add hardpps implementation
has been added to the -mm tree.  Its filename is
     ntp-add-hardpps-implementation.patch

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
Subject: ntp: add hardpps implementation
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

This commit adds hardpps() implementation based upon the original one from
the NTPv4 reference kernel code from David Mills.  However, it is highly
optimized towards very fast syncronization and maximum stickness to PPS
signal.  The typical error is less then a microsecond.

To make it sync faster I had to throw away exponential phase filter so
that the full phase offset is corrected immediately.  Then I also had to
throw away median phase filter because it gives a bigger error itself if
used without exponential filter.

Maybe we will find an appropriate filtering scheme in the future but it's
not necessary if the signal quality is ok.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig   |    7 
 include/linux/timex.h |    1 
 kernel/time/ntp.c     |  421 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 414 insertions(+), 15 deletions(-)

diff -puN drivers/pps/Kconfig~ntp-add-hardpps-implementation drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~ntp-add-hardpps-implementation
+++ a/drivers/pps/Kconfig
@@ -30,6 +30,13 @@ config PPS_DEBUG
 	  messages to the system log.  Select this if you are having a
 	  problem with PPS support and want to see more of what is going on.
 
+config NTP_PPS
+	bool "PPS kernel consumer support"
+	depends on PPS
+	help
+	  This option adds support for direct in-kernel time
+	  syncronization using an external PPS signal.
+
 source drivers/pps/clients/Kconfig
 
 endmenu
diff -puN include/linux/timex.h~ntp-add-hardpps-implementation include/linux/timex.h
--- a/include/linux/timex.h~ntp-add-hardpps-implementation
+++ a/include/linux/timex.h
@@ -268,6 +268,7 @@ extern u64 tick_length;
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
+extern void hardpps(const struct timespec *, const struct timespec *);
 
 int read_current_timer(unsigned long *timer_val);
 
diff -puN kernel/time/ntp.c~ntp-add-hardpps-implementation kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-add-hardpps-implementation
+++ a/kernel/time/ntp.c
@@ -14,6 +14,7 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 /*
  * NTP timekeeping variables:
@@ -74,6 +75,162 @@ static long			time_adjust;
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
 static s64			ntp_tick_adj;
 
+#ifdef CONFIG_NTP_PPS
+
+/*
+ * The following variables are used when a pulse-per-second (PPS) signal
+ * is available. They establish the engineering parameters of the clock
+ * discipline loop when controlled by the PPS signal.
+ */
+#define PPS_VALID	10	/* PPS signal watchdog max (s) */
+#define PPS_POPCORN	4	/* popcorn spike threshold (shift) */
+#define PPS_INTMIN	2	/* min freq interval (s) (shift) */
+#define PPS_INTMAX	8	/* max freq interval (s) (shift) */
+#define PPS_INTCOUNT	4	/* number of consecutive good intervals to
+				   increase pps_shift or consecutive bad
+				   intervals to decrease it */
+#define PPS_MAXWANDER	100000	/* max PPS freq wander (ns/s) */
+
+static int pps_valid;		/* signal watchdog counter */
+static long pps_tf[3];		/* phase median filter */
+static long pps_jitter;		/* current jitter (ns) */
+static struct timespec pps_fbase; /* beginning of the last freq interval */
+static int pps_shift;		/* current interval duration (s) (shift) */
+static int pps_intcnt;		/* interval counter */
+static s64 pps_freq;		/* frequency offset (scaled ns/s) */
+static long pps_stabil;		/* current stability (scaled ns/s) */
+
+/*
+ * PPS signal quality monitors
+ */
+static long pps_calcnt;		/* calibration intervals */
+static long pps_jitcnt;		/* jitter limit exceeded */
+static long pps_stbcnt;		/* stability limit exceeded */
+static long pps_errcnt;		/* calibration errors */
+
+
+/* PPS kernel consumer compensates the whole phase error immediately.
+ * Otherwise, reduce the offset by a fixed factor times the time constant.
+ */
+static inline s64 ntp_offset_chunk(s64 offset)
+{
+	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
+		return offset;
+	else
+		return shift_right(offset, SHIFT_PLL + time_constant);
+}
+
+static inline void pps_reset_freq_interval(void)
+{
+	/* the PPS calibration interval may end
+	   surprisingly early */
+	pps_shift = PPS_INTMIN;
+	pps_intcnt = 0;
+}
+
+/**
+ * pps_clear - Clears the PPS state variables
+ *
+ * Must be called while holding a write on the xtime_lock
+ */
+static inline void pps_clear(void)
+{
+	pps_reset_freq_interval();
+	pps_tf[0] = 0;
+	pps_tf[1] = 0;
+	pps_tf[2] = 0;
+	pps_fbase.tv_sec = pps_fbase.tv_nsec = 0;
+	pps_freq = 0;
+}
+
+/* Decrease pps_valid to indicate that another second has passed since
+ * the last PPS signal. When it reaches 0, indicate that PPS signal is
+ * missing.
+ *
+ * Must be called while holding a write on the xtime_lock
+ */
+static inline void pps_dec_valid(void)
+{
+	if (pps_valid > 0)
+		pps_valid--;
+	else {
+		time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+				 STA_PPSWANDER | STA_PPSERROR);
+		pps_clear();
+	}
+}
+
+static inline void pps_set_freq(s64 freq)
+{
+	pps_freq = freq;
+}
+
+static inline int is_error_status(int status)
+{
+	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
+		/* PPS signal lost when either PPS time or
+		 * PPS frequency synchronization requested
+		 */
+		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(time_status & STA_PPSSIGNAL))
+		/* PPS jitter exceeded when
+		 * PPS time synchronization requested */
+		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+			== (STA_PPSTIME|STA_PPSJITTER))
+		/* PPS wander exceeded or calibration error when
+		 * PPS frequency synchronization requested
+		 */
+		|| ((time_status & STA_PPSFREQ)
+			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
+}
+
+static inline void pps_fill_timex(struct timex *txc)
+{
+	txc->ppsfreq	   = shift_right((pps_freq >> PPM_SCALE_INV_SHIFT) *
+					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
+	txc->jitter	   = pps_jitter;
+	if (!(time_status & STA_NANO))
+		txc->jitter /= NSEC_PER_USEC;
+	txc->shift	   = pps_shift;
+	txc->stabil	   = pps_stabil;
+	txc->jitcnt	   = pps_jitcnt;
+	txc->calcnt	   = pps_calcnt;
+	txc->errcnt	   = pps_errcnt;
+	txc->stbcnt	   = pps_stbcnt;
+}
+
+#else /* !CONFIG_NTP_PPS */
+
+static inline s64 ntp_offset_chunk(s64 offset)
+{
+	return shift_right(offset, SHIFT_PLL + time_constant);
+}
+
+static inline void pps_reset_freq_interval(void) {}
+static inline void pps_clear(void) {}
+static inline void pps_dec_valid(void) {}
+static inline void pps_set_freq(s64 freq) {}
+
+static inline int is_error_status(int status)
+{
+	return status & (STA_UNSYNC|STA_CLOCKERR);
+}
+
+static inline void pps_fill_timex(struct timex *txc)
+{
+	/* PPS is not implemented, so these are zero */
+	txc->ppsfreq	   = 0;
+	txc->jitter	   = 0;
+	txc->shift	   = 0;
+	txc->stabil	   = 0;
+	txc->jitcnt	   = 0;
+	txc->calcnt	   = 0;
+	txc->errcnt	   = 0;
+	txc->stbcnt	   = 0;
+}
+
+#endif /* CONFIG_NTP_PPS */
+
 /*
  * NTP methods:
  */
@@ -177,6 +334,9 @@ void ntp_clear(void)
 
 	tick_length	= tick_length_base;
 	time_offset	= 0;
+
+	/* Clear PPS state variables */
+	pps_clear();
 }
 
 /*
@@ -242,16 +402,16 @@ void second_overflow(void)
 		time_status |= STA_UNSYNC;
 	}
 
-	/*
-	 * Compute the phase adjustment for the next second. The offset is
-	 * reduced by a fixed factor times the time constant.
-	 */
+	/* Compute the phase adjustment for the next second */
 	tick_length	 = tick_length_base;
 
-	delta		 = shift_right(time_offset, SHIFT_PLL + time_constant);
+	delta		 = ntp_offset_chunk(time_offset);
 	time_offset	-= delta;
 	tick_length	+= delta;
 
+	/* Check PPS signal */
+	pps_dec_valid();
+
 	if (!time_adjust)
 		return;
 
@@ -361,6 +521,8 @@ static inline void process_adj_status(st
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
 		time_state = TIME_OK;
 		time_status = STA_UNSYNC;
+		/* restart PPS frequency calibration */
+		pps_reset_freq_interval();
 	}
 
 	/*
@@ -410,6 +572,8 @@ static inline void process_adjtimex_mode
 		time_freq = txc->freq * PPM_SCALE;
 		time_freq = min(time_freq, MAXFREQ_SCALED);
 		time_freq = max(time_freq, -MAXFREQ_SCALED);
+		/* update pps_freq */
+		pps_set_freq(time_freq);
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
@@ -500,7 +664,8 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	result = time_state;	/* mostly `TIME_OK' */
-	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	/* check for errors */
+	if (is_error_status(time_status))
 		result = TIME_ERROR;
 
 	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
@@ -514,15 +679,8 @@ int do_adjtimex(struct timex *txc)
 	txc->tick	   = tick_usec;
 	txc->tai	   = time_tai;
 
-	/* PPS is not implemented, so these are zero */
-	txc->ppsfreq	   = 0;
-	txc->jitter	   = 0;
-	txc->shift	   = 0;
-	txc->stabil	   = 0;
-	txc->jitcnt	   = 0;
-	txc->calcnt	   = 0;
-	txc->errcnt	   = 0;
-	txc->stbcnt	   = 0;
+	/* fill PPS status fields */
+	pps_fill_timex(txc);
 
 	write_sequnlock_irq(&xtime_lock);
 
@@ -536,6 +694,239 @@ int do_adjtimex(struct timex *txc)
 	return result;
 }
 
+#ifdef	CONFIG_NTP_PPS
+
+struct pps_normtime {
+	__kernel_time_t	sec;	/* seconds */
+	long		nsec;	/* nanoseconds */
+};
+
+/* normalize the timestamp so that nsec is in the
+   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
+static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
+{
+	struct pps_normtime norm = {
+		.sec = ts.tv_sec,
+		.nsec = ts.tv_nsec
+	};
+
+	if (norm.nsec > (NSEC_PER_SEC >> 1)) {
+		norm.nsec -= NSEC_PER_SEC;
+		norm.sec++;
+	}
+
+	return norm;
+}
+
+/* get current phase correction and jitter */
+static inline long pps_phase_filter_get(long *jitter)
+{
+	*jitter = pps_tf[0] - pps_tf[1];
+	if (*jitter < 0)
+		*jitter = -*jitter;
+
+	/* TODO: test various filters */
+	return pps_tf[0];
+}
+
+/* add the sample to the phase filter */
+static inline void pps_phase_filter_add(long err)
+{
+	pps_tf[2] = pps_tf[1];
+	pps_tf[1] = pps_tf[0];
+	pps_tf[0] = err;
+}
+
+/* decrease frequency calibration interval length.
+ * It is halved after four consecutive unstable intervals.
+ */
+static inline void pps_dec_freq_interval(void)
+{
+	if (--pps_intcnt <= -PPS_INTCOUNT) {
+		pps_intcnt = -PPS_INTCOUNT;
+		if (pps_shift > PPS_INTMIN) {
+			pps_shift--;
+			pps_intcnt = 0;
+		}
+	}
+}
+
+/* increase frequency calibration interval length.
+ * It is doubled after four consecutive stable intervals.
+ */
+static inline void pps_inc_freq_interval(void)
+{
+	if (++pps_intcnt >= PPS_INTCOUNT) {
+		pps_intcnt = PPS_INTCOUNT;
+		if (pps_shift < PPS_INTMAX) {
+			pps_shift++;
+			pps_intcnt = 0;
+		}
+	}
+}
+
+/* update clock frequency based on MONOTONIC_RAW clock PPS signal
+ * timestamps
+ *
+ * At the end of the calibration interval the difference between the
+ * first and last MONOTONIC_RAW clock timestamps divided by the length
+ * of the interval becomes the frequency update. If the interval was
+ * too long, the data are discarded.
+ * Returns the difference between old and new frequency values.
+ */
+static long hardpps_update_freq(struct pps_normtime freq_norm)
+{
+	long delta, delta_mod;
+	s64 ftemp;
+
+	/* check if the frequency interval was too long */
+	if (freq_norm.sec > (2 << pps_shift)) {
+		time_status |= STA_PPSERROR;
+		pps_errcnt++;
+		pps_dec_freq_interval();
+		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
+				freq_norm.sec);
+		return 0;
+	}
+
+	/* here the raw frequency offset and wander (stability) is
+	 * calculated. If the wander is less than the wander threshold
+	 * the interval is increased; otherwise it is decreased.
+	 */
+	ftemp = div_s64(((s64)(-freq_norm.nsec)) << NTP_SCALE_SHIFT,
+			freq_norm.sec);
+	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
+	pps_freq = ftemp;
+	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
+		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
+		time_status |= STA_PPSWANDER;
+		pps_stbcnt++;
+		pps_dec_freq_interval();
+	} else {	/* good sample */
+		pps_inc_freq_interval();
+	}
+
+	/* the stability metric is calculated as the average of recent
+	 * frequency changes, but is used only for performance
+	 * monitoring
+	 */
+	delta_mod = delta;
+	if (delta_mod < 0)
+		delta_mod = -delta_mod;
+	pps_stabil += (div_s64(((s64)delta_mod) <<
+				(NTP_SCALE_SHIFT - SHIFT_USEC),
+				NSEC_PER_USEC) - pps_stabil) >> PPS_INTMIN;
+
+	/* if enabled, the system clock frequency is updated */
+	if ((time_status & STA_PPSFREQ) != 0 &&
+	    (time_status & STA_FREQHOLD) == 0) {
+		time_freq = pps_freq;
+		ntp_update_frequency();
+	}
+
+	return delta;
+}
+
+/* correct REALTIME clock phase error against PPS signal */
+static void hardpps_update_phase(long error)
+{
+	long correction = -error;
+	long jitter;
+
+	/* add the sample to the median filter */
+	pps_phase_filter_add(correction);
+	correction = pps_phase_filter_get(&jitter);
+
+	/* Nominal jitter is due to PPS signal noise. If it exceeds the
+	 * threshold, the sample is discarded; otherwise, if so enabled,
+	 * the time offset is updated.
+	 */
+	if (jitter > (pps_jitter << PPS_POPCORN)) {
+		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
+		       jitter, (pps_jitter << PPS_POPCORN));
+		time_status |= STA_PPSJITTER;
+		pps_jitcnt++;
+	} else if (time_status & STA_PPSTIME) {
+		/* correct the time using the phase offset */
+		time_offset = div_s64(((s64)correction) << NTP_SCALE_SHIFT,
+				NTP_INTERVAL_FREQ);
+		/* cancel running adjtime() */
+		time_adjust = 0;
+	}
+	/* update jitter */
+	pps_jitter += (jitter - pps_jitter) >> PPS_INTMIN;
+}
+
+/*
+ * hardpps() - discipline CPU clock oscillator to external PPS signal
+ *
+ * This routine is called at each PPS signal arrival in order to
+ * discipline the CPU clock oscillator to the PPS signal. It takes two
+ * parameters: REALTIME and MONOTONIC_RAW clock timestamps. The former
+ * is used to correct clock phase error and the latter is used to
+ * correct the frequency.
+ *
+ * This code is based on David Mills's reference nanokernel
+ * implementation. It was mostly rewritten but keeps the same idea.
+ */
+void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+{
+	struct pps_normtime pts_norm, freq_norm;
+	unsigned long flags;
+
+	pts_norm = pps_normalize_ts(*phase_ts);
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	/* clear the error bits, they will be set again if needed */
+	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+
+	/* indicate signal presence */
+	time_status |= STA_PPSSIGNAL;
+	pps_valid = PPS_VALID;
+
+	/* when called for the first time,
+	 * just start the frequency interval */
+	if (unlikely(pps_fbase.tv_sec == 0)) {
+		pps_fbase = *raw_ts;
+		write_sequnlock_irqrestore(&xtime_lock, flags);
+		return;
+	}
+
+	/* ok, now we have a base for frequency calculation */
+	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts, pps_fbase));
+
+	/* check that the signal is in the range
+	 * [1s - MAXFREQ us, 1s + MAXFREQ us], otherwise reject it */
+	if ((freq_norm.sec == 0) ||
+			(freq_norm.nsec > MAXFREQ * freq_norm.sec) ||
+			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
+		time_status |= STA_PPSJITTER;
+		/* restart the frequency calibration interval */
+		pps_fbase = *raw_ts;
+		write_sequnlock_irqrestore(&xtime_lock, flags);
+		pr_err("hardpps: PPSJITTER: bad pulse\n");
+		return;
+	}
+
+	/* signal is ok */
+
+	/* check if the current frequency interval is finished */
+	if (freq_norm.sec >= (1 << pps_shift)) {
+		pps_calcnt++;
+		/* restart the frequency calibration interval */
+		pps_fbase = *raw_ts;
+		hardpps_update_freq(freq_norm);
+	}
+
+	hardpps_update_phase(pts_norm.nsec);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+EXPORT_SYMBOL(hardpps);
+
+#endif	/* CONFIG_NTP_PPS */
+
 static int __init ntp_tick_adj_setup(char *str)
 {
 	ntp_tick_adj = simple_strtol(str, NULL, 0);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

