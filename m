From: akpm@linux-foundation.org
Subject: + btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch added to -mm
 tree
Date: Tue, 06 Dec 2016 12:50:46 -0800
Message-ID: <584724a6.gA7HgOze2WvnNJ8A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbcLFUuQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: fix race in btrfs_free_dummy_fs_info()
has been added to the -mm tree.  Its filename is
     btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

