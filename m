From: akpm@linux-foundation.org
Subject: + dax-fix-null-pointer-dereference-in-__dax_dbg.patch added to
 -mm tree
Date: Fri, 08 Jan 2016 12:48:54 -0800
Message-ID: <569020b6.jzf70umzQvmxQbW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbcAHUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 15:48:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix NULL pointer dereference in __dax_dbg()
has been added to the -mm tree.  Its filename is
     dax-fix-null-pointer-dereference-in-__dax_dbg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-null-pointer-dereference-in-__dax_dbg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-null-pointer-dereference-in-__dax_dbg.patch

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
Subject: dax: fix NULL pointer dereference in __dax_dbg()

In __dax_pmd_fault() we currently assume that get_block() will always set
bh.b_bdev and we unconditionally dereference it in __dax_dbg().  This
assumption isn't always true - when called for reads of holes
ext4_dax_mmap_get_block() returns a buffer head where bh->b_bdev is never
set.  I hit this BUG while testing the DAX PMD fault path.

Instead, initialize bh.b_bdev before passing bh into get_block().  It is
possible that the filesystem's get_block() will update bh.b_bdev, and this
is fine - we just want to initialize bh.b_bdev to something reasonable so
that the calls to __dax_dbg() work and print something useful.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dax.c~dax-fix-null-pointer-dereference-in-__dax_dbg fs/dax.c
--- a/fs/dax.c~dax-fix-null-pointer-dereference-in-__dax_dbg
+++ a/fs/dax.c
@@ -624,6 +624,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	}
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
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
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

