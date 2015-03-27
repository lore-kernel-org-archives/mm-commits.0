From: akpm@linux-foundation.org
Subject: [merged] i8k-remove-use-of-seq_printf-return-value.patch removed
 from -mm tree
Date: Fri, 27 Mar 2015 11:17:20 -0700
Message-ID: <55159eb0.TbaZQexLHNYwttzG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbbC0SRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, arnd@arndb.de, gregkh@linuxfoundation.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: i8k: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     i8k-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: i8k: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/char/i8k.c~i8k-remove-use-of-seq_printf-return-value drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-remove-use-of-seq_printf-return-value
+++ a/drivers/char/i8k.c
@@ -510,13 +510,15 @@ static int i8k_proc_show(struct seq_file
 	 * 9)  AC power
 	 * 10) Fn Key status
 	 */
-	return seq_printf(seq, "%s %s %s %d %d %d %d %d %d %d\n",
-			  I8K_PROC_FMT,
-			  bios_version,
-			  i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
-			  cpu_temp,
-			  left_fan, right_fan, left_speed, right_speed,
-			  ac_power, fn_key);
+	seq_printf(seq, "%s %s %s %d %d %d %d %d %d %d\n",
+		   I8K_PROC_FMT,
+		   bios_version,
+		   i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
+		   cpu_temp,
+		   left_fan, right_fan, left_speed, right_speed,
+		   ac_power, fn_key);
+
+	return 0;
 }
 
 static int i8k_open_fs(struct inode *inode, struct file *file)
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

