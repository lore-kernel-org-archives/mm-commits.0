From: akpm@linux-foundation.org
Subject: [merged] swapon-check-validity-of-swap_flags.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:26 -0700
Message-ID: <20120329191326.556FAA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51717 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab2C2TN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:27 -0400
Received: by vbnl22 with SMTP id l22so296197vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swapon: check validity of swap_flags
has been removed from the -mm tree.  Its filename was
     swapon-check-validity-of-swap_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: swapon: check validity of swap_flags

Most system calls taking flags first check that the flags passed in are
valid, and that helps userspace to detect when new flags are supported.

But swapon never did so: start checking now, to help if we ever want to
support more swap_flags in future.

It's difficult to get stray bits set in an int, and swapon is not widely
used, so this is most unlikely to break any userspace; but we can just
revert if it turns out to do so.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +++
 mm/swapfile.c        |    3 +++
 2 files changed, 6 insertions(+)

diff -puN include/linux/swap.h~swapon-check-validity-of-swap_flags include/linux/swap.h
--- a/include/linux/swap.h~swapon-check-validity-of-swap_flags
+++ a/include/linux/swap.h
@@ -21,6 +21,9 @@ struct bio;
 #define SWAP_FLAG_PRIO_SHIFT	0
 #define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
 
+#define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
+				 SWAP_FLAG_DISCARD)
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
diff -puN mm/swapfile.c~swapon-check-validity-of-swap_flags mm/swapfile.c
--- a/mm/swapfile.c~swapon-check-validity-of-swap_flags
+++ a/mm/swapfile.c
@@ -2022,6 +2022,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct page *page = NULL;
 	struct inode *inode = NULL;
 
+	if (swap_flags & ~SWAP_FLAGS_VALID)
+		return -EINVAL;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
prio_tree-debugging-patch.patch

