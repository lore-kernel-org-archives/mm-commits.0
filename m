From: akpm@linux-foundation.org
Subject: - rtc-update-documentation-wrt-irq_set_freq.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:45 -0800
Message-ID: <200802070027.m170RQco007044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933133AbYBGAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     rtc: update documentation wrt irq_set_freq
has been removed from the -mm tree.  Its filename was
     rtc-update-documentation-wrt-irq_set_freq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: update documentation wrt irq_set_freq
From: Mike Frysinger <vapier.adi@gmail.com>

Document the proper use of the irq_set_freq function.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/rtc.txt~rtc-update-documentation-wrt-irq_set_freq Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-update-documentation-wrt-irq_set_freq
+++ a/Documentation/rtc.txt
@@ -182,8 +182,8 @@ driver returns ENOIOCTLCMD.  Some common
 	since the frequency is stored in the irq_freq member of the rtc_device
 	structure.  Your driver needs to initialize the irq_freq member during
 	init.  Make sure you check the requested frequency is in range of your
-	hardware in the irq_set_freq function.  If you cannot actually change
-	the frequency, just return -ENOTTY.
+	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
+	you cannot actually change the frequency, do not define irq_set_freq.
 
 If all else fails, check out the rtc-test.c driver!
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
