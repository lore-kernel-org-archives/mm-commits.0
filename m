From: akpm@linux-foundation.org
Subject: [merged] fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:56 -0800
Message-ID: <20121219204057.3D445100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:59729 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2LSUk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:58 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so278056yen.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: protect architectures where THREAD_SIZE >= PAGE_SIZE against fork bombs
has been removed from the -mm tree.  Its filename was
     fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: fork: protect architectures where THREAD_SIZE >= PAGE_SIZE against fork bombs

Because those architectures will draw their stacks directly from the page
allocator, rather than the slab cache, we can directly pass __GFP_KMEMCG
flag, and issue the corresponding free_pages.

This code path is taken when the architecture doesn't define
CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
THREAD_SIZE >= PAGE_SIZE.  Luckily, most - if not all - of the remaining
architectures fall in this category.

This will guarantee that every stack page is accounted to the memcg the
process currently lives on, and will have the allocations to fail if they
go over limit.

For the time being, I am defining a new variant of THREADINFO_GFP, not to
mess with the other path.  Once the slab is also tracked by memcg, we can
get rid of that flag.

Tested to successfully protect against :(){ :|:& };:

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Frederic Weisbecker <fweisbec@redhat.com>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    2 ++
 kernel/fork.c               |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/thread_info.h~fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs include/linux/thread_info.h
--- a/include/linux/thread_info.h~fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs
+++ a/include/linux/thread_info.h
@@ -61,6 +61,8 @@ extern long do_no_restart_syscall(struct
 # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
+#define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
+
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
diff -puN kernel/fork.c~fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs kernel/fork.c
--- a/kernel/fork.c~fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs
+++ a/kernel/fork.c
@@ -146,7 +146,7 @@ void __weak arch_release_thread_info(str
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
+	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
 					     THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
@@ -154,7 +154,7 @@ static struct thread_info *alloc_thread_
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	free_memcg_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

