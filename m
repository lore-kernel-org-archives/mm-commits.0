From: akpm@linux-foundation.org
Subject: [merged] oprofile-remove-double-ring-buffering.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:01:43 -0400
Message-ID: <201004271803.o3RI3GdH010972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0D0SEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, robert.richter@amd.com, rostedt@goodmis.org, sodarock@gmail.com, stable@kernel.org, suravee.suthikulpanit@amd.com, tj@kernel.org, mm-commits@v


The patch titled
     oprofile: remove double ring buffering
has been removed from the -mm tree.  Its filename was
     oprofile-remove-double-ring-buffering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oprofile: remove double ring buffering
From: Andi Kleen <andi@firstfloor.org>

oprofile used a double buffer scheme for its cpu event buffer to avoid
races on reading with the old locked ring buffer.

But that is obsolete now with the new ring buffer, so simply use a single
buffer.  This greatly simplifies the code and avoids a lot of sample drops
on large runs, especially with call graph.

Based on suggestions from Steven Rostedt

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/cpu_buffer.c |   63 ++++++--------------------------
 1 file changed, 13 insertions(+), 50 deletions(-)

diff -puN drivers/oprofile/cpu_buffer.c~oprofile-remove-double-ring-buffering drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-remove-double-ring-buffering
+++ a/drivers/oprofile/cpu_buffer.c
@@ -30,23 +30,7 @@
 
 #define OP_BUFFER_FLAGS	0
 
-/*
- * Read and write access is using spin locking. Thus, writing to the
- * buffer by NMI handler (x86) could occur also during critical
- * sections when reading the buffer. To avoid this, there are 2
- * buffers for independent read and write access. Read access is in
- * process context only, write access only in the NMI handler. If the
- * read buffer runs empty, both buffers are swapped atomically. There
- * is potentially a small window during swapping where the buffers are
- * disabled and samples could be lost.
- *
- * Using 2 buffers is a little bit overhead, but the solution is clear
- * and does not require changes in the ring buffer implementation. It
- * can be changed to a single buffer solution when the ring buffer
- * access is implemented as non-locking atomic code.
- */
-static struct ring_buffer *op_ring_buffer_read;
-static struct ring_buffer *op_ring_buffer_write;
+static struct ring_buffer *op_ring_buffer;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -68,12 +52,9 @@ void oprofile_cpu_buffer_inc_smpl_lost(v
 
 void free_cpu_buffers(void)
 {
-	if (op_ring_buffer_read)
-		ring_buffer_free(op_ring_buffer_read);
-	op_ring_buffer_read = NULL;
-	if (op_ring_buffer_write)
-		ring_buffer_free(op_ring_buffer_write);
-	op_ring_buffer_write = NULL;
+	if (op_ring_buffer)
+		ring_buffer_free(op_ring_buffer);
+	op_ring_buffer = NULL;
 }
 
 #define RB_EVENT_HDR_SIZE 4
@@ -86,11 +67,8 @@ int alloc_cpu_buffers(void)
 	unsigned long byte_size = buffer_size * (sizeof(struct op_sample) +
 						 RB_EVENT_HDR_SIZE);
 
-	op_ring_buffer_read = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_read)
-		goto fail;
-	op_ring_buffer_write = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_write)
+	op_ring_buffer = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer)
 		goto fail;
 
 	for_each_possible_cpu(i) {
@@ -162,16 +140,11 @@ struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size)
 {
 	entry->event = ring_buffer_lock_reserve
-		(op_ring_buffer_write, sizeof(struct op_sample) +
+		(op_ring_buffer, sizeof(struct op_sample) +
 		 size * sizeof(entry->sample->data[0]));
-	if (entry->event)
-		entry->sample = ring_buffer_event_data(entry->event);
-	else
-		entry->sample = NULL;
-
-	if (!entry->sample)
+	if (!entry->event)
 		return NULL;
-
+	entry->sample = ring_buffer_event_data(entry->event);
 	entry->size = size;
 	entry->data = entry->sample->data;
 
@@ -180,25 +153,16 @@ struct op_sample
 
 int op_cpu_buffer_write_commit(struct op_entry *entry)
 {
-	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event);
+	return ring_buffer_unlock_commit(op_ring_buffer, entry->event);
 }
 
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
-	if (e)
-		goto event;
-	if (ring_buffer_swap_cpu(op_ring_buffer_read,
-				 op_ring_buffer_write,
-				 cpu))
+	e = ring_buffer_consume(op_ring_buffer, cpu, NULL, NULL);
+	if (!e)
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
-	if (e)
-		goto event;
-	return NULL;
 
-event:
 	entry->event = e;
 	entry->sample = ring_buffer_event_data(e);
 	entry->size = (ring_buffer_event_length(e) - sizeof(struct op_sample))
@@ -209,8 +173,7 @@ event:
 
 unsigned long op_cpu_buffer_entries(int cpu)
 {
-	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
-		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
+	return ring_buffer_entries_cpu(op_ring_buffer, cpu);
 }
 
 static int
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
modpost-support-objects-with-more-than-64k-sections.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch

