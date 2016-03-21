From: akpm@linux-foundation.org
Subject: [merged] pinctrl-convert-to-use-match_string-helper.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:07 -0700
Message-ID: <56f0407f.BfwkoRZUzQve9x6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbcCUTV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pinctrl: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     pinctrl-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


