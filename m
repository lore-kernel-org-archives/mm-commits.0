From: akpm@linux-foundation.org
Subject: - fbdev-kill-sparse-warning-in-deferred-io.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:58 -0700
Message-ID: <200705090300.l4930wL0010632@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032933AbXEIDBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: kill sparse warning in deferred IO
has been removed from the -mm tree.  Its filename was
     fbdev-kill-sparse-warning-in-deferred-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: kill sparse warning in deferred IO
From: "Antonino A. Daplas" <adaplas@gmail.com>

Kill the following in fb_defio.c:

drivers/video/fb_defio.c:40:43: warning: incorrect type in argument 1 (different address spaces)
drivers/video/fb_defio.c:40:43:    expected void *addr
drivers/video/fb_defio.c:40:43:    got char [noderef] *screen_base<asn:2>

The framebuffer memory of these types of devices are allocated from system
RAM.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/fb_defio.c~fbdev-kill-sparse-warning-in-deferred-io drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdev-kill-sparse-warning-in-deferred-io
+++ a/drivers/video/fb_defio.c
@@ -32,12 +32,14 @@ static struct page* fb_deferred_io_nopag
 	unsigned long offset;
 	struct page *page;
 	struct fb_info *info = vma->vm_private_data;
+	/* info->screen_base is in System RAM */
+	void *screen_base = (void __force *) info->screen_base;
 
 	offset = (vaddr - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
 	if (offset >= info->fix.smem_len)
 		return NOPAGE_SIGBUS;
 
-	page = vmalloc_to_page(info->screen_base + offset);
+	page = vmalloc_to_page(screen_base + offset);
 	if (!page)
 		return NOPAGE_OOM;
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
