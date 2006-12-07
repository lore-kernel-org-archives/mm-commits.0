From: akpm@osdl.org
Subject: - ipmi-add-poll-delay.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:39 -0800
Message-ID: <200612072317.kB7NHdue030950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163884AbWLGXRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: add poll delay
has been removed from the -mm tree.  Its filename was
     ipmi-add-poll-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: add poll delay
From: Corey Minyard <minyard@acm.org>

Make sure to delay a little in the IPMI poll routine so we can pass in a
timeout time and thus time things out.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-poll-delay drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-poll-delay
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -807,7 +807,12 @@ static void poll(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
 
-	smi_event_handler(smi_info, 0);
+	/*
+	 * Make sure there is some delay in the poll loop so we can
+	 * drive time forward and timeout things.
+	 */
+	udelay(10);
+	smi_event_handler(smi_info, 10);
 }
 
 static void request_events(void *send_info)
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

