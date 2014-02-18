From: akpm@linux-foundation.org
Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks.patch added to -mm tree
Date: Tue, 18 Feb 2014 14:07:37 -0800
Message-ID: <5303d9a9.LXGLRPUmBsqNY879%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaBRWHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:07:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, sougata@tuxera.com

Subject: + hfsplus-fix-concurrent-acess-of-alloc_blocks.patch added to -mm tree
To: sougata@tuxera.com,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:07:37 -0800


The patch titled
     Subject: fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks
has been added to the -mm tree.  Its filename is
     hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sougata Santra <sougata@tuxera.com>
Subject: fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks

Concurrent access to alloc_blocks in hfsplus_inode_info() is protected by
extents_lock mutex.  This patch fixes two instances where alloc_blocks
modification was not protected with this lock.  This fixes possible
allocation bitmap corruption in race conditions while extending and
truncating files.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks
+++ a/fs/hfsplus/extents.c
@@ -496,11 +496,13 @@ int hfsplus_file_extend(struct inode *in
 			goto insert_extent;
 	}
 out:
-	mutex_unlock(&hip->extents_lock);
 	if (!res) {
 		hip->alloc_blocks += len;
+		mutex_unlock(&hip->extents_lock);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
+		return 0;
 	}
+	mutex_unlock(&hip->extents_lock);
 	return res;
 
 insert_extent:
@@ -590,9 +592,9 @@ void hfsplus_file_truncate(struct inode
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	mutex_unlock(&hip->extents_lock);
 
 	hip->alloc_blocks = blk_cnt;
+	mutex_unlock(&hip->extents_lock);
 out:
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
_

Patches currently in -mm which might be from sougata@tuxera.com are

hfsplus-remove-unused-variable-in-hfsplus_get_block.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch

