From: akpm@linux-foundation.org
Subject: [merged]
 rtc-honor-device-tree-alias-entries-when-assigning-ids.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:02:50 -0800
Message-ID: <52e2b8da.4v3o+gAl97p9zL16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaAXTCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@nvidia.com

Subject: [merged] rtc-honor-device-tree-alias-entries-when-assigning-ids.patch removed from -mm tree
To: swarren@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:50 -0800


The patch titled
     Subject: rtc: honor device tree /alias entries when assigning IDs
has been removed from the -mm tree.  Its filename was
     rtc-honor-device-tree-alias-entries-when-assigning-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: rtc: honor device tree /alias entries when assigning IDs

Assign RTC device IDs based on device tree /aliases entries if present,
falling back to the existing numbering scheme if there is no /aliases
entry (which includes when the system isn't booted using DT), or there is
a numbering conflict.

This is useful in systems with multiple RTC devices, to ensure that the
best RTC device is selected as /dev/rtc0, which provides the overall
system time.

For example, Tegra has an on-SoC RTC that is not battery backed, typically
coupled with an off-SoC RTC that is battery backed.  Only the latter is
useful for populating the system time, yet the former is useful e.g.  for
wakeup timing, since the time is not lost when the system is sleeps.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/class.c~rtc-honor-device-tree-alias-entries-when-assigning-ids drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-honor-device-tree-alias-entries-when-assigning-ids
+++ a/drivers/rtc/class.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
@@ -157,12 +158,27 @@ struct rtc_device *rtc_device_register(c
 {
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
-	int id, err;
+	int of_id = -1, id = -1, err;
+
+	if (dev->of_node)
+		of_id = of_alias_get_id(dev->of_node, "rtc");
+	else if (dev->parent && dev->parent->of_node)
+		of_id = of_alias_get_id(dev->parent->of_node, "rtc");
+
+	if (of_id >= 0) {
+		id = ida_simple_get(&rtc_ida, of_id, of_id + 1,
+				    GFP_KERNEL);
+		if (id < 0)
+			dev_warn(dev, "/aliases ID %d not available\n",
+				    of_id);
+	}
 
-	id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
-		err = id;
-		goto exit;
+		id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
+		if (id < 0) {
+			err = id;
+			goto exit;
+		}
 	}
 
 	rtc = kzalloc(sizeof(struct rtc_device), GFP_KERNEL);
_

Patches currently in -mm which might be from swarren@nvidia.com are

origin.patch
linux-next.patch

