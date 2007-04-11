From: akpm@linux-foundation.org
Subject: + md-fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap.patch added to -mm tree
Date: Tue, 10 Apr 2007 20:50:52 -0700
Message-ID: <200704110350.l3B3oqlB027380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030758AbXDKDwO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 23:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     md: fix calculation for size of filemap_attr array in md/bitmap
has been added to the -mm tree.  Its filename is
     md-fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix calculation for size of filemap_attr array in md/bitmap
From: Neil Brown <neilb@suse.de>

If 'num_pages' were ever 1 more than a multiple of 8 (32bit platforms) for
of 16 (64 bit platforms).  filemap_attr would be allocated one 'unsigned
long' shorter than required.  We need a round-up in there.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/md/bitmap.c~md-fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap
+++ a/drivers/md/bitmap.c
@@ -863,9 +863,7 @@ static int bitmap_init_from_disk(struct 
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
-		(((num_pages*4/8)+sizeof(unsigned long)-1)
-		 /sizeof(unsigned long))
-		*sizeof(unsigned long),
+		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto out;
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap.patch
device_schedule_callback-needs-a-module-reference.patch
device_schedule_callback-needs-a-module-reference-fix.patch
sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
