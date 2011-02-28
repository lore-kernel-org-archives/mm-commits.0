From: akpm@linux-foundation.org
Subject: + rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch added to -mm tree
Date: Mon, 28 Feb 2011 14:48:44 -0800
Message-ID: <201102282248.p1SMmiWZ001733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab1B1WtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 17:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroberto@cpti.cetuc.puc-rio.br, a.zummo@towertech.it, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     rtc: include information about UIE and PIE in RTC driver proc.
has been added to the -mm tree.  Its filename is
     rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch

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

rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch

