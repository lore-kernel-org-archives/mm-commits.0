From: akpm@linux-foundation.org
Subject: + drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:10:28 -0700
Message-ID: <20120724211029.37A4D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39960 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2GXVKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:10:32 -0400
Received: by lbbgp10 with SMTP id gp10so3678lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:10:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, dcb314@hotmail.com, hans.verkuil@cisco.com, leonidsbox@gmail.com, mchehab@infradead.org


The patch titled
     Subject: drivers/media/video/cx25821/cx25821-medusa-video.c: incorrect check on decoder type
has been added to the -mm tree.  Its filename is
     drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/media/video/cx25821/cx25821-medusa-video.c: incorrect check on decoder type

Unsupported requests should be ignored but in fact affected VDEC_A

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44051

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx25821/cx25821-medusa-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx25821/cx25821-medusa-video.c~drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type drivers/media/video/cx25821/cx25821-medusa-video.c
--- a/drivers/media/video/cx25821/cx25821-medusa-video.c~drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type
+++ a/drivers/media/video/cx25821/cx25821-medusa-video.c
@@ -499,7 +499,7 @@ static void medusa_set_decoderduration(s
 	mutex_lock(&dev->lock);
 
 	/* no support */
-	if (decoder < VDEC_A && decoder > VDEC_H) {
+	if (decoder < VDEC_A || decoder > VDEC_H) {
 		mutex_unlock(&dev->lock);
 		return;
 	}
_
Subject: Subject: drivers/media/video/cx25821/cx25821-medusa-video.c: incorrect check on decoder type

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch
drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch

