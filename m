From: akpm@linux-foundation.org
Subject: + ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:19 -0700
Message-ID: <201005042254.o44MsK5B023815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934441Ab0EDWyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: attempt to register multiple SIs of the same type
has been added to the -mm tree.  Its filename is
     ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch

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
Subject: ipmi: attempt to register multiple SIs of the same type
From: Matthew Garrett <mjg@redhat.com>

Some odd systems may have multiple BMCs, and we want to be able to support
them.  Let's make the assumption that if a system legitimately has
multiple BMCs then each BMC's SI will be of the same type, and also that
we won't see multiple SIs of the same type unless we have multiple BMCs. 
If these hold true then we should register all SIs of the same type.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-attempt-to-register-multiple-sis-of-the-same-type drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-attempt-to-register-multiple-sis-of-the-same-type
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3279,6 +3279,7 @@ static __devinit int init_ipmi_si(void)
 	char *str;
 	int  rv;
 	struct smi_info *e;
+	enum ipmi_addr_src type = SI_INVALID;
 
 	if (initialized)
 		return 0;
@@ -3345,30 +3346,43 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
-	/* Try to register something with interrupts first */
+	/* We prefer devices with interrupts, but in the case of a machine
+	   with multiple BMCs we assume that there will be several instances
+	   of a given type so if we succeed in registering a type then also
+	   try to register everything else of the same type */
 
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry(e, &smi_infos, link) {
-		if (e->irq) {
+		/* Try to register a device if it has an IRQ and we either
+		   haven't successfully registered a device yet or this
+		   device has the same type as one we successfully registered */
+		if (e->irq && (!type || e->addr_source == type)) {
 			if (!try_smi_init(e)) {
-				mutex_unlock(&smi_infos_lock);
-				return 0;
+				type = e->addr_source;
 			}
 		}
 	}
 
+	/* type will only have been set if we successfully registered an si */
+	if (type) {
+		mutex_unlock(&smi_infos_lock);
+		return 0;
+	}
+
 	/* Fall back to the preferred device */
 
 	list_for_each_entry(e, &smi_infos, link) {
-		if (!e->irq) {
+		if (!e->irq && (!type || e->addr_source == type)) {
 			if (!try_smi_init(e)) {
-				mutex_unlock(&smi_infos_lock);
-				return 0;
+				type = e->addr_source;
 			}
 		}
 	}
 	mutex_unlock(&smi_infos_lock);
 
+	if (type)
+		return 0;
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {
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

