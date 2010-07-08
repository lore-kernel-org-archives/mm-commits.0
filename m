From: akpm@linux-foundation.org
Subject: + acerhdf-make-needlessly-global-symbols-static.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:39:06 -0700
Message-ID: <201007081939.o68Jd6mM024098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758521Ab0GHTt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, bp@alien8.de, mjg@redhat.com, peter@piie.net


The patch titled
     acerhdf: make needlessly global symbols static
has been added to the -mm tree.  Its filename is
     acerhdf-make-needlessly-global-symbols-static.patch

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
Subject: acerhdf: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>

The following symbols are needlessly defined global:

thz_dev
cl_dev
acerhdf_dev
acerhdf_dev_ops
acerhdf_cooling_ops

This patch makes the symbols static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Peter Feuerer <peter@piie.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-make-needlessly-global-symbols-static drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-make-needlessly-global-symbols-static
+++ a/drivers/platform/x86/acerhdf.c
@@ -92,9 +92,9 @@ static unsigned int fanstate = ACERHDF_F
 static char force_bios[16];
 static char force_product[16];
 static unsigned int prev_interval;
-struct thermal_zone_device *thz_dev;
-struct thermal_cooling_device *cl_dev;
-struct platform_device *acerhdf_dev;
+static struct thermal_zone_device *thz_dev;
+static struct thermal_cooling_device *cl_dev;
+static struct platform_device *acerhdf_dev;
 
 module_param(kernelmode, uint, 0);
 MODULE_PARM_DESC(kernelmode, "Kernel mode fan control on / off");
@@ -406,7 +406,7 @@ static int acerhdf_get_crit_temp(struct 
 }
 
 /* bind callback functions to thermalzone */
-struct thermal_zone_device_ops acerhdf_dev_ops = {
+static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.bind = acerhdf_bind,
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
@@ -481,7 +481,7 @@ err_out:
 }
 
 /* bind fan callbacks to fan device */
-struct thermal_cooling_device_ops acerhdf_cooling_ops = {
+static struct thermal_cooling_device_ops acerhdf_cooling_ops = {
 	.get_max_state = acerhdf_get_max_state,
 	.get_cur_state = acerhdf_get_cur_state,
 	.set_cur_state = acerhdf_set_cur_state,
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
acerhdf-make-needlessly-global-symbols-static.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

