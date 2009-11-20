From: akpm@linux-foundation.org
Subject: [merged] arch-arm-plat-omap-drop-an-unnecessary-null-test.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:39 -0800
Message-ID: <200911201930.nAKJUdlo011185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbZKTTdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:33:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     arch/arm/plat-omap: Drop an unnecessary NULL test
has been removed from the -mm tree.  Its filename was
     arch-arm-plat-omap-drop-an-unnecessary-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm/plat-omap: Drop an unnecessary NULL test
From: Julia Lawall <julia@diku.dk>

map_iovm_area is only called from a context where its second argument is
known not to be NULL, so drop the unnecessary test.  If new could be NULL,
the initialization of da should be moved below the test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/iovmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-omap/iovmm.c~arch-arm-plat-omap-drop-an-unnecessary-null-test arch/arm/plat-omap/iovmm.c
--- a/arch/arm/plat-omap/iovmm.c~arch-arm-plat-omap-drop-an-unnecessary-null-test
+++ a/arch/arm/plat-omap/iovmm.c
@@ -446,7 +446,7 @@ static int map_iovm_area(struct iommu *o
 	struct scatterlist *sg;
 	u32 da = new->da_start;
 
-	if (!obj || !new || !sgt)
+	if (!obj || !sgt)
 		return -EINVAL;
 
 	BUG_ON(!sgtable_ok(sgt));
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch

