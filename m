From: akpm@linux-foundation.org
Subject: [merged] taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:28 -0700
Message-ID: <201108161847.p7GIlZMd015104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1HPSyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bsingharora@gmail.com, jmarchan@redhat.com, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: add_del_listener() shouldn't use the wrong node
has been removed from the -mm tree.  Its filename was
     taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: add_del_listener() shouldn't use the wrong node
From: Oleg Nesterov <oleg@redhat.com>

1. 26c4caea "don't allow duplicate entries in listener mode"
   changed add_del_listener(REGISTER) so that "next_cpu:" can
   reuse the listener allocated for the previous cpu, this
   doesn't look exactly right even if minor.

   Change the code to kfree() in the already-registered case,
   this case is unlikely anyway so the extra kmalloc_node()
   shouldn't hurt but looke more correct and clean.

2. use the plain list_for_each_entry() instead of _safe() to
   scan listeners->list.

3. Remove the unneeded INIT_LIST_HEAD(&s->list), we are going
   to list_add(&s->list).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN kernel/taskstats.c~taskstats-add_del_listener-shouldnt-use-the-wrong-node kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add_del_listener-shouldnt-use-the-wrong-node
+++ a/kernel/taskstats.c
@@ -291,30 +291,28 @@ static int add_del_listener(pid_t pid, c
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
-	s = NULL;
 	if (isadd == REGISTER) {
 		for_each_cpu(cpu, mask) {
-			if (!s)
-				s = kmalloc_node(sizeof(struct listener),
-						 GFP_KERNEL, cpu_to_node(cpu));
+			s = kmalloc_node(sizeof(struct listener),
+					GFP_KERNEL, cpu_to_node(cpu));
 			if (!s)
 				goto cleanup;
+
 			s->pid = pid;
-			INIT_LIST_HEAD(&s->list);
 			s->valid = 1;
 
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
-			list_for_each_entry_safe(s2, tmp, &listeners->list, list) {
+			list_for_each_entry(s2, &listeners->list, list) {
 				if (s2->pid == pid)
-					goto next_cpu;
+					goto exists;
 			}
 			list_add(&s->list, &listeners->list);
 			s = NULL;
-next_cpu:
+exists:
 			up_write(&listeners->sem);
+			kfree(s); /* nop if NULL */
 		}
-		kfree(s);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

ipc-introduce-shm_rmid_forced-sysctl-testing.patch

