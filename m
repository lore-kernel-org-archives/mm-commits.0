From: akpm@linux-foundation.org
Subject: + atyfb-fix-kconfig-error-part-2.patch added to -mm tree
Date: Mon, 05 Mar 2007 02:05:06 -0800
Message-ID: <200703051005.l25A56q4015578@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbXCEKFn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 05:05:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@gmail.com, jsimmons@infradead.org


The patch titled
     atyfb: fix kconfig error part 2
has been added to the -mm tree.  Its filename is
     atyfb-fix-kconfig-error-part-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
phy-layer-add-kernel-doc-docbook.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
atyfb-fix-kconfig-error-part-2.patch
profile_likely-export-do_check_likely.patch
