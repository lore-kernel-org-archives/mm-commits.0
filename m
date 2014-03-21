From: akpm@linux-foundation.org
Subject: +
 vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
 added to -mm tree
Date: Fri, 21 Mar 2014 14:06:00 -0700
Message-ID: <532ca9b8.r3c004pJRwJJk/wi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaCUVGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 17:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, dchinner@redhat.com, cl@linux.com

Subject: + vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch added to -mm tree
To: cl@linux.com,dchinner@redhat.com,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 14:06:00 -0700


The patch titled
     Subject: vmstat: use raw_cpu_ops to avoid false positives on preemption checks
has been added to the -mm tree.  Its filename is
     vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat: use raw_cpu_ops to avoid false positives on preemption checks

vm counters are allowed to be racy.  Use raw_cpu_ops to avoid the
local_irq_disable overhead and to avoid preemption checks.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks
+++ a/include/linux/vmstat.h
@@ -29,7 +29,7 @@ DECLARE_PER_CPU(struct vm_event_state, v
 
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__this_cpu_inc(vm_event_states.event[item]);
+	raw_cpu_inc(vm_event_states.event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
@@ -39,7 +39,7 @@ static inline void count_vm_event(enum v
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__this_cpu_add(vm_event_states.event[item], delta);
+	raw_cpu_add(vm_event_states.event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
_

Patches currently in -mm which might be from cl@linux.com are

slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

