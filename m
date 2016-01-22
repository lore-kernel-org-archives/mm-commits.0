From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-support-for-fsync-msync-v7.patch removed
 from -mm tree
Date: Fri, 22 Jan 2016 14:57:55 -0800
Message-ID: <56a2b3f3.2VctxEEUMQfl3ULX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbcAVW54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:57:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add support for fsync/msync
has been removed from the -mm tree.  Its filename was
     dax-add-support-for-fsync-msync-v7.patch

This patch was dropped because it was folded into dax-add-support-for-fsync-sync.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add support for fsync/msync

3) Removed second verification of our radix tree entry before cache flush
in dax_writeback_one(). (Jan Kara)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v7 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v7
+++ a/fs/dax.c
@@ -420,23 +420,14 @@ static int dax_writeback_one(struct bloc
 
 	if (WARN_ON_ONCE(ret < dax.size)) {
 		ret = -EIO;
-		dax_unmap_atomic(bdev, &dax);
-		return ret;
-	}
-
-	spin_lock_irq(&mapping->tree_lock);
-	/*
-	 * We need to revalidate our radix entry while holding tree_lock
-	 * before we do the writeback.
-	 */
-	if (!__radix_tree_lookup(page_tree, index, &node, &slot))
-		goto unmap;
-	if (*slot != entry)
 		goto unmap;
+	}
 
 	wb_cache_pmem(dax.addr, dax.size);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
+	return ret;
+
  unlock:
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2-v2.patch
dax-add-support-for-fsync-msync-v8-fix-3-v2.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

