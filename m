From: akpm@linux-foundation.org
Subject: + taskstats-dont-allow-duplicate-entries-in-listener-mode.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:49:07 -0700
Message-ID: <201106212249.p5LMn7Am029428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756257Ab1FUWuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, bsingharora@gmail.com, segooon@gmail.com, stable@kernel.org


The patch titled
     taskstats: don't allow duplicate entries in listener mode
has been added to the -mm tree.  Its filename is
     taskstats-dont-allow-duplicate-entries-in-listener-mode.patch

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
Subject: taskstats: don't allow duplicate entries in listener mode
From: Vasiliy Kulikov <segoon@openwall.com>

Currently a single process may register exit handlers unlimited times.  It
may lead to a bloated listeners chain and very slow process terminations. 
E.g.  after 10KK sent TASKSTATS_CMD_ATTR_REGISTER_CPUMASKs ~300 Mb of
kernel memory is stolen for the handlers chain and "time id" shows 2-7
seconds instead of normal 0.003.  It makes it possible to exhaust all
kernel memory and to eat much of CPU time by triggerring numerous exits on
a single CPU.

The patch limits the number of times a single process may register itself
on a single CPU to one.

One little issue is kept unfixed - as taskstats_exit() is called before
exit_files() in do_exit(), the orphaned listener entry (if it was not
explicitly deregistered) is kept until the next someone's exit() and
implicit deregistration in send_cpu_listeners().  So, if a process
registered itself as a listener exits and the next spawned process gets
the same pid, it would inherit taskstats attributes.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN kernel/taskstats.c~taskstats-dont-allow-duplicate-entries-in-listener-mode kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-dont-allow-duplicate-entries-in-listener-mode
+++ a/kernel/taskstats.c
@@ -285,16 +285,18 @@ ret:
 static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 {
 	struct listener_list *listeners;
-	struct listener *s, *tmp;
+	struct listener *s, *tmp, *s2;
 	unsigned int cpu;
 
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
+	s = NULL;
 	if (isadd == REGISTER) {
 		for_each_cpu(cpu, mask) {
-			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
-					 cpu_to_node(cpu));
+			if (!s)
+				s = kmalloc_node(sizeof(struct listener),
+						 GFP_KERNEL, cpu_to_node(cpu));
 			if (!s)
 				goto cleanup;
 			s->pid = pid;
@@ -303,9 +305,16 @@ static int add_del_listener(pid_t pid, c
 
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
+			list_for_each_entry_safe(s2, tmp, &listeners->list, list) {
+				if (s2->pid == pid)
+					goto next_cpu;
+			}
 			list_add(&s->list, &listeners->list);
+			s = NULL;
+next_cpu:
 			up_write(&listeners->sem);
 		}
+		kfree(s);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from segoon@openwall.com are

taskstats-dont-allow-duplicate-entries-in-listener-mode.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

