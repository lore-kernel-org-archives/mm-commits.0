From: akpm@linux-foundation.org
Subject: + fs-select-add-vmalloc-fallback-for-select2.patch added to -mm
 tree
Date: Tue, 27 Sep 2016 14:38:53 -0700
Message-ID: <57eae6ed.tvf9FoFakzNHMLoE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcI0Viy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 17:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, David.Laight@ACULAB.COM, eric.dumazet@gmail.com, hillf.zj@alibaba-inc.com, jbaron@akamai.com, mhocko@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/select: add vmalloc fallback for select(2)
has been added to the -mm tree.  Its filename is
     fs-select-add-vmalloc-fallback-for-select2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-select-add-vmalloc-fallback-for-select2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-select-add-vmalloc-fallback-for-select2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: fs/select: add vmalloc fallback for select(2)

The select(2) syscall performs a kmalloc(size, GFP_KERNEL) where size grows
with the number of fds passed. We had a customer report page allocation
failures of order-4 for this allocation. This is a costly order, so it might
easily fail, as the VM expects such allocation to have a lower-order fallback.

Such trivial fallback is vmalloc(), as the memory doesn't have to be physically
contiguous and the allocation is temporary for the duration of the syscall
only. There were some concerns, whether this would have negative impact on the
system by exposing vmalloc() to userspace. Although an excessive use of vmalloc
can cause some system wide performance issues - TLB flushes etc. - a large
order allocation is not for free either and an excessive reclaim/compaction can
have a similar effect. Also note that the size is effectively limited by
RLIMIT_NOFILE which defaults to 1024 on the systems I checked. That means the
bitmaps will fit well within single page and thus the vmalloc() fallback could
be only excercised for processes where root allows a higher limit.

Note that the poll(2) syscall seems to use a linked list of order-0 pages, so
it doesn't need this kind of fallback.

[eric.dumazet@gmail.com: fix failure path logic]
[akpm@linux-foundation.org: use proper type for size]
Link: http://lkml.kernel.org/r/20160927084536.5923-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/select.c~fs-select-add-vmalloc-fallback-for-select2 fs/select.c
--- a/fs/select.c~fs-select-add-vmalloc-fallback-for-select2
+++ a/fs/select.c
@@ -29,6 +29,7 @@
 #include <linux/sched/rt.h>
 #include <linux/freezer.h>
 #include <net/busy_poll.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
@@ -554,7 +555,7 @@ int core_sys_select(int n, fd_set __user
 	fd_set_bits fds;
 	void *bits;
 	int ret, max_fds;
-	unsigned int size;
+	size_t size, alloc_size;
 	struct fdtable *fdt;
 	/* Allocate small arguments on the stack to save memory and be faster */
 	long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];
@@ -581,7 +582,14 @@ int core_sys_select(int n, fd_set __user
 	if (size > sizeof(stack_fds) / 6) {
 		/* Not enough space in on-stack array; must use kmalloc */
 		ret = -ENOMEM;
-		bits = kmalloc(6 * size, GFP_KERNEL);
+		if (size > (SIZE_MAX / 6))
+			goto out_nofds;
+
+		alloc_size = 6 * size;
+		bits = kmalloc(alloc_size, GFP_KERNEL|__GFP_NOWARN);
+		if (!bits && alloc_size > PAGE_SIZE)
+			bits = vmalloc(alloc_size);
+
 		if (!bits)
 			goto out_nofds;
 	}
@@ -618,7 +626,7 @@ int core_sys_select(int n, fd_set __user
 
 out:
 	if (bits != stack_fds)
-		kfree(bits);
+		kvfree(bits);
 out_nofds:
 	return ret;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

fs-select-add-vmalloc-fallback-for-select2.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-create-compact_gap-wrapper-fix.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority-fix.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

