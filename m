From: akpm@linux-foundation.org
Subject: [merged] device-property-convert-to-use-match_string-helper.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:04 -0700
Message-ID: <56f0407c.v4agqnWfTDc0ftp3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbcCUTVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: device property: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     device-property-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: device property: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/property.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/base/property.c~device-property-convert-to-use-match_string-helper drivers/base/property.c
--- a/drivers/base/property.c~device-property-convert-to-use-match_string-helper
+++ a/drivers/base/property.c
@@ -651,7 +651,7 @@ int fwnode_property_match_string(struct
 	const char *propname, const char *string)
 {
 	const char **values;
-	int nval, ret, i;
+	int nval, ret;
 
 	nval = fwnode_property_read_string_array(fwnode, propname, NULL, 0);
 	if (nval < 0)
@@ -668,13 +668,9 @@ int fwnode_property_match_string(struct
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
+	if (ret < 0)
+		ret = -ENODATA;
 out:
 	kfree(values);
 	return ret;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


