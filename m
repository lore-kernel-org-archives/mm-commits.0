From: akpm@linux-foundation.org
Subject: + mfd-add-support-for-wm8351-revision-b.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:19:01 -0800
Message-ID: <200902192019.n1JKJ1uP020318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbZBSUTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com


The patch titled
     mfd: add support for WM8351 revision B
has been added to the -mm tree.  Its filename is
     mfd-add-support-for-wm8351-revision-b.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: add support for WM8351 revision B
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

No software visible difference from revision A.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/mfd/wm8350-core.c~mfd-add-support-for-wm8351-revision-b drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-add-support-for-wm8351-revision-b
+++ a/drivers/mfd/wm8350-core.c
@@ -1386,6 +1386,11 @@ int wm8350_device_init(struct wm8350 *wm
 			wm8350->power.rev_g_coeff = 1;
 			break;
 
+		case 1:
+			dev_info(wm8350->dev, "WM8351 Rev B\n");
+			wm8350->power.rev_g_coeff = 1;
+			break;
+
 		default:
 			dev_err(wm8350->dev, "Unknown WM8351 CHIP_REV\n");
 			ret = -ENODEV;
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
regulator-suggest-use-of-datasheet-supply-or-pin-names-for-consumers.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

