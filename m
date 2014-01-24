From: akpm@linux-foundation.org
Subject: [merged]
 drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:35 -0800
Message-ID: <52e2b853.eo1MSztK13wOO2ku%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, dhowells@redhat.com

Subject: [merged] drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch removed from -mm tree
To: dhowells@redhat.com,paulus@samba.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:35 -0800


The patch titled
     Subject: drivers/video/aty/aty128fb.c: fix a warning pertaining to the aty128fb backlight variable
has been removed from the -mm tree.  Its filename was
     drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: drivers/video/aty/aty128fb.c: fix a warning pertaining to the aty128fb backlight variable

Fix the following warning in the aty128fb driver:

	drivers/video/aty/aty128fb.c:363:12: warning: 'backlight' defined but not used [-Wunused-variable]
	 static int backlight = 0;
		    ^

as the variable's value is only read if CONFIG_FB_ATY128_BACKLIGHT=y.  The
variable is also set if MODULE is unset[*].

[*] I wonder if the conditional wrapper around aty128fb_setup() should be
    using CONFIG_MODULE rather than MODULE.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable
+++ a/drivers/video/aty/aty128fb.c
@@ -357,11 +357,13 @@ static int default_lcd_on = 1;
 static bool mtrr = true;
 #endif
 
+#ifdef CONFIG_FB_ATY128_BACKLIGHT
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight = 1;
 #else
 static int backlight = 0;
 #endif
+#endif
 
 /* PLL constants */
 struct aty128_constants {
@@ -1671,7 +1673,9 @@ static int aty128fb_setup(char *options)
 			default_crt_on = simple_strtoul(this_opt+4, NULL, 0);
 			continue;
 		} else if (!strncmp(this_opt, "backlight:", 10)) {
+#ifdef CONFIG_FB_ATY128_BACKLIGHT
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
+#endif
 			continue;
 		}
 #ifdef CONFIG_MTRR
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

