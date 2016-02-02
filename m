From: akpm@linux-foundation.org
Subject: + pinctrl-convert-to-use-match_string-helper.patch added to -mm
 tree
Date: Mon, 01 Feb 2016 22:10:31 -0800
Message-ID: <56b04857.9l1xJzDC5skNmr0u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbcBBGKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pinctrl: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     pinctrl-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pinctrl-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pinctrl-convert-to-use-match_string-helper.patch

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
Subject: pinctrl: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/pinmux.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/pinctrl/pinmux.c~pinctrl-convert-to-use-match_string-helper drivers/pinctrl/pinmux.c
--- a/drivers/pinctrl/pinmux.c~pinctrl-convert-to-use-match_string-helper
+++ a/drivers/pinctrl/pinmux.c
@@ -334,7 +334,6 @@ int pinmux_map_to_setting(struct pinctrl
 	unsigned num_groups;
 	int ret;
 	const char *group;
-	int i;
 
 	if (!pmxops) {
 		dev_err(pctldev->dev, "does not support mux function\n");
@@ -363,19 +362,13 @@ int pinmux_map_to_setting(struct pinctrl
 		return -EINVAL;
 	}
 	if (map->data.mux.group) {
-		bool found = false;
 		group = map->data.mux.group;
-		for (i = 0; i < num_groups; i++) {
-			if (!strcmp(group, groups[i])) {
-				found = true;
-				break;
-			}
-		}
-		if (!found) {
+		ret = match_string(groups, num_groups, group);
+		if (ret < 0) {
 			dev_err(pctldev->dev,
 				"invalid group \"%s\" for function \"%s\"\n",
 				group, map->data.mux.function);
-			return -EINVAL;
+			return ret;
 		}
 	} else {
 		group = groups[0];
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

