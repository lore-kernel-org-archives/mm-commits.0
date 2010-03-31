From: akpm@linux-foundation.org
Subject: + drm-fix-build-error-when-sysrq-is-disabled.patch added to -mm tree
Date: Wed, 31 Mar 2010 13:22:24 -0700
Message-ID: <201003312022.o2VKMOsC006308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833Ab0CaUWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 16:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, airlied@linux.ie


The patch titled
     drm: fix build error when SYSRQ is disabled
has been added to the -mm tree.  Its filename is
     drm-fix-build-error-when-sysrq-is-disabled.patch

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
Subject: drm: fix build error when SYSRQ is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:

drivers/gpu/drm/drm_fb_helper.c:915: error: 'sysrq_drm_fb_helper_restore_op' undeclared (first use in this function)
drivers/gpu/drm/drm_fb_helper.c:929: error: 'sysrq_drm_fb_helper_restore_op' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-fix-build-error-when-sysrq-is-disabled drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-fix-build-error-when-sysrq-is-disabled
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -284,6 +284,8 @@ static struct sysrq_key_op sysrq_drm_fb_
 	.help_msg = "force-fb(V)",
 	.action_msg = "Restore framebuffer console",
 };
+#else
+static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
 #endif
 
 static void drm_fb_helper_on(struct fb_info *info)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drm-fix-build-error-when-sysrq-is-disabled.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
xen-fix-build-when-sysrq-is-disabled.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

