From: akpm@linux-foundation.org
Subject: +
 drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:18 -0800
Message-ID: <52c73d42./DzzBV8Rdv2pGXED%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaACWoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, dhowells@redhat.com

Subject: + drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch added to -mm tree
To: dhowells@redhat.com,paulus@samba.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:18 -0800


The patch titled
     Subject: drivers/video/aty/aty128fb.c: fix a warning pertaining to the aty128fb backlight variable
has been added to the -mm tree.  Its filename is
     drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-ofh-make-for_each_child_of_node-reference-its-args-when-config_of=n.patch
drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch
drivers-mfd-max8998c-fix-pointer-integer-size-mismatch-warning-in-max8998_i2c_get_driver_data.patch
drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch
drivers-regulator-tps62360-regulatorc-fix-pointer-integer-size-mismatch-warning-in-tps62360_probe.patch
drivers-video-aty-aty128fbc-fix-a-warning-pertaining-to-the-aty128fb-backlight-variable.patch
documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch
lib-assoc_arrayc-remove-global-variable.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

