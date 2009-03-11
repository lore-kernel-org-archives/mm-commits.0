From: akpm@linux-foundation.org
Subject: [merged] x86-agp-tight-check-to-update-amd-nb-aperture.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:31 -0700
Message-ID: <200903111809.n2BI9Vie019950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbZCKSND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, airlied@linux.ie, jetrull@sbcglobal.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86/agp: tighten check to update amd nb aperture
has been removed from the -mm tree.  Its filename was
     x86-agp-tight-check-to-update-amd-nb-aperture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/agp: tighten check to update amd nb aperture
From: Yinghai Lu <yinghai@kernel.org>

Impact: fix bug to make agp work with dri

Jeffrey reported that dri does work with 64bit, but doesn't work with
32bit it turns out NB aperture is 32M, aperture on agp is 128M

64bit is using 64M for vaidation for 64 iommu/gart 32bit is only using
32M..., and will not update the nb aperture.

So try to compare nb apterture and agp apterture before leaving not
touch nb aperture.

Reported-by: Jeffrey Trull <jetrull@sbcglobal.net>
Tested-by: Jeffrey Trull <jetrull@sbcglobal.net>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Dave Airlie <airlied@linux.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/amd64-agp.c~x86-agp-tight-check-to-update-amd-nb-aperture drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~x86-agp-tight-check-to-update-amd-nb-aperture
+++ a/drivers/char/agp/amd64-agp.c
@@ -271,15 +271,15 @@ static __devinit int fix_northbridge(str
 	nb_order = (nb_order >> 1) & 7;
 	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
 	nb_aper = nb_base << 25;
-	if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
-		return 0;
-	}
 
 	/* Northbridge seems to contain crap. Try the AGP bridge. */
 
 	pci_read_config_word(agp, cap+0x14, &apsize);
-	if (apsize == 0xffff)
+	if (apsize == 0xffff) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
 		return -1;
+	}
 
 	apsize &= 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
@@ -301,6 +301,11 @@ static __devinit int fix_northbridge(str
 		order = nb_order;
 	}
 
+	if (nb_order >= order) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
+	}
+
 	dev_info(&agp->dev, "aperture from AGP @ %Lx size %u MB\n",
 		 aper, 32 << order);
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

