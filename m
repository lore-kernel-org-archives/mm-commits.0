From: akpm@linux-foundation.org
Subject: + schedule-wext-rtnl-for-removal.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:00:11 -0800
Message-ID: <200703020100.l2210Cdo028168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714AbXCBBFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, jeff@garzik.org, linville@tuxdriver.com


The patch titled
     schedule wext/rtnl for removal
has been added to the -mm tree.  Its filename is
     schedule-wext-rtnl-for-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 12 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~schedule-wext-rtnl-for-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~schedule-wext-rtnl-for-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -287,3 +287,15 @@ Why:	The code says it was obsolete when 
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

schedule-wext-rtnl-for-removal.patch
git-wireless.patch
