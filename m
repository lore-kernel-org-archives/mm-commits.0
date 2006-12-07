From: akpm@osdl.org
Subject: - ipmi-fix-request-events.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:37 -0800
Message-ID: <200612072317.kB7NHb2k030947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163873AbWLGXRk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix request events
has been removed from the -mm tree.  Its filename was
     ipmi-fix-request-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix request events
From: Corey Minyard <minyard@acm.org>

When the IPMI message handler requested that the interface look for events,
the ipmi_si driver would request flags, see if the event buffer full flag was
set, then request events.  It's better to just send the request for events, as
it cuts one message out of the transaction if there happens to be events, and
it will fetch events even if the event buffer was not full.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-request-events drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-request-events
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -684,22 +684,24 @@ static enum si_sm_result smi_event_handl
 	{
 		/* We are idle and the upper layer requested that I fetch
 		   events, so do so. */
-		unsigned char msg[2];
-
-		spin_lock(&smi_info->count_lock);
-		smi_info->flag_fetches++;
-		spin_unlock(&smi_info->count_lock);
-
 		atomic_set(&smi_info->req_events, 0);
-		msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
-		msg[1] = IPMI_GET_MSG_FLAGS_CMD;
+
+		smi_info->curr_msg = ipmi_alloc_smi_msg();
+		if (!smi_info->curr_msg)
+			goto out;
+
+		smi_info->curr_msg->data[0] = (IPMI_NETFN_APP_REQUEST << 2);
+		smi_info->curr_msg->data[1] = IPMI_READ_EVENT_MSG_BUFFER_CMD;
+		smi_info->curr_msg->data_size = 2;
 
 		smi_info->handlers->start_transaction(
-			smi_info->si_sm, msg, 2);
-		smi_info->si_state = SI_GETTING_FLAGS;
+			smi_info->si_sm,
+			smi_info->curr_msg->data,
+			smi_info->curr_msg->data_size);
+		smi_info->si_state = SI_GETTING_EVENTS;
 		goto restart;
 	}
-
+ out:
 	return si_sm_result;
 }
 
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

