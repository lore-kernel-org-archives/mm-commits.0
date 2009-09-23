From: akpm@linux-foundation.org
Subject: [merged] vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:19 -0700
Message-ID: <200909232003.n8NK3JmF018994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbZIWUKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: currojerez@riseup.net, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     vgacon: prevent vgacon_deinit from touching the hardware for inactive consoles.
has been removed from the -mm tree.  Its filename was
     vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vgacon: prevent vgacon_deinit from touching the hardware for inactive consoles.
From: Francisco Jerez <currojerez@riseup.net>

fbcon makes the (reasonable) assumption that it only needs to program the
hardware once, when fbcon_init() is called for the foreground console.

This doesn't always play well with vgacon because vgacon_deinit() is only
doing its job when the last console it owns is closed (when switching from
vgacon to fbcon, that's usually *after* fbcon_init() has set the new
mode).

Depending on the hardware this can cause the wrong framebuffer location to
be scanned out (e.g.  reproduced on nv05 with the nouveau framebuffer
driver).

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/console/vgacon.c~vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles
+++ a/drivers/video/console/vgacon.c
@@ -589,12 +589,14 @@ static void vgacon_init(struct vc_data *
 
 static void vgacon_deinit(struct vc_data *c)
 {
-	/* When closing the last console, reset video origin */
-	if (!--vgacon_uni_pagedir[1]) {
+	/* When closing the active console, reset video origin */
+	if (CON_IS_VISIBLE(c)) {
 		c->vc_visible_origin = vga_vram_base;
 		vga_set_mem_top(c);
-		con_free_unimap(c);
 	}
+
+	if (!--vgacon_uni_pagedir[1])
+		con_free_unimap(c);
 	c->vc_uni_pagedir_loc = &c->vc_uni_pagedir;
 	con_set_default_unimap(c);
 }
_

Patches currently in -mm which might be from currojerez@riseup.net are

origin.patch

