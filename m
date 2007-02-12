From: akpm@linux-foundation.org
Subject: - fbdev-driver-for-s3-trio-virge-update-2-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:25:52 -0800
Message-ID: <200702120725.l1C7PqIj024786@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXBLH0C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:26:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jirislaby@gmail.com, jsimmons@infradead.org, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     fbdev-driver-for-s3-trio-virge-update-2-fix
has been removed from the -mm tree.  Its filename was
     fbdev-driver-for-s3-trio-virge-update-2-fix.patch

This patch was dropped because it was folded into fbdev-driver-for-s3-trio-virge.patch

------------------------------------------------------
Subject: fbdev-driver-for-s3-trio-virge-update-2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c    |    2 +-
 drivers/video/svgalib.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update-2-fix drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update-2-fix
+++ a/drivers/video/svgalib.c
@@ -96,11 +96,12 @@ void svga_set_default_gfx_regs(void)
 /* Set attribute controller registers to sane values */
 void svga_set_default_atc_regs(void)
 {
+	u8 count;
+
 	vga_r(NULL, 0x3DA);
 	vga_w(NULL, VGA_ATT_W, 0x00);
 
 	/* All standard ATC registers (AR00 - AR14) */
-	u8 count;
 	for (count = 0; count <= 0xF; count ++)
 		svga_wattr(count, count);
 
diff -puN drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update-2-fix drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update-2-fix
+++ a/drivers/video/s3fb.c
@@ -955,7 +955,7 @@ static int __devinit s3_pci_probe(struct
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(&(dev->dev), "cannot register framebugger\n");
+		dev_err(&(dev->dev), "cannot register framebuffer\n");
 		goto err_reg_fb;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
add-vm_insert_pfn.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
fbdev-driver-for-s3-trio-virge.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
