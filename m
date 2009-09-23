From: akpm@linux-foundation.org
Subject: [merged] fbcon-only-unbind-from-console-if-successfully-registered.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:16 -0700
Message-ID: <200909232003.n8NK3GIr018914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbZIWUFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian@iarmst.demon.co.uk, krzysztof.h1@poczta.fm, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fbcon: only unbind from console if successfully registered
has been removed from the -mm tree.  Its filename was
     fbcon-only-unbind-from-console-if-successfully-registered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

