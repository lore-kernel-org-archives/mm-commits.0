From: akpm@linux-foundation.org
Subject: + swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
 added to -mm tree
Date: Thu, 13 Feb 2014 14:27:19 -0800
Message-ID: <52fd46c7.Lm7Re+H76QZUP6cg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaBMW1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, hughd@google.com

Subject: + swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch added to -mm tree
To: hughd@google.com,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:27:19 -0800


The patch titled
     Subject: lib/radix-tree.c: swapoff tmpfs radix_tree: remember to rcu_read_unlock
has been added to the -mm tree.  Its filename is
     swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: lib/radix-tree.c: swapoff tmpfs radix_tree: remember to rcu_read_unlock

Running fsx on tmpfs with concurrent memhog-swapoff-swapon, lots of

BUG: sleeping function called from invalid context at kernel/fork.c:606
in_atomic(): 0, irqs_disabled(): 0, pid: 1394, name: swapoff
1 lock held by swapoff/1394:
 #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff812520a1>] radix_tree_locate_item+0x1f/0x2b6
followed by
================================================
[ BUG: lock held when returning to user space! ]
3.14.0-rc1 #3 Not tainted
------------------------------------------------
swapoff/1394 is leaving the kernel with locks still held!
1 lock held by swapoff/1394:
 #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff812520a1>] radix_tree_locate_item+0x1f/0x2b6
after which the system recovered nicely.

Whoops, I long ago forgot the rcu_read_unlock() on one unlikely branch.

Fixes e504f3fdd63d ("tmpfs radix_tree: locate_item to speed up swapoff")

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock lib/radix-tree.c
--- a/lib/radix-tree.c~swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock
+++ a/lib/radix-tree.c
@@ -1253,8 +1253,10 @@ unsigned long radix_tree_locate_item(str
 
 		node = indirect_to_ptr(node);
 		max_index = radix_tree_maxindex(node->height);
-		if (cur_index > max_index)
+		if (cur_index > max_index) {
+			rcu_read_unlock();
 			break;
+		}
 
 		cur_index = __locate(node, item, cur_index, &found_index);
 		rcu_read_unlock();
_

Patches currently in -mm which might be from hughd@google.com are

swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compaction-avoid-isolating-pinned-pages.patch
linux-next.patch

