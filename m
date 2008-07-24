From: akpm@linux-foundation.org
Subject: - tridentfb-preserve-memory-type-settings.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:11 -0700
Message-ID: <200807242331.m6ONVBcO011601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636AbYGXXbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: preserve memory type settings
has been removed from the -mm tree.  Its filename was
     tridentfb-preserve-memory-type-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: preserve memory type settings
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Do not overwrite bits which contain memory type settings.  It removes
noise pixels ("snow") on Blade3D and 3DImage chips.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-preserve-memory-type-settings drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-preserve-memory-type-settings
+++ a/drivers/video/tridentfb.c
@@ -1095,7 +1095,10 @@ static int tridentfb_set_par(struct fb_i
 	vga_mm_wseq(par->io_virt, 4, 0x0E); /* memory mode enable bitmaps ?? */
 
 	/* divide clock by 2 if 32bpp chain4 mode display and CPU path */
-	write3CE(par, MiscExtFunc, (bpp == 32) ? 0x1A : 0x12);
+	tmp = read3CE(par, MiscExtFunc) & 0xF0;
+	if (bpp == 32)
+		tmp |= 8;
+	write3CE(par, MiscExtFunc, tmp | 0x12);
 	write3CE(par, 0x5, 0x40);	/* no CGA compat, allow 256 col */
 	write3CE(par, 0x6, 0x05);	/* graphics mode */
 	write3CE(par, 0x7, 0x0F);	/* planes? */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

