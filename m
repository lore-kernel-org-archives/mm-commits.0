From: akpm@linux-foundation.org
Subject: - schedule-wext-rtnl-for-removal.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:57:04 -0800
Message-ID: <200703052357.l25Nv4Yf005257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331AbXCEX6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, davem@davemloft.net, jeff@garzik.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     schedule wext/rtnl for removal
has been removed from the -mm tree.  Its filename was
     schedule-wext-rtnl-for-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: schedule wext/rtnl for removal
From: Johannes Berg <johannes@sipsolutions.net>

Since wext is being replaced as fast as we can (it'll probably stick around
for legacy drivers though) and the wext/netlink stuff was never really
used, this schedules it for removal.

The removal schedule is tight but there are no users of the code, the main
user of the wext user interface are the wireless-tools, they only have an
alpha version using the netlink interface and even that is incomplete.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~schedule-wext-rtnl-for-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~schedule-wext-rtnl-for-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -304,3 +304,15 @@ Why:	The code says it was obsolete when 
 Who:	Richard Purdie <rpurdie@rpsys.net>
 
 ---------------------------
+
+What:	Wireless extensions over netlink (CONFIG_NET_WIRELESS_RTNETLINK)
+When:	with the merge of wireless-dev, 2.6.22 or later
+Why:	The option/code is
+	 * not enabled on most kernels
+	 * not required by any userspace tools (except an experimental one,
+	   and even there only for some parts, others use ioctl)
+	 * pointless since wext is no longer evolving and the ioctl
+	   interface needs to be kept
+Who:	Johannes Berg <johannes@sipsolutions.net>
+
+---------------------------
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-wireless.patch
