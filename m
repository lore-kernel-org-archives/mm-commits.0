From: akpm@linux-foundation.org
Subject: + device-property-convert-to-use-match_string-helper.patch added
 to -mm tree
Date: Mon, 01 Feb 2016 22:10:30 -0800
Message-ID: <56b04856.i+5sN2rq3M2K3cY5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbcBBGKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: device property: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     device-property-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-property-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-property-convert-to-use-match_string-helper.patch

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
Subject: device property: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/property.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/base/property.c~device-property-convert-to-use-match_string-helper drivers/base/property.c
--- a/drivers/base/property.c~device-property-convert-to-use-match_string-helper
+++ a/drivers/base/property.c
@@ -647,7 +647,7 @@ int fwnode_property_match_string(struct 
 	const char *propname, const char *string)
 {
 	const char **values;
-	int nval, ret, i;
+	int nval, ret;
 
 	nval = fwnode_property_read_string_array(fwnode, propname, NULL, 0);
 	if (nval < 0)
@@ -664,13 +664,7 @@ int fwnode_property_match_string(struct 
 	if (ret < 0)
 		goto out;
 
-	ret = -ENODATA;
-	for (i = 0; i < nval; i++) {
-		if (!strcmp(values[i], string)) {
-			ret = i;
-			break;
-		}
-	}
+	ret = match_string(values, nval, string);
 out:
 	kfree(values);
 	return ret;
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

