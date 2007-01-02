From: akpm@osdl.org
Subject: - ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:06 -0800
Message-ID: <200701020724.l027O6JF012919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbXABHYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@mellanox.co.il, dotanb@mellanox.co.il, roland@digitalvampire.org, mm-commits@vger.kernel.org


The patch titled
     IB/mthca: Fix FMR breakage caused by kmemdup() conversion
has been removed from the -mm tree.  Its filename was
     ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IB/mthca: Fix FMR breakage caused by kmemdup() conversion
From: Michael S. Tsirkin <mst@mellanox.co.il>

Commit bed8bdfd ("IB: kmemdup() cleanup") introduced one bad conversion to
kmemdup() in mthca_alloc_fmr(), where the structure allocated and the
structure copied are not the same size.  Revert this back to the original
kmalloc()/memcpy() code.

Reported-by: Dotan Barak <dotanb@mellanox.co.il>.
Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>
Signed-off-by: Roland Dreier <roland@digitalvampire.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/mthca/mthca_provider.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/mthca/mthca_provider.c~ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion drivers/infiniband/hw/mthca/mthca_provider.c
--- a/drivers/infiniband/hw/mthca/mthca_provider.c~ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion
+++ a/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1100,10 +1100,11 @@ static struct ib_fmr *mthca_alloc_fmr(st
 	struct mthca_fmr *fmr;
 	int err;
 
-	fmr = kmemdup(fmr_attr, sizeof *fmr, GFP_KERNEL);
+	fmr = kmalloc(sizeof *fmr, GFP_KERNEL);
 	if (!fmr)
 		return ERR_PTR(-ENOMEM);
 
+	memcpy(&fmr->attr, fmr_attr, sizeof *fmr_attr);
 	err = mthca_fmr_alloc(to_mdev(pd->device), to_mpd(pd)->pd_num,
 			     convert_access(mr_access_flags), fmr);
 
_

Patches currently in -mm which might be from mst@mellanox.co.il are

git-infiniband.patch
