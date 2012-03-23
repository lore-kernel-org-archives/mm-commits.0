From: akpm@linux-foundation.org
Subject: + swapon-check-validity-of-swap_flags.patch added to -mm tree
Date: Fri, 23 Mar 2012 16:02:22 -0700
Message-ID: <20120323230222.BAE91A020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54002 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468Ab2CWXCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2012 19:02:25 -0400
Received: by laai8 with SMTP id i8so189739laa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 16:02:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     Subject: swapon: check validity of swap_flags
has been added to the -mm tree.  Its filename is
     swapon-check-validity-of-swap_flags.patch

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
Subject: Subject: swapon: check validity of swap_flags

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
linux-next.patch
mm-for-fs-add-truncate_pagecache_range.patch
mm-for-fs-add-truncate_pagecache_range-fix.patch
x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow.patch
swapon-check-validity-of-swap_flags.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

