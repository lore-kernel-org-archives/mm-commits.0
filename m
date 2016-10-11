From: akpm@linux-foundation.org
Subject: [patch 005/102] fs/select: add vmalloc fallback for select(2)
Date: Tue, 11 Oct 2016 13:51:14 -0700
Message-ID: <57fd50c2.CUIFLKdWZeA2Jtrx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, David.Laight@ACULAB.COM, eric.dumazet@gmail.com, hillf.zj@alibaba-inc.com, jbaron@akamai.com, mhocko@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk

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
