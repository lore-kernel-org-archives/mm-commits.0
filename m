From: akpm@linux-foundation.org
Subject: [merged] acer-wmi-fix-regression-in-backlight-detection.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:38 -0700
Message-ID: <200903131819.n2DIJcJ3008614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZCMS0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mspang@csclub.uwaterloo.ca, ak@linux.intel.com, carlos@strangeworlds.co.uk, len.brown@intel.com, rjw@sisk.pl, rui.zhang@intel.com, stable@kernel.org, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     acer-wmi: fix regression in backlight detection
has been removed from the -mm tree.  Its filename was
     acer-wmi-fix-regression-in-backlight-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Thomas Renninger <trenn@suse.de>
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

origin.patch

