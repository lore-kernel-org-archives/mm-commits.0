From: akpm@linux-foundation.org
Subject: - tridentfb-fix-unitialized-pseudo_palette.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:07 -0700
Message-ID: <200807242331.m6ONV7ti011595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756384AbYGXXbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix unitialized pseudo_palette
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-unitialized-pseudo_palette.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix unitialized pseudo_palette
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Initialize the pseudo_palette pointer properly.  This fixes crash when
16bpp or 32bpp mode is selected.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-unitialized-pseudo_palette drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-unitialized-pseudo_palette
+++ a/drivers/video/tridentfb.c
@@ -1350,7 +1350,7 @@ static int __devinit trident_pci_probe(s
 
 	info->fix = tridentfb_fix;
 	info->fbops = &tridentfb_ops;
