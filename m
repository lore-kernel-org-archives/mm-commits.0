Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45AF18A93F
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771546970; cv=none; b=S5U6EZK0tpZS8/lS1kNrJkharbetklyfVFIY7/BTrEv3UuKZRW752gLGRFNKcELjECuH+eQrwAYMckhFcgjv/3Osqx9JmYBSXPQKpjC8/sgnll1pS+M0yMSyifIq+Pws66mreSoreLpzvG5snZQnEdT+RPaIDM6yDA3Vkia3kN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771546970; c=relaxed/simple;
	bh=Iry+wOcZV9gTr8efjmYVyVLkL2DcBlVcd1tpKpwHtdM=;
	h=Date:To:From:Subject:Message-Id; b=umwLDQtWJgfuvpvU//MWmvPVIPdnZ6dPbPQZs/KKRsj6GN0fO8NwiWv6lUp1nwHWL2anzhWgWuJJR3qkWG7m48IKHPRzfndsi+QkIwAqljpufNv6WevlhsDyN/8CbdYMqC1RvnFuX4yyYxx+BOAxOvaSZwE44yTe2F+zRE9sovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nhPt8n8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nhPt8n8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E6C4CEF7;
	Fri, 20 Feb 2026 00:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771546970;
	bh=Iry+wOcZV9gTr8efjmYVyVLkL2DcBlVcd1tpKpwHtdM=;
	h=Date:To:From:Subject:From;
	b=nhPt8n8qjnHMwd4xfYEHVLyaP63AcGtS4d9IQbKGwl/GtRTL0nC2773UvngApfyfU
	 EBrfnPKvnYwxNsWHvadODhMqgW7coIeh023btLQxjPXUH0X6vYN6FG3DwRchxl8oT4
	 BBssiPJxS/KYg6v4k9D6QXi8Vck9u3vCdLyXfDxc=
Date: Thu, 19 Feb 2026 16:22:49 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,minchan@kernel.org,lorenzo.stoakes@oracle.com,joel@joelfernandes.org,david@kernel.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch added to mm-new branch
Message-Id: <20260220002250.345E6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/tracing: rss_stat: ensure curr is false from kthread context
has been added to the -mm mm-new branch.  Its filename is
     mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
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

mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch

