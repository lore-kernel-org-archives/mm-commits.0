Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A8A301474;
	Tue, 24 Feb 2026 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960449; cv=none; b=t1L7PioGkv8YOh+aDM60aN6DcWABf5grsCTH6PMuB0kjBo5y/OSf9D7SHLMRuczisf4+5nRSMuOlRogIIX56pGy8nhDJ+KqR/UpBN+cdYndja3EnS+Ky55skJbp65x2w/yihEaYhNXiP17fzLk9Tkq4TrV73U0vYnXPPBJRcwWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960449; c=relaxed/simple;
	bh=zkdm2ryg0cgVtXUMHIvYuUUc5ml0Y7O4CvflgM8vJuU=;
	h=Date:To:From:Subject:Message-Id; b=H55aU5L3+AkpmfPZHMNgoy8/hk4R6yAa1/2wzBpOVzz+J1yK6ZhCkOnPzzP46hxVoYF2FcmInArSzipWQmPKKsLoWNAC7w5YiqgCllxUlEj0yiewgnDL2z0rifvigZZHwnKYvHlYydqdW7H1MebdsE20QxrLBU3ZHqZN+c3uPgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1mcGY/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1mcGY/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E420AC116D0;
	Tue, 24 Feb 2026 19:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960449;
	bh=zkdm2ryg0cgVtXUMHIvYuUUc5ml0Y7O4CvflgM8vJuU=;
	h=Date:To:From:Subject:From;
	b=z1mcGY/Wy88y1S4VBC3ycdrHIo0Xg344zQbnblg0JXYNnQwo2Sc5LWpxT+NmXcLmQ
	 0NbXyYNagXfs0OQKgpyfBCuNuL2bh/5qIhVckbCOlH9pwSZUK0kytXxmtWDLi5Tfcg
	 yr/dfVwlyDAr5X8g6bwXZXjckb4P9zIsbPmg0W6Q=
Date: Tue, 24 Feb 2026 11:14:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,minchan@kernel.org,lorenzo.stoakes@oracle.com,joel@joelfernandes.org,david@kernel.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch removed from -mm tree
Message-Id: <20260224191408.E420AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/tracing: rss_stat: ensure curr is false from kthread context
has been removed from the -mm tree.  Its filename was
     mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm/tracing: rss_stat: ensure curr is false from kthread context
Date: Thu, 19 Feb 2026 15:36:56 -0800

The rss_stat trace event allows userspace tools, like Perfetto [1], to
inspect per-process RSS metric changes over time.

The curr field was introduced to rss_stat in commit e4dcad204d3a
("rss_stat: add support to detect RSS updates of external mm").  Its
intent is to indicate whether the RSS update is for the mm_struct of the
current execution context; and is set to false when operating on a remote
mm_struct (e.g., via kswapd or a direct reclaimer).

However, an issue arises when a kernel thread temporarily adopts a user
process's mm_struct.  Kernel threads do not have their own mm_struct and
normally have current->mm set to NULL.  To operate on user memory, they
can "borrow" a memory context using kthread_use_mm(), which sets
current->mm to the user process's mm.

This can be observed, for example, in the USB Function Filesystem (FFS)
driver.  The ffs_user_copy_worker() handles AIO completions and uses
kthread_use_mm() to copy data to a user-space buffer.  If a page fault
occurs during this copy, the fault handler executes in the kthread's
context.

At this point, current is the kthread, but current->mm points to the user
process's mm.  Since the rss_stat event (from the page fault) is for that
same mm, the condition current->mm == mm becomes true, causing curr to be
incorrectly set to true when the trace event is emitted.

This is misleading because it suggests the mm belongs to the kthread,
confusing userspace tools that track per-process RSS changes and
corrupting their mm_id-to-process association.

Fix this by ensuring curr is always false when the trace event is emitted
from a kthread context by checking for the PF_KTHREAD flag.

Link: https://lkml.kernel.org/r/20260219233708.1971199-1-kaleshsingh@google.com
Link: https://perfetto.dev/ [1]
Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/trace/events/kmem.h~mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context
+++ a/include/trace/events/kmem.h
@@ -440,7 +440,13 @@ TRACE_EVENT(rss_stat,
 
 	TP_fast_assign(
 		__entry->mm_id = mm_ptr_to_hash(mm);
-		__entry->curr = !!(current->mm == mm);
+		/*
+		 * curr is true if the mm matches the current task's mm_struct.
+		 * Since kthreads (PF_KTHREAD) have no mm_struct of their own
+		 * but can borrow one via kthread_use_mm(), we must filter them
+		 * out to avoid incorrectly attributing the RSS update to them.
+		 */
+		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
 		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);
_

Patches currently in -mm which might be from kaleshsingh@google.com are


