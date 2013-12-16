From: akpm@linux-foundation.org
Subject: + rtc-honor-device-tree-alias-entries-when-assigning-ids.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 14:48:43 -0800
Message-ID: <52af834b.jnJGshWWQRIWGWjb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3LPWso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 17:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@nvidia.com

Subject: + rtc-honor-device-tree-alias-entries-when-assigning-ids.patch added to -mm tree
To: swarren@nvidia.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 14:48:43 -0800


The patch titled
     Subject: rtc: honor device tree /alias entries when assigning IDs
has been added to the -mm tree.  Its filename is
     rtc-honor-device-tree-alias-entries-when-assigning-ids.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-honor-device-tree-alias-entries-when-assigning-ids.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-honor-device-tree-alias-entries-when-assigning-ids.patch

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

 drivers/rtc/class.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

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
@@ -157,12 +158,25 @@ struct rtc_device *rtc_device_register(c
 {
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
-	int id, err;
+	int of_id, id = -1, err;
+
+	if (dev->of_node) {
+		of_id = of_alias_get_id(dev->of_node, "rtc");
+		if (of_id >= 0) {
+			id = ida_simple_get(&rtc_ida, of_id, of_id + 1,
+					    GFP_KERNEL);
+			if (id < 0)
+				dev_warn(dev, "/aliases ID %d not available\n",
+					 of_id);
+		}
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

rtc-honor-device-tree-alias-entries-when-assigning-ids.patch
linux-next.patch

