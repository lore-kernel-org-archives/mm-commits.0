From: akpm@linux-foundation.org
Subject: - framebuffer-fix-carminefb-section-mismatch.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:03 -0700
Message-ID: <200810182318.m9INI3Ad029208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYJRXSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bigeasy@linutronix.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     framebuffer: fix carminefb section mismatch
has been removed from the -mm tree.  Its filename was
     framebuffer-fix-carminefb-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: framebuffer: fix carminefb section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Make alloc_carmine_fb() __devinit.

WARNING: drivers/video/carminefb.o(.text+0x81b): Section mismatch in reference from the function alloc_carmine_fb() to the variable .devinit.data:carminefb_fix

The function alloc_carmine_fb() references the variable __devinitdata
carminefb_fix.  This is often because alloc_carmine_fb lacks a
__devinitdata annotation or the annotation of carminefb_fix is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/carminefb.c~framebuffer-fix-carminefb-section-mismatch drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~framebuffer-fix-carminefb-section-mismatch
+++ a/drivers/video/carminefb.c
@@ -535,7 +535,7 @@ static struct fb_ops carminefb_ops = {
 	.fb_setcolreg	= carmine_setcolreg,
 };
 
-static int alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
+static int __devinit alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
 		int smem_offset, struct device *device, struct fb_info **rinfo)
 {
 	int ret;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

