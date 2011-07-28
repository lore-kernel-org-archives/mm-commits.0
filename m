From: akpm@linux-foundation.org
Subject: + taskstats-add_del_listener-should-ignore-valid-listeners.patch added to -mm tree
Date: Thu, 28 Jul 2011 14:50:05 -0700
Message-ID: <201107282150.p6SLo5EH010501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab1G1VvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 17:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, bsingharora@gmail.com, jmarchan@redhat.com, segoon@openwall.com


The patch titled
     taskstats: add_del_listener() should ignore !valid listeners
has been added to the -mm tree.  Its filename is
     taskstats-add_del_listener-should-ignore-valid-listeners.patch

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
Subject: taskstats: add_del_listener() should ignore !valid listeners
From: Oleg Nesterov <oleg@redhat.com>

When send_cpu_listeners() finds the orphaned listener it marks it as
!valid and drops listeners->sem.  Before it takes this sem for writing,
s->pid can be reused and add_del_listener() can wrongly try to re-use this
entry.

Change add_del_listener() to check ->valid = T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/taskstats.c~taskstats-add_del_listener-should-ignore-valid-listeners kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add_del_listener-should-ignore-valid-listeners
+++ a/kernel/taskstats.c
@@ -304,7 +304,7 @@ static int add_del_listener(pid_t pid, c
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
 			list_for_each_entry(s2, &listeners->list, list) {
-				if (s2->pid == pid)
+				if (s2->pid == pid && s2->valid)
 					goto exists;
 			}
 			list_add(&s->list, &listeners->list);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch
taskstats-add_del_listener-should-ignore-valid-listeners.patch

