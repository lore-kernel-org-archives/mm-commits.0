From: akpm@linux-foundation.org
Subject: + fbdev-driver-for-s3-trio-virge-update-2-fix.patch added to -mm tree
Date: Fri, 09 Feb 2007 16:48:12 -0800
Message-ID: <200702100048.l1A0mF69031565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58145 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946809AbXBJAsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 19:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jirislaby@gmail.com, jsimmons@infradead.org, santiago@crfreenet.org


The patch titled
     fbdev-driver-for-s3-trio-virge-update-2-fix
has been added to the -mm tree.  Its filename is
     fbdev-driver-for-s3-trio-virge-update-2-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
