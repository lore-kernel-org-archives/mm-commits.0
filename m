From: akpm@linux-foundation.org
Subject: + device-property-convert-to-use-match_string-helper-fix.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 12:17:43 -0800
Message-ID: <56b8f7e7.k3ya0xzlf1WFK9FJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcBHURn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 15:17:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: device-property-convert-to-use-match_string-helper fix
has been added to the -mm tree.  Its filename is
     device-property-convert-to-use-match_string-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-property-convert-to-use-match_string-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-property-convert-to-use-match_string-helper-fix.patch

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
lib-string-introduce-match_string-helper-fix.patch
device-property-convert-to-use-match_string-helper.patch
device-property-convert-to-use-match_string-helper-fix.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch
lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

