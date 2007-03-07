From: akpm@linux-foundation.org
Subject: - atyfb-fix-kconfig-error-part-2.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:20:59 -0800
Message-ID: <200703070420.l274KxTG018852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161288AbXCGEVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@gmail.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: fix kconfig error part 2
has been removed from the -mm tree.  Its filename was
     atyfb-fix-kconfig-error-part-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: fix kconfig error part 2
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix implicit declarations and missing code in atyfb.

drivers/video/aty/atyfb_base.c:2137: warning: implicit declaration of function 'a
ty_ld_lcd'
drivers/video/aty/atyfb_base.c:2154: warning: implicit declaration of function 'a
ty_st_lcd'
atyfb_base.c:(.text+0x33e5c): undefined reference to `aty_ld_lcd'
atyfb_base.c:(.text+0x33eb2): undefined reference to `aty_st_lcd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-fix-kconfig-error-part-2 drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-fix-kconfig-error-part-2
+++ a/drivers/video/aty/atyfb.h
@@ -284,7 +284,8 @@ static inline void aty_st_8(int regindex
 #endif
 }
 
-#if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || defined (CONFIG_FB_ATY_GENERIC_LCD)
+#if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
+defined (CONFIG_FB_ATY_GENERIC_LCD) || defined (CONFIG_FB_ATY_BACKLIGHT)
 extern void aty_st_lcd(int index, u32 val, const struct atyfb_par *par);
 extern u32 aty_ld_lcd(int index, const struct atyfb_par *par);
 #endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
profile-likely-unlikely-macros.patch
