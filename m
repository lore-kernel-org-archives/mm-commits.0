From: akpm@linux-foundation.org
Subject: [merged] mm-pincer-in-truncate_inode_pages_range.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:25 -0700
Message-ID: <201107260752.p6Q7qSSQ003132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab1GZHw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: pincer in truncate_inode_pages_range
has been removed from the -mm tree.  Its filename was
     mm-pincer-in-truncate_inode_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pincer in truncate_inode_pages_range
From: Hugh Dickins <hughd@google.com>

truncate_inode_pages_range()'s final loop has a nice pincer property,
bringing start and end together, squeezing out the last pages.  But the
range handling missed out on that, just sliding up the range, perhaps
letting pages come in behind it.  Add one more test to give it the same
pincer effect.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~mm-pincer-in-truncate_inode_pages_range mm/truncate.c
--- a/mm/truncate.c~mm-pincer-in-truncate_inode_pages_range
+++ a/mm/truncate.c
@@ -269,7 +269,7 @@ void truncate_inode_pages_range(struct a
 			index = start;
 			continue;
 		}
-		if (pvec.pages[0]->index > end) {
+		if (index == start && pvec.pages[0]->index > end) {
 			pagevec_release(&pvec);
 			break;
 		}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch
prio_tree-debugging-patch.patch

