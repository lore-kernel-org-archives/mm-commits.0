From: akpm@linux-foundation.org
Subject: + rtc-remove-use-of-seq_printf-return-value.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 15:58:46 -0800
Message-ID: <54ebbeb6.LYAz2rzLHR2QD+gD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbbBWX6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     rtc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: rtc: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c   |   36 +++++++++++++++++++-----------------
 drivers/rtc/rtc-ds1305.c |    6 +++---
 drivers/rtc/rtc-mrst.c   |   16 +++++++++-------
 drivers/rtc/rtc-tegra.c  |    4 +++-
 4 files changed, 34 insertions(+), 28 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-use-of-seq_printf-return-value drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-use-of-seq_printf-return-value
+++ a/drivers/rtc/rtc-cmos.c
@@ -459,23 +459,25 @@ static int cmos_procfs(struct device *de
 	/* NOTE:  at least ICH6 reports battery status using a different
 	 * (non-RTC) bit; and SQWE is ignored on many current systems.
 	 */
-	return seq_printf(seq,
-			"periodic_IRQ\t: %s\n"
-			"update_IRQ\t: %s\n"
-			"HPET_emulated\t: %s\n"
-			// "square_wave\t: %s\n"
-			"BCD\t\t: %s\n"
-			"DST_enable\t: %s\n"
-			"periodic_freq\t: %d\n"
-			"batt_status\t: %s\n",
-			(rtc_control & RTC_PIE) ? "yes" : "no",
-			(rtc_control & RTC_UIE) ? "yes" : "no",
-			is_hpet_enabled() ? "yes" : "no",
-			// (rtc_control & RTC_SQWE) ? "yes" : "no",
-			(rtc_control & RTC_DM_BINARY) ? "no" : "yes",
-			(rtc_control & RTC_DST_EN) ? "yes" : "no",
-			cmos->rtc->irq_freq,
-			(valid & RTC_VRT) ? "okay" : "dead");
+	seq_printf(seq,
+		   "periodic_IRQ\t: %s\n"
+		   "update_IRQ\t: %s\n"
+		   "HPET_emulated\t: %s\n"
+		   // "square_wave\t: %s\n"
+		   "BCD\t\t: %s\n"
+		   "DST_enable\t: %s\n"
+		   "periodic_freq\t: %d\n"
+		   "batt_status\t: %s\n",
+		   (rtc_control & RTC_PIE) ? "yes" : "no",
+		   (rtc_control & RTC_UIE) ? "yes" : "no",
+		   is_hpet_enabled() ? "yes" : "no",
+		   // (rtc_control & RTC_SQWE) ? "yes" : "no",
+		   (rtc_control & RTC_DM_BINARY) ? "no" : "yes",
+		   (rtc_control & RTC_DST_EN) ? "yes" : "no",
+		   cmos->rtc->irq_freq,
+		   (valid & RTC_VRT) ? "okay" : "dead");
+
+	return 0;
 }
 
 #else
diff -puN drivers/rtc/rtc-ds1305.c~rtc-remove-use-of-seq_printf-return-value drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-remove-use-of-seq_printf-return-value
+++ a/drivers/rtc/rtc-ds1305.c
@@ -434,9 +434,9 @@ static int ds1305_proc(struct device *de
 	}
 
 done:
-	return seq_printf(seq,
-			"trickle_charge\t: %s%s\n",
-			diodes, resistors);
+	seq_printf(seq, "trickle_charge\t: %s%s\n", diodes, resistors);
+
+	return 0;
 }
 
 #else
diff -puN drivers/rtc/rtc-mrst.c~rtc-remove-use-of-seq_printf-return-value drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~rtc-remove-use-of-seq_printf-return-value
+++ a/drivers/rtc/rtc-mrst.c
@@ -277,13 +277,15 @@ static int mrst_procfs(struct device *de
 	valid = vrtc_cmos_read(RTC_VALID);
 	spin_unlock_irq(&rtc_lock);
 
-	return seq_printf(seq,
-			"periodic_IRQ\t: %s\n"
-			"alarm\t\t: %s\n"
-			"BCD\t\t: no\n"
-			"periodic_freq\t: daily (not adjustable)\n",
-			(rtc_control & RTC_PIE) ? "on" : "off",
-			(rtc_control & RTC_AIE) ? "on" : "off");
+	seq_printf(seq,
+		   "periodic_IRQ\t: %s\n"
+		   "alarm\t\t: %s\n"
+		   "BCD\t\t: no\n"
+		   "periodic_freq\t: daily (not adjustable)\n",
+		   (rtc_control & RTC_PIE) ? "on" : "off",
+		   (rtc_control & RTC_AIE) ? "on" : "off");
+
+	return 0;
 }
 
 #else
diff -puN drivers/rtc/rtc-tegra.c~rtc-remove-use-of-seq_printf-return-value drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-remove-use-of-seq_printf-return-value
+++ a/drivers/rtc/rtc-tegra.c
@@ -261,7 +261,9 @@ static int tegra_rtc_proc(struct device
 	if (!dev || !dev->driver)
 		return 0;
 
-	return seq_printf(seq, "name\t\t: %s\n", dev_name(dev));
+	seq_printf(seq, "name\t\t: %s\n", dev_name(dev));
+
+	return 0;
 }
 
 static irqreturn_t tegra_rtc_irq_handler(int irq, void *data)
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

