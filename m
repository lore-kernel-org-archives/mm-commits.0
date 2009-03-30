From: akpm@linux-foundation.org
Subject: + hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch added to -mm tree
Date: Mon, 30 Mar 2009 14:08:41 -0700
Message-ID: <200903302108.n2UL8fMH018671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121AbZC3VN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 17:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, Robert.Picco@hp.com, clemens@ladisch.de, mingo@elte.hu, paul.gortmaker@windriver.com, venkatesh.pallipadi@intel.com, vojtech@suse.cz


The patch titled
     hpet: fix the possibility of insane return value of hpet_calibrate() against SMI
has been added to the -mm tree.  Its filename is
     hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch

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
Subject: hpet: fix the possibility of insane return value of hpet_calibrate() against SMI
From: Yasunori Goto <y-goto@jp.fujitsu.com>

hpet_calibrate() has a possibility of miss-calibration due to SMI.  If SMI
interrupts in the while loop of calibration, then return value will be
big.  This change calibrates until stabilizing by the return value with a
small value.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Acked-by: Vojtech Pavlik <vojtech@suse.cz>
Cc: Robert Picco <Robert.Picco@hp.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

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
@@ -750,6 +750,25 @@ static unsigned long hpet_calibrate(stru
 	return (m - start) / i;
 }
 
+static unsigned long hpet_calibrate(struct hpets *hpetp)
+{
+	unsigned long ret = ~0UL, tmp;
+
+	/*
+	 * Try to calibrate until return value becomes stable small value.
+	 * If SMI interruption occurs in calibration loop, the return value
+	 * will be big. This avoids its impact.
+	 */
+	do {
+		tmp = __hpet_calibrate(hpetp);
+		if (ret <= tmp)
+			break;
+		ret = tmp;
+	} while (1);
+
+	return ret;
+}
+
 int hpet_alloc(struct hpet_data *hdp)
 {
 	u64 cap, mcfg;
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

linux-next.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch

