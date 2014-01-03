From: akpm@linux-foundation.org
Subject: +
 drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:14 -0800
Message-ID: <52c73d3e.2RNOLYgFYPTEAqyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaACWoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com, dhowells@redhat.com

Subject: + drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch added to -mm tree
To: dhowells@redhat.com,alan@linux.intel.com,gregkh@suse.de
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:14 -0800


The patch titled
     Subject: drivers/gpu/drm/gma500/backlight.c: fix a defined-but-not-used warning for do_gma_backlight_set()
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch

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
Subject: drivers/gpu/drm/gma500/backlight.c: fix a defined-but-not-used warning for do_gma_backlight_set()

Fix the following warning:

	drivers/gpu/drm/gma500/backlight.c:29:13: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]

by moving the entire function inside the conditional section currently inside
of it.  All the places that call it are so conditionalised.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/gma500/backlight.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/gma500/backlight.c~drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set drivers/gpu/drm/gma500/backlight.c
--- a/drivers/gpu/drm/gma500/backlight.c~drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set
+++ a/drivers/gpu/drm/gma500/backlight.c
@@ -26,13 +26,13 @@
 #include "intel_bios.h"
 #include "power.h"
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 static void do_gma_backlight_set(struct drm_device *dev)
 {
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	backlight_update_status(dev_priv->backlight_device);
-#endif	
 }
+#endif
 
 void gma_backlight_enable(struct drm_device *dev)
 {
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

