From: akpm@linux-foundation.org
Subject: + ipmi-increase-kcs-timeouts.patch added to -mm tree
Date: Fri, 03 Feb 2012 11:52:18 -0800
Message-ID: <20120203195218.C44E4A00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:40785 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2BCTwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 14:52:19 -0500
Received: by yhgm50 with SMTP id m50so433572yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 11:52:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     Subject: ipmi: increase KCS timeouts
has been added to the -mm tree.  Its filename is
     ipmi-increase-kcs-timeouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: ipmi: increase KCS timeouts

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
hrtimers-special-case-zero-length-sleeps.patch
ipmi-increase-kcs-timeouts.patch

