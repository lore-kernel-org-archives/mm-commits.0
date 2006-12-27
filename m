From: akpm@osdl.org
Subject: + ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:47:18 -0800
Message-ID: <200612270747.kBR7lIUg004746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbWL0Hrh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:47:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@mellanox.co.il, dotanb@mellanox.co.il, roland@digitalvampire.org


The patch titled
     IB/mthca: Fix FMR breakage caused by kmemdup() conversion
has been added to the -mm tree.  Its filename is
     ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ib-mthca-fix-fmr-breakage-caused-by-kmemdup-conversion.patch
git-infiniband.patch

