From: akpm@linux-foundation.org
Subject: [merged]
 oom-trace-remove-enum-evaluation-of-compaction_feedback.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:23:34 -0700
Message-ID: <20170711192334.y0lteHBlu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933694AbdGKTXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com, rostedt@goodmis.org, vbabka@suse.cz


The patch titled
     Subject: oom, trace: remove ENUM evaluation of COMPACTION_FEEDBACK
has been removed from the -mm tree.  Its filename was
     oom-trace-remove-enum-evaluation-of-compaction_feedback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Rostedt (VMware) <rostedt@goodmis.org>
Subject: oom, trace: remove ENUM evaluation of COMPACTION_FEEDBACK

After enabling CONFIG_TRACE_ENUM_MAP_FILE (which will soon be renamed to
CONFIG_TRACE_EVAL_MAP_FILE), I am able to examine the enums that have been
evaluated:

 # cat /sys/kernel/debug/tracing/enum_map

(which will soon be renamed to eval_map)

And it showed some interesting results:

[..]
ZONE_MOVABLE 3 (oom)
ZONE_NORMAL 2 (oom)
ZONE_DMA32 1 (oom)
ZONE_DMA 0 (oom)
3 3 (oom)
2 2 (oom)
1 1 (oom)
COMPACT_PRIO_ASYNC 2 (oom)
COMPACT_PRIO_SYNC_LIGHT 1 (oom)
COMPACT_PRIO_SYNC_FULL 0 (oom)
[..]
ZONE_DMA 0 (vmscan)
3 3 (vmscan)
2 2 (vmscan)
1 1 (vmscan)
COMPACT_PRIO_ASYNC 2 (vmscan)
[..]
ZONE_DMA 0 (kmem)
3 3 (kmem)
2 2 (kmem)
1 1 (kmem)
COMPACT_PRIO_ASYNC 2 (kmem)
[..]
ZONE_DMA 0 (compaction)
3 3 (compaction)
2 2 (compaction)
1 1 (compaction)
COMPACT_PRIO_ASYNC 2 (compaction)
[..]

The name within the parenthesis are the trace systems that the enum/eval
maps are associated with.  When there's a number evaluated to another
number, that tells me that the TRACE_DEFINE_ENUM() was used on a #define
and not an enum.  As #defines get converted normally, they are not needed
to be evaluated.

Each of the above trace systems with the number to number evaluation
included the file include/trace/events/mmflags.h which has:

 /* High-level compaction status feedback */
 #define COMPACTION_FAILED       1
 #define COMPACTION_WITHDRAWN    2
 #define COMPACTION_PROGRESS     3

[..]

 #define COMPACTION_FEEDBACK             \
        EM(COMPACTION_FAILED,           "failed")       \
        EM(COMPACTION_WITHDRAWN,        "withdrawn")    \
        EMe(COMPACTION_PROGRESS,        "progress")

Which is still needed for the __print_symbolic() usage in the
trace_event. But it is not needed to be evaluated.

Removing the evaluation part removes the unnecessary evaluations of
numbers to numbers.

Link: http://lkml.kernel.org/r/20170615074944.7be9a647@gandalf.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/mmflags.h~oom-trace-remove-enum-evaluation-of-compaction_feedback include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~oom-trace-remove-enum-evaluation-of-compaction_feedback
+++ a/include/trace/events/mmflags.h
@@ -257,7 +257,7 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 
 COMPACTION_STATUS
 COMPACTION_PRIORITY
-COMPACTION_FEEDBACK
+/* COMPACTION_FEEDBACK are defines not enums. Not needed here. */
 ZONE_TYPE
 LRU_NAMES
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are


