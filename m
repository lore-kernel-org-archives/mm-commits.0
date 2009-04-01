From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:03 -0700
Message-ID: <200904011843.n31Ih370009924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755844AbZDASyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix threshold register mask for Laguna chips
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix threshold register mask for Laguna chips
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix threshold register mask for Laguna chips otherwise some 8bpp modes are
garbled after selecting a 24bpp mode.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-threshold-register-mask-for-laguna-chips drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-threshold-register-mask-for-laguna-chips
+++ a/drivers/video/cirrusfb.c
@@ -875,7 +875,7 @@ static int cirrusfb_set_par_foo(struct f
 		threshold = fb_readw(cinfo->laguna_mmio + 0xea);
 		control &= ~0x6800;
 		format = 0;
-		threshold &= 0xffe0 & 0x3fbf;
+		threshold &= 0xffc0 & 0x3fbf;
 	}
 	if (nom) {
 		tmp = den << 1;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

