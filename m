From: akpm@linux-foundation.org
Subject: [merged] btrfs-use-radix_tree_iter_retry.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:41:49 -0700
Message-ID: <56f0406d.r2ZsfXIjeR/B/GGy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbcCUTVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, clm@fb.com, dsterba@suse.com, hughd@google.com, jbacik@fb.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use radix_tree_iter_retry()
has been removed from the -mm tree.  Its filename was
     btrfs-use-radix_tree_iter_retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: btrfs: use radix_tree_iter_retry()

Even though this is a 'can't happen' situation, use the new
radix_tree_iter_retry() pattern to eliminate a goto.

[akpm@linux-foundation.org: fix btrfs build]
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
+				slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
 		spin_unlock(&fs_info->buffer_lock);
_

Patches currently in -mm which might be from willy@linux.intel.com are


