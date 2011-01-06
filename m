From: akpm@linux-foundation.org
Subject: + vgacon-check-for-efi-machine.patch added to -mm tree
Date: Thu, 06 Jan 2011 11:55:54 -0800
Message-ID: <201101061955.p06Jts8L012094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab1AFT4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jan 2011 14:56:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yannick_heneault@matrox.com, airlied@linux.ie, hpa@zytor.com, yheneaul@matrox.com


The patch titled
     vgacon: check for efi machine
has been added to the -mm tree.  Its filename is
     vgacon-check-for-efi-machine.patch

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
Subject: vgacon: check for efi machine
From: Yannick Heneault <yannick_heneault@matrox.com>

It seems there is a small problem of VGA palette corruption on EFI
machine.  When the kernel initializes the architecture, it checks if the
machine is a EFI machine and assumes that a VGA console can exist.

When it initializes the console in vgacon_startup it checks if it can
really use the VGA console.  I think this is where a check is missing. 
Currently, the function can fail if a VESA boot mode is detected but not if
a EFI boot mode was used.

Thus vgacon_startup() doesn't fail and initialize the video card for a real
VGA mode.  This function changes the first 16entries of the VGA palette. 

When the efifb driver kicks in, the palette is not restored to default
ramp value, thus the 16 first entry remain in a modified state.  The
following patch prevent this corruption.

Signed-off-by: Yannick Heneault <yheneaul@matrox.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~vgacon-check-for-efi-machine drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-check-for-efi-machine
+++ a/drivers/video/console/vgacon.c
@@ -375,7 +375,8 @@ static const char *vgacon_startup(void)
 	u16 saved1, saved2;
 	volatile u16 *p;
 
-	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ||
+	    screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
 	      no_vga:
 #ifdef CONFIG_DUMMY_CONSOLE
 		conswitchp = &dummy_con;
_

Patches currently in -mm which might be from yannick_heneault@matrox.com are

vgacon-check-for-efi-machine.patch

