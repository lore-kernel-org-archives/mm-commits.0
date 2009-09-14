From: akpm@linux-foundation.org
Subject: + fbcon-only-unbind-from-console-if-successfully-registered.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:39:09 -0700
Message-ID: <200909142139.n8ELd95L031454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbZINVki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 17:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian@iarmst.demon.co.uk, krzysztof.h1@poczta.fm, stable@kernel.org


The patch titled
     fbcon: only unbind from console if successfully registered
has been added to the -mm tree.  Its filename is
     fbcon-only-unbind-from-console-if-successfully-registered.patch

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
Subject: fbcon: only unbind from console if successfully registered
From: Ian Armstrong <ian@iarmst.demon.co.uk>

Attempting to unload a framebuffer module calls unregister_framebuffer()
which in turn gets fbcon to release it.  If fbcon has no framebuffers
linked to a console, it will also unbind itself from the console driver. 
However, if fbcon never registered itself as a console driver, the unbind
will fail causing the framebuffer device entry to persist.  In most cases
this failure will result in an oops when attempting to access the now
non-existent device.

This patch ensures that the fbcon unbind request will succeed even if a
bind was never done.  It tracks if a successful bind ever occurred & will
only attempt to unbind if needed.  If there never was a bind, it simply
returns with no error.

Signed-off-by: Ian Armstrong <ian@iarmst.demon.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbcon-only-unbind-from-console-if-successfully-registered drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-only-unbind-from-console-if-successfully-registered
+++ a/drivers/video/console/fbcon.c
@@ -114,6 +114,7 @@ static int last_fb_vc = MAX_NR_CONSOLES 
 static int fbcon_is_default = 1; 
 static int fbcon_has_exited;
 static int primary_device = -1;
+static int fbcon_has_console_bind;
 
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
 static int map_override;
@@ -544,6 +545,8 @@ static int fbcon_takeover(int show_logo)
 			con2fb_map[i] = -1;
 		}
 		info_idx = -1;
+	} else {
+		fbcon_has_console_bind = 1;
 	}
 
 	return err;
@@ -2949,6 +2952,10 @@ static int fbcon_unbind(void)
 
 	ret = unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
 				fbcon_is_default);
+
+	if (!ret)
+		fbcon_has_console_bind = 0;
+
 	return ret;
 }
 #else
@@ -2962,6 +2969,9 @@ static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
 
+	if (!fbcon_has_console_bind)
+		return 0;
+
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] != idx &&
 		    con2fb_map[i] != -1) {
_

Patches currently in -mm which might be from ian@iarmst.demon.co.uk are

fbcon-only-unbind-from-console-if-successfully-registered.patch

