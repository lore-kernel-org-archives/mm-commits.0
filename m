From: akpm@linux-foundation.org
Subject: [merged] ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:52 -0700
Message-ID: <20120329191352.62560A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65312 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab2C2TNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:53 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so303047yen.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas_g_gowda@dell.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: decrease the IPMI message transaction time in interrupt mode
has been removed from the -mm tree.  Its filename was
     ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from srinivas_g_gowda@dell.com are

origin.patch

