From: akpm@linux-foundation.org
Subject: + viafb-fix-acceleration-for-some-chips.patch added to -mm tree
Date: Mon, 11 Jan 2010 13:46:55 -0800
Message-ID: <201001112146.o0BLktYM030097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab0AKVr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 16:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ej.lfs@xs4all.nl, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: fix acceleration for some chips
has been added to the -mm tree.  Its filename is
     viafb-fix-acceleration-for-some-chips.patch

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

viafb-do-modesetting-after-updating-variables.patch
viafb-fix-acceleration-for-some-chips.patch

