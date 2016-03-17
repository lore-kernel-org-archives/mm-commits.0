From: akpm@linux-foundation.org
Subject: [folded-merged] btrfs-use-radix_tree_iter_retry-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 14:00:50 -0700
Message-ID: <56eb1b02.Xn4kTbc5LQqcszZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQVAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clm@fb.com, dsterba@suse.com, hughd@google.com, jbacik@fb.com, khlebnikov@openvz.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs-use-radix_tree_iter_retry-fix
has been removed from the -mm tree.  Its filename was
     btrfs-use-radix_tree_iter_retry-fix.patch

This patch was dropped because it was folded into btrfs-use-radix_tree_iter_retry.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: btrfs-use-radix_tree_iter_retry-fix

fs/btrfs/tests/btrfs-tests.c: In function 'btrfs_free_dummy_fs_info':
fs/btrfs/tests/btrfs-tests.c:149: error: incompatible type for argument 1 of 'radix_tree_iter_retry'
include/linux/radix-tree.h:399: note: expected 'struct radix_tree_iter *' but argument is of type 'struct radix_tree_iter'

Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/tests/btrfs-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/btrfs/tests/btrfs-tests.c~btrfs-use-radix_tree_iter_retry-fix fs/btrfs/tests/btrfs-tests.c
--- a/fs/btrfs/tests/btrfs-tests.c~btrfs-use-radix_tree_iter_retry-fix
+++ a/fs/btrfs/tests/btrfs-tests.c
@@ -146,7 +146,7 @@ static void btrfs_free_dummy_fs_info(str
 		/* Shouldn't happen but that kind of thinking creates CVE's */
 		if (radix_tree_exception(eb)) {
 			if (radix_tree_deref_retry(eb))
-				slot = radix_tree_iter_retry(iter);
+				slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
 		spin_unlock(&fs_info->buffer_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry.patch
sscanf-implement-basic-character-sets-fix.patch

