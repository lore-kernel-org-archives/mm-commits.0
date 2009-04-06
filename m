From: akpm@linux-foundation.org
Subject: [merged] hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:16 -0700
Message-ID: <200904061936.n36JaGoQ012416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442AbZDFTmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, Robert.Picco@hp.com, clemens@ladisch.de, mingo@elte.hu, paul.gortmaker@windriver.com, venkatesh.pallipadi@intel.com, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hpet: fix the possibility of insane return value of hpet_calibrate() against SMI
has been removed from the -mm tree.  Its filename was
     hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: fix the possibility of insane return value of hpet_calibrate() against SMI
From: Yasunori Goto <y-goto@jp.fujitsu.com>

hpet_calibrate() has a possibility of miss-calibration due to SMI.  If SMI
interrupts in the while loop of calibration, then return value will be
big.  This change calibrates until stabilizing by the return value with a
small value.

[akpm@linux-foundation.org: trivial style tweaks]
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Acked-by: Vojtech Pavlik <vojtech@suse.cz>
Cc: Robert Picco <Robert.Picco@hp.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/char/hpet.c~hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi
+++ a/drivers/char/hpet.c
@@ -713,7 +713,7 @@ static struct ctl_table_header *sysctl_h
  */
 #define	TICK_CALIBRATE	(1000UL)
 
-static unsigned long hpet_calibrate(struct hpets *hpetp)
+static unsigned long __hpet_calibrate(struct hpets *hpetp)
 {
 	struct hpet_timer __iomem *timer = NULL;
 	unsigned long t, m, count, i, flags, start;
@@ -750,6 +750,26 @@ static unsigned long hpet_calibrate(stru
 	return (m - start) / i;
 }
 
+static unsigned long hpet_calibrate(struct hpets *hpetp)
+{
+	unsigned long ret = -1;
+	unsigned long tmp;
+
+	/*
+	 * Try to calibrate until return value becomes stable small value.
+	 * If SMI interruption occurs in calibration loop, the return value
+	 * will be big. This avoids its impact.
+	 */
+	for ( ; ; ) {
+		tmp = __hpet_calibrate(hpetp);
+		if (ret <= tmp)
+			break;
+		ret = tmp;
+	}
+
+	return ret;
+}
+
 int hpet_alloc(struct hpet_data *hdp)
 {
 	u64 cap, mcfg;
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch

