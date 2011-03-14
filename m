From: akpm@linux-foundation.org
Subject: [merged] rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch removed from -mm tree
Date: Mon, 14 Mar 2011 12:45:07 -0700
Message-ID: <201103141947.p2EJl5oS006925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab1CNTrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 15:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroberto@cpti.cetuc.puc-rio.br, a.zummo@towertech.it, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: include information about UIE and PIE in RTC driver proc.
has been removed from the -mm tree.  Its filename was
     rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: include information about UIE and PIE in RTC driver proc.
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

Generic RTC code is always able to provide the necessary information about
update and periodic interrupts.  This patch add such information to the
proc interface.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-proc.c~rtc-include-information-about-uie-and-pie-in-rtc-driver-proc drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-include-information-about-uie-and-pie-in-rtc-driver-proc
+++ a/drivers/rtc/rtc-proc.c
@@ -69,6 +69,14 @@ static int rtc_proc_show(struct seq_file
 				alrm.enabled ? "yes" : "no");
 		seq_printf(seq, "alrm_pending\t: %s\n",
 				alrm.pending ? "yes" : "no");
+		seq_printf(seq, "update IRQ enabled\t: %s\n",
+			(rtc->uie_rtctimer.enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ enabled\t: %s\n",
+			(rtc->pie_enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ frequency\t: %d\n",
+			rtc->irq_freq);
+		seq_printf(seq, "max user IRQ frequency\t: %d\n",
+			rtc->max_user_freq);
 	}
 
 	seq_printf(seq, "24hr\t\t: yes\n");
_

Patches currently in -mm which might be from mroberto@cpti.cetuc.puc-rio.br are

linux-next.patch

