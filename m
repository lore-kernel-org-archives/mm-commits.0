From: akpm@linux-foundation.org
Subject: [merged] ipmi-increase-kcs-timeouts.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:54 -0700
Message-ID: <20120329191354.5E101A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63583 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab2C2TNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:55 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so303448yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: increase KCS timeouts
has been removed from the -mm tree.  Its filename was
     ipmi-increase-kcs-timeouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matthew Garrett <mjg@redhat.com>
Subject: ipmi: increase KCS timeouts

We currently time out and retry KCS transactions after 1 second of waiting
for IBF or OBF.  This appears to be too short for some hardware.  The IPMI
spec says "All system software wait loops should include error timeouts. 
For simplicity, such timeouts are not shown explicitly in the flow
diagrams.  A five-second timeout or greater is recommended".  Change the
timeout to five seconds to satisfy the slow hardware.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_kcs_sm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-increase-kcs-timeouts drivers/char/ipmi/ipmi_kcs_sm.c
--- a/drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-increase-kcs-timeouts
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -118,8 +118,8 @@ enum kcs_states {
 #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
 
 /* Timeouts in microseconds. */
-#define IBF_RETRY_TIMEOUT 1000000
-#define OBF_RETRY_TIMEOUT 1000000
+#define IBF_RETRY_TIMEOUT 5000000
+#define OBF_RETRY_TIMEOUT 5000000
 #define MAX_ERROR_RETRIES 10
 #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
 
_

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

