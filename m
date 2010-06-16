From: akpm@linux-foundation.org
Subject: + hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch added to -mm tree
Date: Wed, 16 Jun 2010 13:39:04 -0700
Message-ID: <201006162039.o5GKd4gY026583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab0FPUjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jun 2010 16:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, axel.lin@gmail.com, len.brown@intel.com, mjg@redhat.com


The patch titled
     hp-wmi: return -ENODEV if BIOS does not export any supported hp wmi guid
has been added to the -mm tree.  Its filename is
     hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch

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
Subject: hp-wmi: return -ENODEV if BIOS does not export any supported hp wmi guid
From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid
+++ a/drivers/platform/x86/hp-wmi.c
@@ -711,8 +711,10 @@ static int hp_wmi_resume_handler(struct 
 static int __init hp_wmi_init(void)
 {
 	int err;
+	int event_capable = wmi_has_guid(HPWMI_EVENT_GUID);
+	int bios_capable = wmi_has_guid(HPWMI_BIOS_GUID);
 
-	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
+	if (event_capable) {
 		err = wmi_install_notify_handler(HPWMI_EVENT_GUID,
 						 hp_wmi_notify, NULL);
 		if (ACPI_FAILURE(err))
@@ -724,7 +726,7 @@ static int __init hp_wmi_init(void)
 		}
 	}
 
-	if (wmi_has_guid(HPWMI_BIOS_GUID)) {
+	if (bios_capable) {
 		err = platform_driver_register(&hp_wmi_driver);
 		if (err)
 			goto err_driver_reg;
@@ -738,6 +740,9 @@ static int __init hp_wmi_init(void)
 			goto err_device_add;
 	}
 
+	if (!bios_capable && !event_capable)
+		return -ENODEV;
+
 	return 0;
 
 err_device_add:
_

Patches currently in -mm which might be from trenn@suse.de are

linux-next.patch
wmi-fix-memory-leak-in-parse_wdg.patch
hp-wmi-add-error-handling-for-hp_wmi_init.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch

