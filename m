From: akpm@linux-foundation.org
Subject: + rtc-update-documentation-wrt-irq_set_freq.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:31:09 -0800
Message-ID: <200801312331.m0VNVCgb016954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYAaXbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:31:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org


The patch titled
     rtc: update documentation wrt irq_set_freq
has been added to the -mm tree.  Its filename is
     rtc-update-documentation-wrt-irq_set_freq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kbuild.patch
git-watchdog.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-inclusions-of-linux-autoconfh.patch
rtc-update-documentation-wrt-irq_set_freq.patch
