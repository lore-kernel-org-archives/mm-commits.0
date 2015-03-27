From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch removed from
 -mm tree
Date: Fri, 27 Mar 2015 11:17:16 -0700
Message-ID: <55159eac.8YYAsIZmQYm2nHJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbC0SRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: bcm281xx: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: watchdog: bcm281xx: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Guenter Roeck <linux~roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/bcm_kona_wdt.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/watchdog/bcm_kona_wdt.c~watchdog-bcm281xx-remove-use-of-seq_printf-return-value drivers/watchdog/bcm_kona_wdt.c
--- a/drivers/watchdog/bcm_kona_wdt.c~watchdog-bcm281xx-remove-use-of-seq_printf-return-value
+++ a/drivers/watchdog/bcm_kona_wdt.c
@@ -99,12 +99,14 @@ static int secure_register_read(struct b
 
 static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
 {
-	int ctl_val, cur_val, ret;
+	int ctl_val, cur_val;
 	unsigned long flags;
 	struct bcm_kona_wdt *wdt = s->private;
 
-	if (!wdt)
-		return seq_puts(s, "No device pointer\n");
+	if (!wdt) {
+		seq_puts(s, "No device pointer\n");
+		return 0;
+	}
 
 	spin_lock_irqsave(&wdt->lock, flags);
 	ctl_val = secure_register_read(wdt, SECWDOG_CTRL_REG);
@@ -112,7 +114,7 @@ static int bcm_kona_wdt_dbg_show(struct
 	spin_unlock_irqrestore(&wdt->lock, flags);
 
 	if (ctl_val < 0 || cur_val < 0) {
-		ret = seq_puts(s, "Error accessing hardware\n");
+		seq_puts(s, "Error accessing hardware\n");
 	} else {
 		int ctl, cur, ctl_sec, cur_sec, res;
 
@@ -121,15 +123,18 @@ static int bcm_kona_wdt_dbg_show(struct
 		cur = cur_val & SECWDOG_COUNT_MASK;
 		ctl_sec = TICKS_TO_SECS(ctl, wdt);
 		cur_sec = TICKS_TO_SECS(cur, wdt);
-		ret = seq_printf(s, "Resolution: %d / %d\n"
-				"Control: %d s / %d (%#x) ticks\n"
-				"Current: %d s / %d (%#x) ticks\n"
-				"Busy count: %lu\n", res,
-				wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
-				cur, cur, wdt->busy_count);
+		seq_printf(s,
+			   "Resolution: %d / %d\n"
+			   "Control: %d s / %d (%#x) ticks\n"
+			   "Current: %d s / %d (%#x) ticks\n"
+			   "Busy count: %lu\n",
+			   res, wdt->resolution,
+			   ctl_sec, ctl, ctl,
+			   cur_sec, cur, cur,
+			   wdt->busy_count);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
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
adfs-returning-correct-return-values.patch
linux-next.patch

