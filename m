From: akpm@linux-foundation.org
Subject: - ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:39 -0700
Message-ID: <200705021933.l42JXdEa028273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766637AbXEBTeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, clameter@sgi.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     ia64-sn-xpc-convert-to-use-kthread-api-fix 2
has been removed from the -mm tree.  Its filename was
     ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ia64-sn-xpc-convert-to-use-kthread-api-fix 2
From: Dean Nelson <dcn@sgi.com>

I've tested Eric's patch in conjunction with a fix from Christoph Lameter,
which you've already got (it cleaned up a couple of compiler errors), and
the following patch that I'd like added (it cleans up a couple of compiler
warning errors and makes a few cosmetic changes).

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpc_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api-fix-2 arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api-fix-2
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -568,7 +568,6 @@ xpc_activate_partition(struct xpc_partit
 
 	task = kthread_run(xpc_activating, (void *) ((u64) partid),
 			  "xpc%02d", partid);
-
 	if (unlikely(IS_ERR(task))) {
 		spin_lock_irqsave(&part->act_lock, irq_flags);
 		part->act_state = XPC_P_INACTIVE;
@@ -808,7 +807,6 @@ xpc_create_kthreads(struct xpc_channel *
 			int ignore_disconnecting)
 {
 	unsigned long irq_flags;
-	pid_t pid;
 	u64 args = XPC_PACK_ARGS(ch->partid, ch->number);
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	struct task_struct *task;
@@ -840,7 +838,7 @@ xpc_create_kthreads(struct xpc_channel *
 		(void) xpc_part_ref(part);
 		xpc_msgqueue_ref(ch);
 
-		task = kthread_run(xpc_daemonize_kthread, args,
+		task = kthread_run(xpc_daemonize_kthread, (void *) args,
 				   "xpc%02dc%d", ch->partid, ch->number);
 		if (IS_ERR(task)) {
 			/* the fork failed */
@@ -1381,7 +1379,8 @@ xpc_init(void)
 	 * activate based on info provided by SAL. This new thread is short
 	 * lived and will exit once discovery is complete.
 	 */
-	task = kthread_run(xpc_initiate_discovery, NULL, XPC_DISCOVERY_THREAD_NAME);
+	task = kthread_run(xpc_initiate_discovery, NULL,
+			   XPC_DISCOVERY_THREAD_NAME);
 	if (IS_ERR(task)) {
 		dev_err(xpc_part, "failed while forking discovery thread\n");
 
_

Patches currently in -mm which might be from dcn@sgi.com are

ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
