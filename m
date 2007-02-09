From: akpm@linux-foundation.org
Subject: + ps3-cleanup-ps3fb-before-clearing-hpte.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:51 -0800
Message-ID: <200702090926.l199QpHN009516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946253AbXBIJ1o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3: cleanup ps3fb before clearing HPTE
has been added to the -mm tree.  Its filename is
     ps3-cleanup-ps3fb-before-clearing-hpte.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3: cleanup ps3fb before clearing HPTE
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

PS3: Cleanup the frame buffer device before clearing the HPTE mapping

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/htab.c |    6 +++++-
 include/asm-powerpc/ps3fb.h       |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/ps3/htab.c~ps3-cleanup-ps3fb-before-clearing-hpte arch/powerpc/platforms/ps3/htab.c
--- a/arch/powerpc/platforms/ps3/htab.c~ps3-cleanup-ps3fb-before-clearing-hpte
+++ a/arch/powerpc/platforms/ps3/htab.c
@@ -2,7 +2,7 @@
  *  PS3 pagetable management routines.
  *
  *  Copyright (C) 2006 Sony Computer Entertainment Inc.
- *  Copyright 2006 Sony Corp.
+ *  Copyright 2006, 2007 Sony Corporation
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -24,6 +24,7 @@
 #include <asm/lmb.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
+#include <asm/ps3fb.h>
 
 #include "platform.h"
 
@@ -233,6 +234,9 @@ static void ps3_hpte_invalidate(unsigned
 
 static void ps3_hpte_clear(void)
 {
+	/* Make sure to clean up the frame buffer device first */
+	ps3fb_cleanup();
+
 	lv1_unmap_htab(htab_addr);
 }
 
diff -puN include/asm-powerpc/ps3fb.h~ps3-cleanup-ps3fb-before-clearing-hpte include/asm-powerpc/ps3fb.h
--- a/include/asm-powerpc/ps3fb.h~ps3-cleanup-ps3fb-before-clearing-hpte
+++ a/include/asm-powerpc/ps3fb.h
@@ -45,8 +45,10 @@ struct ps3fb_ioctl_res {
 
 #ifdef CONFIG_FB_PS3
 extern void ps3fb_flip_ctl(int on);
+extern void ps3fb_cleanup(void);
 #else
 static inline void ps3fb_flip_ctl(int on) {}
+static inline void ps3fb_cleanup(void) {}
 #endif
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
