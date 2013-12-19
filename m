From: akpm@linux-foundation.org
Subject: + rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch added to -mm tree
Date: Thu, 19 Dec 2013 13:58:49 -0800
Message-ID: <52b36c19.3vqZLLRWvcqV5Og/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3LSV6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 16:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@nvidia.com

Subject: + rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch added to -mm tree
To: swarren@nvidia.com
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 13:58:49 -0800


The patch titled
     Subject: rtc-honor-device-tree-alias-entries-when-assigning-ids-v2
has been added to the -mm tree.  Its filename is
     rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch
linux-next.patch

