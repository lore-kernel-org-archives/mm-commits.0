From: akpm@linux-foundation.org
Subject: [merged] rtc-remove-use-of-seq_printf-return-value.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:55:16 -0700
Message-ID: <552fe974.JTG0N7GeOAuuN8u+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbbDPQtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     rtc-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

