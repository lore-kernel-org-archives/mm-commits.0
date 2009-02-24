From: akpm@linux-foundation.org
Subject: + acer-wmi-fix-regression-in-backlight-detection.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:53:04 -0800
Message-ID: <200902242153.n1OLr5WC014092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbZBXVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mspang@csclub.uwaterloo.ca, ak@linux.intel.com, carlos@strangeworlds.co.uk, len.brown@intel.com, rjw@sisk.pl, rui.zhang@intel.com, stable@kernel.org, trenn@suse.de


The patch titled
     acer-wmi: fix regression in backlight detection
has been added to the -mm tree.  Its filename is
     acer-wmi-fix-regression-in-backlight-detection.patch

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
Subject: acer-wmi: fix regression in backlight detection
From: Michael Spang <mspang@csclub.uwaterloo.ca>

Currently we disable the Acer WMI backlight device if there is no ACPI
backlight device.  As a result, we end up with no backlight device at all.
 We should instead disable it if there is an ACPI device, as the other
laptop drivers do.  This regression was introduced in febf2d9 ("Acer-WMI:
fingers off backlight if video.ko is serving this functionality").

Each laptop driver with backlight support got a similar change around
febf2d9.  The changes to the other drivers look correct; see e.g. 
a598c82f for a similar but correct change.  The regression is also in
2.6.28.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-fix-regression-in-backlight-detection drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-fix-regression-in-backlight-detection
+++ a/drivers/platform/x86/acer-wmi.c
@@ -1297,7 +1297,7 @@ static int __init acer_wmi_init(void)
 
 	set_quirks();
 
-	if (!acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
+	if (acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 		printk(ACER_INFO "Brightness must be controlled by "
 		       "generic video driver\n");
_

Patches currently in -mm which might be from mspang@csclub.uwaterloo.ca are

acer-wmi-fix-regression-in-backlight-detection.patch

