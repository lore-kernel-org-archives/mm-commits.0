From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 15:27:35 -0800
Message-ID: <52e1a567.Mr6HYUELpkx/iDn2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaAWX1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:27:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@nvidia.com

Subject: [folded-merged] rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch removed from -mm tree
To: swarren@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:27:35 -0800


The patch titled
     Subject: rtc-honor-device-tree-alias-entries-when-assigning-ids-v2
has been removed from the -mm tree.  Its filename was
     rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch

This patch was dropped because it was folded into rtc-honor-device-tree-alias-entries-when-assigning-ids.patch

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: rtc-honor-device-tree-alias-entries-when-assigning-ids-v2

v2: Explicitly check for both dev->of_node and dev->parent->of_node.
    This covers the MFD case, without the MFD core having to set
    child MFD devices' of_node pointer to the same node as the top-
    level MFD device, which causes problems such as:
    http://www.spinics.net/lists/arm-kernel/msg295854.html

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/class.c~rtc-honor-device-tree-alias-entries-when-assigning-ids-v2 drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-honor-device-tree-alias-entries-when-assigning-ids-v2
+++ a/drivers/rtc/class.c
@@ -158,17 +158,19 @@ struct rtc_device *rtc_device_register(c
 {
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
-	int of_id, id = -1, err;
+	int of_id = -1, id = -1, err;
 
-	if (dev->of_node) {
+	if (dev->of_node)
 		of_id = of_alias_get_id(dev->of_node, "rtc");
-		if (of_id >= 0) {
-			id = ida_simple_get(&rtc_ida, of_id, of_id + 1,
-					    GFP_KERNEL);
-			if (id < 0)
-				dev_warn(dev, "/aliases ID %d not available\n",
-					 of_id);
-		}
+	else if (dev->parent && dev->parent->of_node)
+		of_id = of_alias_get_id(dev->parent->of_node, "rtc");
+
+	if (of_id >= 0) {
+		id = ida_simple_get(&rtc_ida, of_id, of_id + 1,
+				    GFP_KERNEL);
+		if (id < 0)
+			dev_warn(dev, "/aliases ID %d not available\n",
+				    of_id);
 	}
 
 	if (id < 0) {
_

Patches currently in -mm which might be from swarren@nvidia.com are

origin.patch
rtc-honor-device-tree-alias-entries-when-assigning-ids.patch
rtc-max8907-weekday-encoding-fixes.patch

