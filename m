From: akpm@linux-foundation.org
Subject: - ubi-dereference-after-kfree-in-create_vtbl.patch removed from -mm tree
Date: Fri, 04 May 2007 15:12:29 -0700
Message-ID: <200705042212.l44MCTtt021560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031334AbXEDWMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 18:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmalita@gmail.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     UBI: dereference after kfree in create_vtbl
has been removed from the -mm tree.  Its filename was
     ubi-dereference-after-kfree-in-create_vtbl.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: UBI: dereference after kfree in create_vtbl
From: Florin Malita <fmalita@gmail.com>

Coverity (CID 1614) spotted new_seb being dereferenced after kfree() in
create_vtbl's write_error path.

Signed-off-by: Florin Malita <fmalita@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/vtbl.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/ubi/vtbl.c~ubi-dereference-after-kfree-in-create_vtbl drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c~ubi-dereference-after-kfree-in-create_vtbl
+++ a/drivers/mtd/ubi/vtbl.c
@@ -317,14 +317,13 @@ retry:
 	return err;
 
 write_error:
-	kfree(new_seb);
-	/* May be this physical eraseblock went bad, try to pick another one */
-	if (++tries <= 5) {
+	/* Maybe this physical eraseblock went bad, try to pick another one */
+	if (++tries <= 5)
 		err = ubi_scan_add_to_list(si, new_seb->pnum, new_seb->ec,
 					   &si->corr);
-		if (!err)
-			goto retry;
-	}
+	kfree(new_seb);	
+	if (!err)
+		goto retry;
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
_

Patches currently in -mm which might be from fmalita@gmail.com are

ubi-dereference-after-kfree-in-create_vtbl.patch
devpts-add-fsnotify-create-event.patch
