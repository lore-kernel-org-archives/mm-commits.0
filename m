From: akpm@linux-foundation.org
Subject: [merged] viafb-remove-lvds-initialization.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:01:58 -0700
Message-ID: <200909232001.n8NK1wjR016273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZIWUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: remove LVDS initialization
has been removed from the -mm tree.  Its filename was
     viafb-remove-lvds-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: remove LVDS initialization
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

At least for VX800 this initialization is not very good as some parts of
the register are written with reserved values.  This makes the display go
white in some configurations and not usable until the framebuffer is
removed.  It's better to not initialize it as it allows to use a
previously (by BIOS) correctly configured display.

This patch makes some displays work but might cause problems on others. 
This is bad but can not be easily avoided.  If this causes some
regressions it's probably the best to fix it in the 'active' display setup
code.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viamode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/via/viamode.c~viafb-remove-lvds-initialization drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-remove-lvds-initialization
+++ a/drivers/video/via/viamode.c
@@ -309,8 +309,7 @@ struct io_reg CX700_ModeXregs[] = { {VIA
 {VIACR, CR96, 0xFF, 0x00},
 {VIACR, CR97, 0xFF, 0x00},
 {VIACR, CR99, 0xFF, 0x00},
-{VIACR, CR9B, 0xFF, 0x00},
-{VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
+{VIACR, CR9B, 0xFF, 0x00}
 };
 
 /* Video Mode Table */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

