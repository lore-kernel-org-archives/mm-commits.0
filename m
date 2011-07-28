From: akpm@linux-foundation.org
Subject: + taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch added to -mm tree
Date: Thu, 28 Jul 2011 14:50:03 -0700
Message-ID: <201107282150.p6SLo300010493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab1G1Vuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 17:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, bsingharora@gmail.com, jmarchan@redhat.com, segoon@openwall.com


The patch titled
     taskstats: add_del_listener() shouldn't use the wrong node
has been added to the -mm tree.  Its filename is
     taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch
taskstats-add_del_listener-should-ignore-valid-listeners.patch

