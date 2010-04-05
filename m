From: akpm@linux-foundation.org
Subject: [merged] drm-fix-build-error-when-sysrq-is-disabled.patch removed from -mm tree
Date: Mon, 05 Apr 2010 11:46:37 -0400
Message-ID: <201004051848.o35Ilxjx002054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543Ab0DESsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 14:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: fix build error when SYSRQ is disabled
has been removed from the -mm tree.  Its filename was
     drm-fix-build-error-when-sysrq-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod.patch
xen-fix-build-when-sysrq-is-disabled.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

