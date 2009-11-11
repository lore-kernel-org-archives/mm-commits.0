From: akpm@linux-foundation.org
Subject: + serial_cs-oxsemi-quirk-breaks-resume.patch added to -mm tree
Date: Wed, 11 Nov 2009 15:38:02 -0800
Message-ID: <200911112338.nABNc24P018504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759671AbZKKXiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Nov 2009 18:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, alan@lxorguk.ukuu.org.uk


The patch titled
     serial_cs: oxsemi quirk breaks resume
has been added to the -mm tree.  Its filename is
     serial_cs-oxsemi-quirk-breaks-resume.patch

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
Subject: serial_cs: oxsemi quirk breaks resume
From: Pavel Machek <pavel@ucw.cz>

Quirk is applied on all cards with given manfid (is it that correct?). 
Unfortunately, that quirk breaks resume on zaurus with billionton
bluetooth card inserted: c950ctrl is 0 and outb() faults.

I believe it is simply not a multiport card.  (info->multi == 1).  ... 
...  confirmed by printks.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_cs.c~serial_cs-oxsemi-quirk-breaks-resume drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~serial_cs-oxsemi-quirk-breaks-resume
+++ a/drivers/serial/serial_cs.c
@@ -146,7 +146,8 @@ static void quirk_wakeup_oxsemi(struct p
 {
 	struct serial_info *info = link->priv;
 
-	outb(12, info->c950ctrl + 1);
+	if (info->c950ctrl)
+		outb(12, info->c950ctrl + 1);
 }
 
 /* request_region? oxsemi branch does no request_region too... */
_

Patches currently in -mm which might be from pavel@ucw.cz are

drivers-video-msm-update-to-new-kernel.patch
linux-next.patch
serial_cs-oxsemi-quirk-breaks-resume.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
msm_sdccc-add-missing-include-fix-compilation.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

