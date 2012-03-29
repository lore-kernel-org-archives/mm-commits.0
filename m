From: akpm@linux-foundation.org
Subject: [merged] mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:24 -0700
Message-ID: <20120329191324.8989DA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:54552 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab2C2TN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:26 -0400
Received: by vcbfk26 with SMTP id fk26so301732vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, coredump: fail allocations when coredumping instead of oom killing
has been removed from the -mm tree.  Its filename was
     mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, coredump: fail allocations when coredumping instead of oom killing

The size of coredump files is limited by RLIMIT_CORE, however, allocating
large amounts of memory results in three negative consequences:

 - the coredumping process may be chosen for oom kill and quickly deplete
   all memory reserves in oom conditions preventing further progress from
   being made or tasks from exiting,

 - the coredumping process may cause other processes to be oom killed
   without fault of their own as the result of a SIGSEGV, for example, in
   the coredumping process, or

 - the coredumping process may result in a livelock while writing to the
   dump file if it needs memory to allocate while other threads are in
   the exit path waiting on the coredumper to complete.

This is fixed by implying __GFP_NORETRY in the page allocator for
coredumping processes when reclaim has failed so the allocations fail and
the process continues to exit.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing mm/page_alloc.c
--- a/mm/page_alloc.c~mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing
+++ a/mm/page_alloc.c
@@ -2308,6 +2308,10 @@ rebalance:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			if (oom_killer_disabled)
 				goto nopage;
+			/* Coredumps can quickly deplete all memory reserves */
+			if ((current->flags & PF_DUMPCORE) &&
+			    !(gfp_mask & __GFP_NOFAIL))
+				goto nopage;
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
hugetlbfs-remove-unregister_filesystem-when-initializing-module.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch

