From: akpm@linux-foundation.org
Subject: - nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:20:56 -0800
Message-ID: <200703070420.l274KuaM018847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46987 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161290AbXCGEVK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, adaplas@gmail.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     nvidiafb backlight: Fix implicit declaration in nv_backlight
has been removed from the -mm tree.  Its filename was
     nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb backlight: Fix implicit declaration in nv_backlight
From: Dave Jones <davej@redhat.com>

drivers/video/nvidia/nv_backlight.c: In function 'nvidia_bl_init':
drivers/video/nvidia/nv_backlight.c:103: error: implicit declaration of function 'pmac_has_backlight_type'

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_backlight.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/video/nvidia/nv_backlight.c~nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight drivers/video/nvidia/nv_backlight.c
--- a/drivers/video/nvidia/nv_backlight.c~nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight
+++ a/drivers/video/nvidia/nv_backlight.c
@@ -12,6 +12,11 @@
 #include <linux/backlight.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+#include <asm/backlight.h>
+#endif
+
 #include "nv_local.h"
 #include "nv_type.h"
 #include "nv_proto.h"
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-cpufreq.patch
