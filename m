From: akpm@linux-foundation.org
Subject: [merged]
 tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:33 -0800
Message-ID: <54e25021.UVbvq76oR4wWY1cC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbbBPUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mingo@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: tracing: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace.c     |    6 +++---
 kernel/trace/trace_seq.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/trace/trace.c~tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/trace/trace.c
--- a/kernel/trace/trace.c~tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/trace/trace.c
@@ -3353,12 +3353,12 @@ tracing_cpumask_read(struct file *filp,
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tr->tracing_cpumask);
-	if (count - len < 2) {
+	len = snprintf(mask_str, count, "%*pb\n",
+		       cpumask_pr_args(tr->tracing_cpumask));
+	if (len >= count) {
 		count = -EINVAL;
 		goto out_err;
 	}
-	len += sprintf(mask_str + len, "\n");
 	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, NR_CPUS+1);
 
 out_err:
diff -puN kernel/trace/trace_seq.c~tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/trace/trace_seq.c
--- a/kernel/trace/trace_seq.c~tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/trace/trace_seq.c
@@ -120,7 +120,7 @@ void trace_seq_bitmask(struct trace_seq
 
 	__trace_seq_init(s);
 
-	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
+	seq_buf_printf(&s->seq, "%*pb", nmaskbits, maskp);
 
 	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
 		s->seq.len = save_len;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

