From: akpm@linux-foundation.org
Subject: + uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:01:29 -0700
Message-ID: <200809222301.m8MN1TZc002639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbYIVXOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, hpa@zytor.com, krzysztof.h1@poczta.fm


The patch titled
     uvesafb: don't treat mode info retrieval failures as errors
has been added to the -mm tree.  Its filename is
     uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: don't treat mode info retrieval failures as errors
From: Michal Januszewski <spock@gentoo.org>

Some BIOSes return error codes when queried for information about
modes from their own modelist.  uvesafb treats this as an error
case and bails out.

Change this behavior so that broken modes do not prevent the driver
from working.  Only the failure to retrieve information about any
usable video mode is considered to be an error case.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-dont-treat-mode-info-retrieval-failures-as-errors drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-dont-treat-mode-info-retrieval-failures-as-errors
+++ a/drivers/video/uvesafb.c
@@ -516,10 +516,12 @@ static int __devinit uvesafb_vbe_getmode
 
 		err = uvesafb_exec(task);
 		if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
-			printk(KERN_ERR "uvesafb: Getting mode info block "
+			printk(KERN_WARNING "uvesafb: Getting mode info block "
 				"for mode 0x%x failed (eax=0x%x, err=%d)\n",
 				*mode, (u32)task->t.regs.eax, err);
-			return -EINVAL;
+			mode++;
+			par->vbe_modes_cnt--;
+			continue;
 		}
 
 		mib = task->buf;
@@ -548,7 +550,10 @@ static int __devinit uvesafb_vbe_getmode
 			mib->depth = mib->bits_per_pixel;
 	}
 
-	return 0;
+	if (par->vbe_modes_cnt > 0)
+		return 0;
+	else
+		return -EINVAL;
 }
 
 /*
_

Patches currently in -mm which might be from spock@gentoo.org are

uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch
maintainers-add-entry-for-uvesafb.patch

