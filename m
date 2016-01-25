From: akpm@linux-foundation.org
Subject: [merged] dax-fix-null-pointer-dereference-in-__dax_dbg.patch
 removed from -mm tree
Date: Mon, 25 Jan 2016 10:58:30 -0800
Message-ID: <56a67056.7beFW9gbnI2dMOGK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbcAYS6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix NULL pointer dereference in __dax_dbg()
has been removed from the -mm tree.  Its filename was
     dax-fix-null-pointer-dereference-in-__dax_dbg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


