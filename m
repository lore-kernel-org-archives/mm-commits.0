From: akpm@linux-foundation.org
Subject: + fix-failure-paths-in-modules-init-in-umemc.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:32:56 -0800
Message-ID: <200702212232.l1LMWuok028513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53206 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423211AbXBUWdH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, jens.axboe@oracle.com, pg@cs.stanford.edu


The patch titled
     Fix failure paths in modules init in umem.c
has been added to the -mm tree.  Its filename is
     fix-failure-paths-in-modules-init-in-umemc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix failure paths in modules init in umem.c
From: NeilBrown <neilb@suse.de>

If register_blkdev() or alloc-disk fail in mm_init() after
pci_register_driver() succeeds, then mm_pci_driver is not unregistered
properly:

Cc: Philip Guo <pg@cs.stanford.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/umem.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/umem.c~fix-failure-paths-in-modules-init-in-umemc drivers/block/umem.c
--- a/drivers/block/umem.c~fix-failure-paths-in-modules-init-in-umemc
+++ a/drivers/block/umem.c
@@ -1179,8 +1179,10 @@ static int __init mm_init(void)
 		return -ENOMEM;
 
 	err = major_nr = register_blkdev(0, "umem");
-	if (err < 0)
+	if (err < 0) {
+		pci_unregister_driver(&mm_pci_driver);
 		return -EIO;
+	}
 
 	for (i = 0; i < num_cards; i++) {
 		mm_gendisk[i] = alloc_disk(1 << MM_SHIFT);
@@ -1207,6 +1209,7 @@ static int __init mm_init(void)
 	return 0;
 
 out:
+	pci_unregister_driver(&mm_pci_driver);
 	unregister_blkdev(major_nr, "umem");
 	while (i--)
 		put_disk(mm_gendisk[i]);
_

Patches currently in -mm which might be from neilb@suse.de are

fix-failure-paths-in-modules-init-in-umemc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
