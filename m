From: akpm@linux-foundation.org
Subject: [merged]
 vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:48:17 -0700
Message-ID: <53446ea1.CpqxSr5H+RWnj5QF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbaDHVsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, dchinner@redhat.com, cl@linux.com

Subject: [merged] vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch removed from -mm tree
To: cl@linux.com,dchinner@redhat.com,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:48:17 -0700


The patch titled
     Subject: vmstat: use raw_cpu_ops to avoid false positives on preemption checks
has been removed from the -mm tree.  Its filename was
     vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat: use raw_cpu_ops to avoid false positives on preemption checks

vm counters are allowed to be racy.  Use raw_cpu_ops to avoid the
local_irq_disable overhead and to avoid preemption checks which will be
added to the __this_cpu operations.

[akpm@linux-foundation.org: Add comment.  Again.]
Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks
+++ a/include/linux/vmstat.h
@@ -27,9 +27,13 @@ struct vm_event_state {
 
 DECLARE_PER_CPU(struct vm_event_state, vm_event_states);
 
+/*
+ * vm counters are allowed to be racy. Use raw_cpu_ops to avoid the
+ * local_irq_disable overhead.
+ */
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__this_cpu_inc(vm_event_states.event[item]);
+	raw_cpu_inc(vm_event_states.event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
@@ -39,7 +43,7 @@ static inline void count_vm_event(enum v
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__this_cpu_add(vm_event_states.event[item], delta);
+	raw_cpu_add(vm_event_states.event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

