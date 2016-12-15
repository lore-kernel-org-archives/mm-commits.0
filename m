From: akpm@linux-foundation.org
Subject: [merged] btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:48:47 -0800
Message-ID: <5852e58f.orQNQ63rphdJVpjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755151AbcLOSss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: fix race in btrfs_free_dummy_fs_info()
has been removed from the -mm tree.  Its filename was
     btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: btrfs: fix race in btrfs_free_dummy_fs_info()

We drop the lock which protects the radix tree, so we must call
radix_tree_iter_next() in order to avoid a modification to the tree
invalidating the iterator state.

Link: http://lkml.kernel.org/r/1480369871-5271-54-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/tests/btrfs-tests.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/btrfs/tests/btrfs-tests.c~btrfs-fix-race-in-btrfs_free_dummy_fs_info fs/btrfs/tests/btrfs-tests.c
--- a/fs/btrfs/tests/btrfs-tests.c~btrfs-fix-race-in-btrfs_free_dummy_fs_info
+++ a/fs/btrfs/tests/btrfs-tests.c
@@ -162,6 +162,7 @@ void btrfs_free_dummy_fs_info(struct btr
 				slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
+		slot = radix_tree_iter_next(&iter);
 		spin_unlock(&fs_info->buffer_lock);
 		free_extent_buffer_stale(eb);
 		spin_lock(&fs_info->buffer_lock);
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch

