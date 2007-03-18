From: akpm@linux-foundation.org
Subject: - fix-saa7146_clipping_mem-size.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:24 -0800
Message-ID: <200703180910.l2I9AOn6020087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXCRJK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     fix SAA7146_CLIPPING_MEM size
has been removed from the -mm tree.  Its filename was
     fix-saa7146_clipping_mem-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix SAA7146_CLIPPING_MEM size
From: Olaf Hering <olaf@aepfle.de>

Limit the pci_alloc_consistent size to 128K PAGE_SIZE can be 64K, which
leads to a 896K allocation.

calculate_clipping_registers_rect() uses not more than 257 bytes because
saa7146_video.c:s_fmt limits ov.nclips to 16

But bttv-driver.c does not allow up to 2048 clips in win->clipcount
btcx_screen_clips() may add 4 more clips.

So a max array size of 131329 is enough.  Right now only 56K get allocated.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/saa7146_vv.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/media/saa7146_vv.h~fix-saa7146_clipping_mem-size include/media/saa7146_vv.h
--- a/include/media/saa7146_vv.h~fix-saa7146_clipping_mem-size
+++ a/include/media/saa7146_vv.h
@@ -239,7 +239,8 @@ void saa7146_res_free(struct saa7146_fh 
 #define SAA7146_HPS_SYNC_PORT_B		0x01
 
 /* some memory sizes */
-#define SAA7146_CLIPPING_MEM	(14*PAGE_SIZE)
+/* see saa7146_hlp.c:calculate_clipping_registers_rect and bttv-driver.c:setup_window */
+#define SAA7146_CLIPPING_MEM	( ( ( 2048 + 4 ) * ( 2 * (2 * 16) ) ) + 1 )
 
 /* some defines for the various clipping-modes */
 #define SAA7146_CLIPPING_RECT		0x4
_

Patches currently in -mm which might be from olaf@aepfle.de are

git-powerpc.patch
git-dvb.patch
kbuild-override-build-timestamp.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
