From: akpm@linux-foundation.org
Subject: + vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles.patch added to -mm tree
Date: Fri, 18 Sep 2009 15:05:24 -0700
Message-ID: <200909182205.n8IM5OrE028555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZIRWGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 18:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: currojerez@riseup.net, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, krzysztof.h1@poczta.fm


The patch titled
     vgacon: prevent vgacon_deinit from touching the hardware for inactive consoles.
has been added to the -mm tree.  Its filename is
     vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -590,12 +590,14 @@ static void vgacon_init(struct vc_data *
 
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

linux-next.patch
vgacon-prevent-vgacon_deinit-from-touching-the-hardware-for-inactive-consoles.patch

