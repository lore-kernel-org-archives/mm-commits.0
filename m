From: akpm@linux-foundation.org
Subject: - tridentfb-improve-probe-function.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:01 -0700
Message-ID: <200807242331.m6ONV1oJ011574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbYGXXbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: improve probe function
has been removed from the -mm tree.  Its filename was
     tridentfb-improve-probe-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: improve probe function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add missing release of allocated fb_info structure and move enable_mmio() to
fix error path.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-improve-probe-function drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-improve-probe-function
+++ a/drivers/video/tridentfb.c
@@ -1287,6 +1287,7 @@ static int __devinit trident_pci_probe(s
 
 	if (!request_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len, "tridentfb")) {
 		debug("request_region failed!\n");
+		framebuffer_release(info);
 		return -1;
 	}
 
@@ -1299,8 +1300,6 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap1;
 	}
 
-	enable_mmio();
