From: akpm@linux-foundation.org
Subject: + efifb-dmi-set-video-type.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:49:07 -0700
Message-ID: <200903302249.n2UMn89O012955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509AbZC3Wxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 18:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bmaly@redhat.com, krzysztof.h1@poczta.fm, mouli@linux.intel.com, pjones@redhat.com, ying.huang@intel.com


The patch titled
     efifb: dmi set video type
has been added to the -mm tree.  Its filename is
     efifb-dmi-set-video-type.patch

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
Subject: efifb: dmi set video type
From: Brian Maly <bmaly@redhat.com>

The current logic for dmi matching in efifb does not allow efifb to load
on all hardware that we can dmi match for.

For a real world example, boot with elilo (3.7 or 3.8 vanilla) and on a
Apple (MacBook) and EFI framebuffer driver will not load (you will have no
video).  This specific hardware is efi v1.10, so we have UGA and not GOP. 
Without special bootloader magic (i.e.  extra elilo patches for UGA
graphics detection) no screen info will be passed to the kernel and as a
result efifb will not load.

This patch allows the dmi match to happen by moving it to earlier in
efifb_init, and sets the video type (in set_system) so that efifb can load
when we have a valid dmi match and already know the specifics of the
hardware.

Without this patch the efifb driver will fail to load in the event screen
info is not found and passed in by the bootloader, being that we will
never get to look for a dmi match.  A primary reason for matching with dmi
is because not all bootloaders detect the video info properly.  The
solution is that in the event of a dmi match, we should set
screen_info.orig_video_isVGA.  Most bootloaders fail to set screen info on
Apple hardware, and this is a big problem for people who use Apple
hardware.

Tested on a MacBook SantaRosa with elilo-3.8 (vanilla) and resolves the
issue, the dmi match now works, EFI framebuffer now loads and video works.

Signed-off-by: Brian Maly <bmaly@redhat.com>
Acked-by: Huang Ying <ying.huang@intel.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/efifb.c~efifb-dmi-set-video-type drivers/video/efifb.c
--- a/drivers/video/efifb.c~efifb-dmi-set-video-type
+++ a/drivers/video/efifb.c
@@ -129,6 +129,8 @@ static int set_system(const struct dmi_s
 		screen_info.lfb_width = info->width;
 	if (screen_info.lfb_height == 0)
 		screen_info.lfb_height = info->height;
+	if (screen_info.orig_video_isVGA == 0)
+		screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
 
 	return 0;
 }
@@ -374,9 +376,10 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
+	dmi_check_system(dmi_system_table);
+
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
-	dmi_check_system(dmi_system_table);
 
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;
_

Patches currently in -mm which might be from bmaly@redhat.com are

efifb-dmi-set-video-type.patch

