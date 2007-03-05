From: akpm@linux-foundation.org
Subject: + nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch added to -mm tree
Date: Mon, 05 Mar 2007 02:05:04 -0800
Message-ID: <200703051005.l25A54Zt015575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39442 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXCEKFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 05:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, adaplas@gmail.com, jsimmons@infradead.org


The patch titled
     nvidiafb backlight: Fix implicit declaration in nv_backlight
has been added to the -mm tree.  Its filename is
     nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
