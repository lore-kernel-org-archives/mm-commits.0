From: akpm@linux-foundation.org
Subject: + ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch added to -mm tree
Date: Fri, 03 Feb 2012 11:52:16 -0800
Message-ID: <20120203195217.478BDA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40204 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2BCTwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 14:52:19 -0500
Received: by eaag13 with SMTP id g13so11683eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 11:52:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivas_g_gowda@dell.com, cminyard@mvista.com


The patch titled
     Subject: ipmi: decrease the IPMI message transaction time in interrupt mode
has been added to the -mm tree.  Its filename is
     ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srinivas_Gowda <srinivas_g_gowda@dell.com>
Subject: ipmi: decrease the IPMI message transaction time in interrupt mode

Call the event handler immediately after starting the next message.

This change considerably decreases the IPMI transaction time (cuts off
~9ms for a single ipmitool transaction).

Signed-off-by: Srinivas_Gowda <srinivas_g_gowda@dell.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -932,8 +932,10 @@ static void sender(void                *
 	spin_unlock_irqrestore(&smi_info->msg_lock, flags);
 
 	spin_lock_irqsave(&smi_info->si_lock, flags);
-	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL)
+	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
 		start_next_msg(smi_info);
+		smi_event_handler(smi_info, 0);
+	}
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
_
Subject: Subject: ipmi: decrease the IPMI message transaction time in interrupt mode

Patches currently in -mm which might be from srinivas_g_gowda@dell.com are

ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch

