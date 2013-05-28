From: akpm@linux-foundation.org
Subject: + drm-cirrus-correct-register-values-for-16bpp.patch added to -mm tree
Date: Tue, 28 May 2013 16:10:39 -0700
Message-ID: <51a5396f.o3TF9OjfZmMfyUoC%akpm__49725.3996356905$1369782657$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234Ab3E1XKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jslaby@suse.cz, airlied@linux.ie, tiwai@suse.de

Subject: + drm-cirrus-correct-register-values-for-16bpp.patch added to -mm tree
To: tiwai@suse.de,airlied@linux.ie,jslaby@suse.cz,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:10:39 -0700


The patch titled
     Subject: drm/cirrus: correct register values for 16bpp
has been added to the -mm tree.  Its filename is
     drm-cirrus-correct-register-values-for-16bpp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: drm/cirrus: correct register values for 16bpp

When the mode is set with 16bpp on QEMU, the output gets totally broken. 
The culprit is the bogus register values set for 16bpp, which was likely
copied from from a wrong place.

Addresses https://bugzilla.novell.com/show_bug.cgi?id=799216

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/cirrus/cirrus_mode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/cirrus/cirrus_mode.c~drm-cirrus-correct-register-values-for-16bpp drivers/gpu/drm/cirrus/cirrus_mode.c
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c~drm-cirrus-correct-register-values-for-16bpp
+++ a/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -273,8 +273,8 @@ static int cirrus_crtc_mode_set(struct d
 		sr07 |= 0x11;
 		break;
 	case 16:
-		sr07 |= 0xc1;
-		hdr = 0xc0;
+		sr07 |= 0x17;
+		hdr = 0xc1;
 		break;
 	case 24:
 		sr07 |= 0x15;
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drm-cirrus-correct-register-values-for-16bpp.patch
vfs-fix-invalid-ida_remove-call.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

