From: akpm@linux-foundation.org
Subject: [folded-merged]
 device-property-convert-to-use-match_string-helper-fix.patch removed from
 -mm tree
Date: Thu, 17 Mar 2016 14:02:53 -0700
Message-ID: <56eb1b7d.9PvI+A44X1Q/gxL4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620AbcCQVCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: device-property-convert-to-use-match_string-helper fix
has been removed from the -mm tree.  Its filename was
     device-property-convert-to-use-match_string-helper-fix.patch

This patch was dropped because it was folded into device-property-convert-to-use-match_string-helper.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: device-property-convert-to-use-match_string-helper fix

Since match_string() returns -EINVAL let's convert it to -ENODATA as designed
by device property API.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/property.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/property.c~device-property-convert-to-use-match_string-helper-fix drivers/base/property.c
--- a/drivers/base/property.c~device-property-convert-to-use-match_string-helper-fix
+++ a/drivers/base/property.c
@@ -665,6 +665,8 @@ int fwnode_property_match_string(struct
 		goto out;
 
 	ret = match_string(values, nval, string);
+	if (ret < 0)
+		ret = -ENODATA;
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

