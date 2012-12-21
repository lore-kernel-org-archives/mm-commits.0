From: akpm@linux-foundation.org
Subject: [merged] hfsplus-avoid-crash-on-failed-block-map-free.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:38 -0800
Message-ID: <20121221203939.293C5200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62759 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LUUjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:41 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so272658eei.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, slava@dubeyko.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: avoid crash on failed block map free
has been removed from the -mm tree.  Its filename was
     hfsplus-avoid-crash-on-failed-block-map-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: hfsplus: avoid crash on failed block map free

If the read fails we kmap an error code.  This doesn't end well.  Instead
print a critical error and pray.  This mirrors the rest of the fs
behaviour with critical error cases.

Acked-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/bitmap.c~hfsplus-avoid-crash-on-failed-block-map-free fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfsplus-avoid-crash-on-failed-block-map-free
+++ a/fs/hfsplus/bitmap.c
@@ -176,12 +176,14 @@ int hfsplus_block_free(struct super_bloc
 	dprint(DBG_BITMAP, "block_free: %u,%u\n", offset, count);
 	/* are all of the bits in range? */
 	if ((offset + count) > sbi->total_blocks)
-		return -2;
+		return -ENOENT;
 
 	mutex_lock(&sbi->alloc_mutex);
 	mapping = sbi->alloc_file->i_mapping;
 	pnr = offset / PAGE_CACHE_BITS;
 	page = read_mapping_page(mapping, pnr, NULL);
+	if (IS_ERR(page))
+		goto kaboom;
 	pptr = kmap(page);
 	curr = pptr + (offset & (PAGE_CACHE_BITS - 1)) / 32;
 	end = pptr + PAGE_CACHE_BITS / 32;
@@ -214,6 +216,8 @@ int hfsplus_block_free(struct super_bloc
 		set_page_dirty(page);
 		kunmap(page);
 		page = read_mapping_page(mapping, ++pnr, NULL);
+		if (IS_ERR(page))
+			goto kaboom;
 		pptr = kmap(page);
 		curr = pptr;
 		end = pptr + PAGE_CACHE_BITS / 32;
@@ -232,4 +236,11 @@ out:
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return 0;
+
+kaboom:
+	printk(KERN_CRIT "hfsplus: unable to mark blocks free: error %ld\n",
+			PTR_ERR(page));
+	mutex_unlock(&sbi->alloc_mutex);
+
+	return -EIO;
 }
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fork-unshare-remove-dead-code.patch

