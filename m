From: akpm@linux-foundation.org
Subject: [alternative-merged]
 dax-fix-null-pointer-dereference-in-__dax_dbg.patch removed from -mm tree
Date: Fri, 08 Jan 2016 12:41:51 -0800
Message-ID: <56901f0f.7edOrX7kT9hYcres%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbcAHUlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 15:41:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix NULL pointer dereference in __dax_dbg()
has been removed from the -mm tree.  Its filename was
     dax-fix-null-pointer-dereference-in-__dax_dbg.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix NULL pointer dereference in __dax_dbg()

__dax_dbg() currently assumes that bh->b_bdev is non-NULL, passing it into
bdevname() where is is dereferenced.  This assumption isn't always true -
when called for reads of holes, ext4_dax_mmap_get_block() returns a buffer
head where bh->b_bdev is never set.  I hit this BUG while testing the DAX
PMD fault path.

Instead, verify that we have a valid bh->b_bdev, else just say "unknown"
for the block device.

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

 fs/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-fix-null-pointer-dereference-in-__dax_dbg fs/dax.c
--- a/fs/dax.c~dax-fix-null-pointer-dereference-in-__dax_dbg
+++ a/fs/dax.c
@@ -563,7 +563,12 @@ static void __dax_dbg(struct buffer_head
 {
 	if (bh) {
 		char bname[BDEVNAME_SIZE];
-		bdevname(bh->b_bdev, bname);
+
+		if (bh->b_bdev)
+			bdevname(bh->b_bdev, bname);
+		else
+			snprintf(bname, BDEVNAME_SIZE, "unknown");
+
 		pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
 			"length %zd fallback: %s\n", fn, current->comm,
 			address, bname, bh->b_state, (u64)bh->b_blocknr,
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

