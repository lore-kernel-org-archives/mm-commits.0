From: akpm@linux-foundation.org
Subject: [merged] drm-edid-convert-to-use-match_string-helper.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:09 -0700
Message-ID: <56f04081.6ucqf+qBKJ32b23N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbcCUTV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/edid: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     drm-edid-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


