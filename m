From: akpm@linux-foundation.org
Subject: + console-vgaconc-mark-file-local-symbol-static.patch added to -mm tree
Date: Fri, 22 Jan 2010 16:42:11 -0800
Message-ID: <201001230042.o0N0gBWd006601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab0AWAmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 19:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tfransosi@gmail.com, mjg@redhat.com


The patch titled
     console/vgacon.c: mark file-local symbol static
has been added to the -mm tree.  Its filename is
     console-vgaconc-mark-file-local-symbol-static.patch

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
Subject: console/vgacon.c: mark file-local symbol static
From: Thiago Farina <tfransosi@gmail.com>

warning: symbol 'vgacon_text_mode_force' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~console-vgaconc-mark-file-local-symbol-static drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~console-vgaconc-mark-file-local-symbol-static
+++ a/drivers/video/console/vgacon.c
@@ -112,7 +112,7 @@ static int 		vga_video_font_height;
 static int 		vga_scan_lines		__read_mostly;
 static unsigned int 	vga_rolled_over;
 
-int vgacon_text_mode_force = 0;
+static int vgacon_text_mode_force;
 
 bool vgacon_text_force(void)
 {
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch
console-vgaconc-mark-file-local-symbol-static.patch

