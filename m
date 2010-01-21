From: akpm@linux-foundation.org
Subject: [merged] viafb-fix-acceleration-for-some-chips.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:05 -0800
Message-ID: <201001212127.o0LLR52U030606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab0AUV1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ej.lfs@xs4all.nl, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: fix acceleration for some chips
has been removed from the -mm tree.  Its filename was
     viafb-fix-acceleration-for-some-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: fix acceleration for some chips
From: Erik-Jan Post <ej.lfs@xs4all.nl>

Fix a regression in hardware acceleration which made the accelerated
framebuffer unusable on some chips.  These need extra initialization and
an extra flag which is no longer needed/available on current chips.

Signed-off-by: Erik-Jan Post <ej.lfs@xs4all.nl>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/via/accel.c~viafb-fix-acceleration-for-some-chips drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-fix-acceleration-for-some-chips
+++ a/drivers/video/via/accel.c
@@ -137,7 +137,7 @@ static int hw_bitblt_1(void __iomem *eng
 			tmp, dst_pitch);
 		return -EINVAL;
 	}
-	tmp = (tmp >> 3) | (dst_pitch << (16 - 3));
+	tmp = VIA_PITCH_ENABLE | (tmp >> 3) | (dst_pitch << (16 - 3));
 	writel(tmp, engine + 0x38);
 
 	if (op == VIA_BITBLT_FILL)
@@ -352,6 +352,9 @@ int viafb_init_engine(struct fb_info *in
 	viapar->shared->vq_vram_addr = viapar->fbmem_free;
 	viapar->fbmem_used += VQ_SIZE;
 
+	/* Init 2D engine reg to reset 2D engine */
+	writel(0x0, engine + VIA_REG_KEYCONTROL);
+
 	/* Init AGP and VQ regs */
 	switch (chip_name) {
 	case UNICHROME_K8M890:
_

Patches currently in -mm which might be from ej.lfs@xs4all.nl are

origin.patch

