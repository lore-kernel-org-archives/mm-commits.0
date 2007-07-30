From: akpm@linux-foundation.org
Subject: + acpi-bay-send-envp-with-uevent-fix.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:05:55 -0700
Message-ID: <200707302105.l6UL5tnY030394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938200AbXG3VGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.berberig@arcor.de, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     ACPI: bay: send envp with uevent - fix
has been added to the -mm tree.  Its filename is
     acpi-bay-send-envp-with-uevent-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: bay: send envp with uevent - fix
From: Stephan Berberig <s.berberig@arcor.de>

There must not be a new-line character in the uevent.  Otherwise, udev gets
confused.  Thanks to Kay Sievers for pointing it out.

Signed-off-by: Stephan Berberig <s.berberig@arcor.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bay.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/bay.c~acpi-bay-send-envp-with-uevent-fix drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~acpi-bay-send-envp-with-uevent-fix
+++ a/drivers/acpi/bay.c
@@ -337,7 +337,7 @@ static void bay_notify(acpi_handle handl
 	char *envp[] = { event_string, NULL };
 
 	bay_dprintk(handle, "Bay event");
-	sprintf(event_string, "BAY_EVENT=%d\n", event);
+	sprintf(event_string, "BAY_EVENT=%d", event);
 	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
_

Patches currently in -mm which might be from s.berberig@arcor.de are

acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
