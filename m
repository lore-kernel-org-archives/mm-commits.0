From: akpm@osdl.org
Subject: - ipmi-increase-kcs-message-size.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:51 -0800
Message-ID: <200612072317.kB7NHpJD030973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163886AbWLGXSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, Patrick.Schoeller@hp.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: increase KCS message size
has been removed from the -mm tree.  Its filename was
     ipmi-increase-kcs-message-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: increase KCS message size
From: Corey Minyard <minyard@acm.org>

Increase the maximum message size a KCS interface supports to the maximum
message size the rest of the driver supports.  Some systems really support
messages this big.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_kcs_sm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-increase-kcs-message-size drivers/char/ipmi/ipmi_kcs_sm.c
--- a/drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-increase-kcs-message-size
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -93,8 +93,8 @@ enum kcs_states {
 				   state machine. */
 };
 
-#define MAX_KCS_READ_SIZE 80
-#define MAX_KCS_WRITE_SIZE 80
+#define MAX_KCS_READ_SIZE IPMI_MAX_MSG_LENGTH
+#define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
 
 /* Timeouts in microseconds. */
 #define IBF_RETRY_TIMEOUT 1000000
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

