From: akpm@linux-foundation.org
Subject: + ubi-dereference-after-kfree-in-create_vtbl.patch added to -mm tree
Date: Thu, 03 May 2007 13:44:52 -0700
Message-ID: <200705032044.l43Kiqb2019098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbXECUrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fmalita@gmail.com, dedekind@infradead.org


The patch titled
     UBI: dereference after kfree in create_vtbl
has been added to the -mm tree.  Its filename is
     ubi-dereference-after-kfree-in-create_vtbl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
