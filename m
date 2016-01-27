From: akpm@linux-foundation.org
Subject: + btrfs-use-radix_tree_iter_retry.patch added to -mm tree
Date: Wed, 27 Jan 2016 13:37:45 -0800
Message-ID: <56a938a9.Ov19zFxht5LYNFhd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966369AbcA0Vhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 16:37:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, clm@fb.com, dsterba@suse.com, hughd@google.com, jbacik@fb.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use radix_tree_iter_retry()
has been added to the -mm tree.  Its filename is
     btrfs-use-radix_tree_iter_retry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/btrfs-use-radix_tree_iter_retry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/btrfs-use-radix_tree_iter_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: btrfs: use radix_tree_iter_retry()

Even though this is a 'can't happen' situation, use the new
radix_tree_iter_retry() pattern to eliminate a goto.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/tests/btrfs-tests.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/btrfs/tests/btrfs-tests.c~btrfs-use-radix_tree_iter_retry fs/btrfs/tests/btrfs-tests.c
--- a/fs/btrfs/tests/btrfs-tests.c~btrfs-use-radix_tree_iter_retry
+++ a/fs/btrfs/tests/btrfs-tests.c
@@ -137,7 +137,6 @@ static void btrfs_free_dummy_fs_info(str
 	void **slot;
 
 	spin_lock(&fs_info->buffer_lock);
-restart:
 	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter, 0) {
 		struct extent_buffer *eb;
 
@@ -147,7 +146,7 @@ restart:
 		/* Shouldn't happen but that kind of thinking creates CVE's */
 		if (radix_tree_exception(eb)) {
 			if (radix_tree_deref_retry(eb))
-				goto restart;
+				slot = radix_tree_iter_retry(iter);
 			continue;
 		}
 		spin_unlock(&fs_info->buffer_lock);
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch

