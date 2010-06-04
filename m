From: akpm@linux-foundation.org
Subject: + acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:39:49 -0700
Message-ID: <201006042239.o54MdnX5022445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab0FDWkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, mjg@redhat.com


The patch titled
     acer-wmi/hp-wmi: use platform_device_unregister instead of platform_device_del in module_exit
has been added to the -mm tree.  Its filename is
     acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch

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
Subject: acer-wmi/hp-wmi: use platform_device_unregister instead of platform_device_del in module_exit
From: Axel Lin <axel.lin@gmail.com>

platform_device_unregister() will also call platform_device_put() to drop
reference count.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |    2 +-
 drivers/platform/x86/hp-wmi.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit
+++ a/drivers/platform/x86/acer-wmi.c
@@ -1358,7 +1358,7 @@ static void __exit acer_wmi_exit(void)
 {
 	remove_sysfs(acer_platform_device);
 	remove_debugfs();
-	platform_device_del(acer_platform_device);
+	platform_device_unregister(acer_platform_device);
 	platform_driver_unregister(&acer_platform_driver);
 
 	printk(ACER_INFO "Acer Laptop WMI Extras unloaded\n");
diff -puN drivers/platform/x86/hp-wmi.c~acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit
+++ a/drivers/platform/x86/hp-wmi.c
@@ -611,7 +611,7 @@ static void __exit hp_wmi_exit(void)
 		input_unregister_device(hp_wmi_input_dev);
 	}
 	if (hp_wmi_platform_dev) {
-		platform_device_del(hp_wmi_platform_dev);
+		platform_device_unregister(hp_wmi_platform_dev);
 		platform_driver_unregister(&hp_wmi_driver);
 	}
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

wmi-fix-memory-leak-in-parse_wdg.patch
acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch
intel_menlow-fix-memory-leaks-in-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe.patch

