From: akpm@linux-foundation.org
Subject: + arch-arm-plat-omap-drop-an-unnecessary-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:37 -0800
Message-ID: <200911030624.nA36ObTP030256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbZKCGY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, tony@atomide.com


The patch titled
     arch/arm/plat-omap: Drop an unnecessary NULL test
has been added to the -mm tree.  Its filename is
     arch-arm-plat-omap-drop-an-unnecessary-null-test.patch

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

origin.patch
linux-next.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-message-move-dereference-after-null-test.patch
drivers-acpi-move-dereference-after-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-ata-libata-move-dereference-after-null-test.patch
drivers-scsi-remove-unnecessary-null-test.patch
arch-arm-plat-omap-drop-an-unnecessary-null-test.patch
arch-arm-plat-s3c24xx-move-dereference-after-null-test.patch

