From: akpm@linux-foundation.org
Subject: [merged]
 regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
 removed from -mm tree
Date: Wed, 25 Feb 2015 12:51:58 -0800
Message-ID: <54ee35ee.82UZZth0ZgLADpjL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbBYUwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 15:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, broonie@kernel.org, lgirdwood@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: regulator: dbx500: remove use of seq_puts/seq_printf return value
has been removed from the -mm tree.  Its filename was
     regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: regulator: dbx500: remove use of seq_puts/seq_printf return value

The seq_puts/seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Miscellanea:

o Remove unnecessary dev_err("seq_<foo> overflow\n") messages

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/dbx500-prcmu.c |   32 ++++++++---------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff -puN drivers/regulator/dbx500-prcmu.c~regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value drivers/regulator/dbx500-prcmu.c
--- a/drivers/regulator/dbx500-prcmu.c~regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value
+++ a/drivers/regulator/dbx500-prcmu.c
@@ -95,14 +95,9 @@ void ux500_regulator_resume_debug(void)
 
 static int ux500_regulator_power_state_cnt_print(struct seq_file *s, void *p)
 {
-	struct device *dev = s->private;
-	int err;
-
 	/* print power state count */
-	err = seq_printf(s, "ux500-regulator power state count: %i\n",
-		power_state_active_get());
-	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+	seq_printf(s, "ux500-regulator power state count: %i\n",
+		   power_state_active_get());
 
 	return 0;
 }
@@ -124,19 +119,11 @@ static const struct file_operations ux50
 
 static int ux500_regulator_status_print(struct seq_file *s, void *p)
 {
-	struct device *dev = s->private;
-	int err;
 	int i;
 
 	/* print dump header */
-	err = seq_puts(s, "ux500-regulator status:\n");
-	if (err < 0)
-		dev_err(dev, "seq_puts overflow\n");
-
-	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
-		"before", "after");
-	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+	seq_puts(s, "ux500-regulator status:\n");
+	seq_printf(s, "%31s : %8s : %8s\n", "current", "before", "after");
 
 	for (i = 0; i < rdebug.num_regulators; i++) {
 		struct dbx500_regulator_info *info;
@@ -144,12 +131,11 @@ static int ux500_regulator_status_print(
 		info = &rdebug.regulator_array[i];
 
 		/* print status */
-		err = seq_printf(s, "%20s : %8s : %8s : %8s\n", info->desc.name,
-			info->is_enabled ? "enabled" : "disabled",
-			rdebug.state_before_suspend[i] ? "enabled" : "disabled",
-			rdebug.state_after_suspend[i] ? "enabled" : "disabled");
-		if (err < 0)
-			dev_err(dev, "seq_printf overflow\n");
+		seq_printf(s, "%20s : %8s : %8s : %8s\n",
+			   info->desc.name,
+			   info->is_enabled ? "enabled" : "disabled",
+			   rdebug.state_before_suspend[i] ? "enabled" : "disabled",
+			   rdebug.state_after_suspend[i] ? "enabled" : "disabled");
 	}
 
 	return 0;
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
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

