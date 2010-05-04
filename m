From: akpm@linux-foundation.org
Subject: + ipmi-only-register-one-si-per-bmc.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:11 -0700
Message-ID: <201005042254.o44MsBjj023803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934394Ab0EDWyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: only register one si per bmc
has been added to the -mm tree.  Its filename is
     ipmi-only-register-one-si-per-bmc.patch

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
Subject: ipmi: only register one si per bmc
From: Matthew Garrett <mjg@redhat.com>

Only register one si per bmc.  Use any user-provided devices first,
followed by the first device with an irq, followed by the first device
discovered.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-only-register-one-si-per-bmc drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-only-register-one-si-per-bmc
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3299,6 +3299,14 @@ static __devinit int init_ipmi_si(void)
 
 	hardcode_find_bmc();
 
+	/* If the user gave us a device, they presumably want us to use it */
+	mutex_lock(&smi_infos_lock);
+	if (!list_empty(&smi_infos)) {
+		mutex_unlock(&smi_infos_lock);
+		return 0;
+	}
+	mutex_unlock(&smi_infos_lock);
+
 #ifdef CONFIG_DMI
 	dmi_find_bmc();
 #endif
@@ -3322,10 +3330,27 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
+	/* Try to register something with interrupts first */
+
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry(e, &smi_infos, link) {
-		if (!e->si_sm)
-			try_smi_init(e);
+		if (e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
+	}
+
+	/* Fall back to the preferred device */
+
+	list_for_each_entry(e, &smi_infos, link) {
+		if (!e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
 	}
 	mutex_unlock(&smi_infos_lock);
 
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch
ipmi-change-addr_source-to-an-enum-rather-than-strings.patch
ipmi-split-device-discovery-and-registration.patch
ipmi-only-register-one-si-per-bmc.patch
ipmi-change-device-discovery-order.patch
ipmi-reduce-polling-when-interrupts-are-available.patch
ipmi-reduce-polling.patch
ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch

