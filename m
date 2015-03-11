From: akpm@linux-foundation.org
Subject: [merged] staging-i2o-remove-use-of-seq_printf-return-value.patch
 removed from -mm tree
Date: Wed, 11 Mar 2015 12:17:45 -0700
Message-ID: <550094d9.AOSaZKosFygAAQUT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: i2o: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     staging-i2o-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: i2o: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/i2o/i2o_proc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/staging/i2o/i2o_proc.c~staging-i2o-remove-use-of-seq_printf-return-value drivers/staging/i2o/i2o_proc.c
--- a/drivers/staging/i2o/i2o_proc.c~staging-i2o-remove-use-of-seq_printf-return-value
+++ a/drivers/staging/i2o/i2o_proc.c
@@ -266,16 +266,22 @@ static int i2o_report_query_status(struc
 {
 	switch (block_status) {
 	case -ETIMEDOUT:
-		return seq_printf(seq, "Timeout reading group %s.\n", group);
+		seq_printf(seq, "Timeout reading group %s.\n", group);
+		break;
 	case -ENOMEM:
-		return seq_printf(seq, "No free memory to read the table.\n");
+		seq_puts(seq, "No free memory to read the table.\n");
+		break;
 	case -I2O_PARAMS_STATUS_INVALID_GROUP_ID:
-		return seq_printf(seq, "Group %s not supported.\n", group);
+		seq_printf(seq, "Group %s not supported.\n", group);
+		break;
 	default:
-		return seq_printf(seq,
-				  "Error reading group %s. BlockStatus 0x%02X\n",
-				  group, -block_status);
+		seq_printf(seq,
+			   "Error reading group %s. BlockStatus 0x%02X\n",
+			   group, -block_status);
+		break;
 	}
+
+	return 0;
 }
 
 static char *bus_strings[] = {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
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

