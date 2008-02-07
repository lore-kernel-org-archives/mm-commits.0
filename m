From: akpm@linux-foundation.org
Subject: - sm501fb-clear-framebuffer-memory-and-palette.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:49 -0800
Message-ID: <200802070028.m170SU3v007173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761982AbYBGAqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, adaplas@pol.net, ben-linux@fluff.org, damm@igel.co.jp, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sm501fb: clear framebuffer memory and palette
has been removed from the -mm tree.  Its filename was
     sm501fb-clear-framebuffer-memory-and-palette.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-sh.patch
