From: akpm@linux-foundation.org
Subject: - ubi-dereference-after-kfree-in-create_vtbl-2.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:06 -0700
Message-ID: <200705080008.l48086E1009354@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967433AbXEHAIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam.sharma@gmail.com, dedekind@infradead.org, fmalita@gmail.com, ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     UBI: dereference after kfree in create_vtbl
has been removed from the -mm tree.  Its filename was
     ubi-dereference-after-kfree-in-create_vtbl-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UBI: dereference after kfree in create_vtbl
From: "Satyam Sharma" <satyam.sharma@gmail.com>

Fix write_error logic in drivers/mtd/ubi/vtbl.c:create_vtbl().  On a write
failure, we add the corrupted physical eraseblock to the corrupted list,
and then attempt to retry (upto a maximum of 5 times).  Also, fix an oops
by pushing kfree(new_seb) below after dereferencing it for
ubi_scan_add_to_list().

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Florin Malita <fmalita@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/vtbl.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/ubi/vtbl.c~ubi-dereference-after-kfree-in-create_vtbl-2 drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c~ubi-dereference-after-kfree-in-create_vtbl-2
+++ a/drivers/mtd/ubi/vtbl.c
@@ -317,14 +317,12 @@ retry:
 	return err;
 
 write_error:
-	kfree(new_seb);
 	/* May be this physical eraseblock went bad, try to pick another one */
-	if (++tries <= 5) {
-		err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
-					   &si->corr);
+	err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec, &si->corr);
+	kfree(new_seb);
+	if (++tries <= 5)
 		if (!err)
 			goto retry;
-	}
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
_

Patches currently in -mm which might be from satyam.sharma@gmail.com are

origin.patch
git-ubi.patch
