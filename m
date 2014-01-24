From: akpm@linux-foundation.org
Subject: [merged]
 drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:29 -0800
Message-ID: <52e2b84d.SYYx4p0Z0QuaMyUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com, dhowells@redhat.com

Subject: [merged] drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch removed from -mm tree
To: dhowells@redhat.com,alan@linux.intel.com,gregkh@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:29 -0800


The patch titled
     Subject: drivers/gpu/drm/gma500/backlight.c: fix a defined-but-not-used warning for do_gma_backlight_set()
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-gma500-backlightc-fix-a-defined-but-not-used-warning-for-do_gma_backlight_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

