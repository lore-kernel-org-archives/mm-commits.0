From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-msync-v8-fix.patch added to -mm tree
Date: Thu, 21 Jan 2016 12:46:00 -0800
Message-ID: <56a14388.Vt9tsc/m9BCfy4eo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbcAUUqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 15:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: clear TOWRITE flag after flush is complete
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-msync-v8-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-msync-v8-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-msync-v8-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: clear TOWRITE flag after flush is complete

Previously in dax_writeback_one() we cleared the PAGECACHE_TAG_TOWRITE
flag before we had actually flushed the tagged radix tree entry to media. 
This is incorrect because of the following race:

Thread 1				Thread 2
--------				--------
dax_writeback_mapping_range()
tag entry with PAGECACHE_TAG_TOWRITE
					dax_writeback_mapping_range()
					tag entry with PAGECACHE_TAG_TOWRITE
					dax_writeback_one()
					radix_tree_tag_clear(TOWRITE)
TOWRITE flag is no longer set,
  find_get_entries_tag() finds no
  entries, return
					flush entry to media

In this case thread 1 returns before the data for the dirty entry is
actually durable on media.

Fix this by only clearing the PAGECACHE_TAG_TOWRITE flag after all flushing
is complete.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v8-fix fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v8-fix
+++ a/fs/dax.c
@@ -406,8 +406,6 @@ static int dax_writeback_one(struct bloc
 	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
 		goto unlock;
 
-	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
-
 	if (WARN_ON_ONCE(type != RADIX_DAX_PTE && type != RADIX_DAX_PMD)) {
 		ret = -EIO;
 		goto unlock;
@@ -431,6 +429,10 @@ static int dax_writeback_one(struct bloc
 	}
 
 	wb_cache_pmem(dax.addr, dax.size);
+
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
 	return ret;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2.patch
dax-add-support-for-fsync-msync-v8-fix-3.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

