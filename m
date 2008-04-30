From: akpm@linux-foundation.org
Subject: - ipmi-hold-attn-until-upper-layer-ready.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:31 -0700
Message-ID: <200804300544.m3U5iVtF029419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398AbYD3FuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, Patrick.Schoeller@hp.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: hold ATTN until upper layer ready
has been removed from the -mm tree.  Its filename was
     ipmi-hold-attn-until-upper-layer-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: hold ATTN until upper layer ready
From: Corey Minyard <cminyard@mvista.com>

Hold handling of ATTN until the upper layer has reported that it is
ready.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-hold-attn-until-upper-layer-ready drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-hold-attn-until-upper-layer-ready
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -723,8 +723,11 @@ static enum si_sm_result smi_event_handl
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
 	}
 
-	/* We prefer handling attn over new messages. */
-	if (si_sm_result == SI_SM_ATTN)
+	/*
+	 * We prefer handling attn over new messages.  But don't do
+	 * this if there is not yet an upper layer to handle anything.
+	 */
+	if (likely(smi_info->intf) && si_sm_result == SI_SM_ATTN)
 	{
 		unsigned char msg[2];
 
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

