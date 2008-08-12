From: akpm@linux-foundation.org
Subject: + v4l1-make-pms-not-autoprobe-when-builtin-update.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:10:59 -0700
Message-ID: <200808120010.m7C0Ax8M029468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYHLALh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, mchehab@infradead.org, rene.herman@gmail.com


The patch titled
     v4l1-make-pms-not-autoprobe-when-builtin update
has been added to the -mm tree.  Its filename is
     v4l1-make-pms-not-autoprobe-when-builtin-update.patch

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
Subject: v4l1-make-pms-not-autoprobe-when-builtin update
From: Rene Herman <rene.herman@keyaccess.nl>

On 10-08-08 23:37, Alan Cox wrote:
>
> Would probably make the printk "pms: not enabled, use pms.enable=1 to
> probe"
>
> So you know
> a) What is wittering about not being probed
> b) How to undo it.
>
> But thats trivia really.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin-update drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin-update
+++ a/drivers/media/video/pms.c
@@ -1030,7 +1030,8 @@ static int __init init_pms_cards(void)
 
 #ifndef MODULE
 	if (!enable) {
-		printk(KERN_INFO "Not enabled\n");
+		printk(KERN_INFO "PMS: not enabled, use pms.enable=1 to "
+				 "probe\n");
 		return -ENODEV;
 	}
 #endif
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

v4l1-make-pms-not-autoprobe-when-builtin.patch
v4l1-make-pms-not-autoprobe-when-builtin-update.patch
i2c-dont-autograb-i2c-pca-is.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch

