From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:19:48 -0700
Message-ID: <53432484.RAHLoFYF7lej+AtD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbaDGWTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, dchinner@redhat.com, cl@linux.com, akpm@linux-foundation.org

Subject: [folded-merged] vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,cl@linux.com,dchinner@redhat.com,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:19:48 -0700


The patch titled
     Subject: vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix
has been removed from the -mm tree.  Its filename was
     vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch

This patch was dropped because it was folded into vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix

Add comment.  Again.

Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix
+++ a/include/linux/vmstat.h
@@ -27,6 +27,10 @@ struct vm_event_state {
 
 DECLARE_PER_CPU(struct vm_event_state, vm_event_states);
 
+/*
+ * vm counters are allowed to be racy. Use raw_cpu_ops to avoid the
+ * local_irq_disable overhead.
+ */
 static inline void __count_vm_event(enum vm_event_item item)
 {
 	raw_cpu_inc(vm_event_states.event[item]);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

