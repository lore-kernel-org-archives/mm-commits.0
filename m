From: akpm@linux-foundation.org
Subject: + drm-edid-convert-to-use-match_string-helper.patch added to -mm
 tree
Date: Mon, 01 Feb 2016 22:10:32 -0800
Message-ID: <56b04858.vqDNAVzqeZQlIQEp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbcBBGKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/edid: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     drm-edid-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-edid-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-edid-convert-to-use-match_string-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drm/edid: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_edid_load.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/drm_edid_load.c~drm-edid-convert-to-use-match_string-helper drivers/gpu/drm/drm_edid_load.c
--- a/drivers/gpu/drm/drm_edid_load.c~drm-edid-convert-to-use-match_string-helper
+++ a/drivers/gpu/drm/drm_edid_load.c
@@ -170,16 +170,11 @@ static void *edid_load(struct drm_connec
 	int i, valid_extensions = 0;
 	bool print_bad_edid = !connector->bad_edid_counter || (drm_debug & DRM_UT_KMS);
 
-	builtin = 0;
-	for (i = 0; i < GENERIC_EDIDS; i++) {
-		if (strcmp(name, generic_edid_name[i]) == 0) {
-			fwdata = generic_edid[i];
-			fwsize = sizeof(generic_edid[i]);
-			builtin = 1;
-			break;
-		}
-	}
-	if (!builtin) {
+	builtin = match_string(generic_edid_name, GENERIC_EDIDS, name);
+	if (builtin >= 0) {
+		fwdata = generic_edid[builtin];
+		fwsize = sizeof(generic_edid[builtin]);
+	} else {
 		struct platform_device *pdev;
 		int err;
 
@@ -252,7 +247,7 @@ static void *edid_load(struct drm_connec
 	}
 
 	DRM_INFO("Got %s EDID base block and %d extension%s from "
-	    "\"%s\" for connector \"%s\"\n", builtin ? "built-in" :
+	    "\"%s\" for connector \"%s\"\n", (builtin >= 0) ? "built-in" :
 	    "external", valid_extensions, valid_extensions == 1 ? "" : "s",
 	    name, connector_name);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
device-property-convert-to-use-match_string-helper.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch
lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

