From: akpm@linux-foundation.org
Subject: - ps3-cleanup-ps3fb-before-clearing-hpte.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:29 -0800
Message-ID: <200702122250.l1CMoTnh014227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030419AbXBLWu4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3: cleanup ps3fb before clearing HPTE
has been removed from the -mm tree.  Its filename was
     ps3-cleanup-ps3fb-before-clearing-hpte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
