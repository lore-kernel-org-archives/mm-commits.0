From: akpm@linux-foundation.org
Subject: + sm501fb-clear-framebuffer-memory-and-palette.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:40:09 -0800
Message-ID: <200801220239.m0M2dou7000315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbYAVClI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, adaplas@pol.net, ben-linux@fluff.org, damm@igel.co.jp, lethal@linux-sh.org


The patch titled
     sm501fb: clear framebuffer memory and palette
has been added to the -mm tree.  Its filename is
     sm501fb-clear-framebuffer-memory-and-palette.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: clear framebuffer memory and palette
From: Magnus Damm <magnus.damm@gmail.com>

Avoid displaying garbage on unused framebuffers.  For most users a single
framebuffer is used together with fbcon.  sm501fb supports two framebuffers
where one often is assigned to fbcon and the other one is left unused during
the boot.

The problem here is that framebuffers not in use by fbcon happen to display
garbage.  This can easily be solved by making sure that framebuffer memory and
palette ram are cleared.

The problem can be observed by using looking at the panel output (fb1) after
booting the kernel with fbcon on crt (fb0).  This is the default
configuration.  It's also possible to watch the garbage on the crt framebuffer
by passing "fbcon=map:1" on the kernel cmdline.  This will assign fbcon to the
panel (fb1) and leave the crt (fb0) unused.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501fb-clear-framebuffer-memory-and-palette drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-clear-framebuffer-memory-and-palette
+++ a/drivers/video/sm501fb.c
@@ -1276,6 +1276,7 @@ static int sm501fb_start(struct sm501fb_
 {
 	struct resource	*res;
 	struct device *dev;
+	int k;
 	int ret;
 
 	info->dev = dev = &pdev->dev;
@@ -1337,6 +1338,13 @@ static int sm501fb_start(struct sm501fb_
 
 	info->fbmem_len = (res->end - res->start)+1;
 
+	/* clear framebuffer memory - avoids garbage data on unused fb */
+	memset(info->fbmem, 0, info->fbmem_len);
+
+	/* clear palette ram - undefined at power on */
+	for (k = 0; k < (256 * 3); k++)
+		writel(0, info->regs + SM501_DC_PANEL_PALETTE + (k * 4));
+
 	/* enable display controller */
 	sm501_unit_power(dev->parent, SM501_GATE_DISPLAY, 1);
 
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
