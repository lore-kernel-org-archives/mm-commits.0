From: akpm@linux-foundation.org
Subject: + fix-null-dereference-in-umemc.patch added to -mm tree
Date: Thu, 06 Dec 2007 15:59:23 -0800
Message-ID: <200712062359.lB6NxNJT020612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbXLFX7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 18:59:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, dgc@sgi.com


The patch titled
     Fix NULL dereference in umem.c
has been added to the -mm tree.  Its filename is
     fix-null-dereference-in-umemc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix NULL dereference in umem.c
From: Neil Brown <neilb@suse.de>

Fix NULL dereference in umem.c

Signed-off-by: Neil Brown <neilb@suse.de>
Tested-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/umem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/umem.c~fix-null-dereference-in-umemc drivers/block/umem.c
--- a/drivers/block/umem.c~fix-null-dereference-in-umemc
+++ a/drivers/block/umem.c
@@ -484,7 +484,8 @@ static void process_page(unsigned long d
 		page->idx++;
 		if (page->idx >= bio->bi_vcnt) {
 			page->bio = bio->bi_next;
-			page->idx = page->bio->bi_idx;
+			if (page->bio)
+				page->idx = page->bio->bi_idx;
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle,
_

Patches currently in -mm which might be from neilb@suse.de are

fix-null-dereference-in-umemc.patch
git-md-accel.patch
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
