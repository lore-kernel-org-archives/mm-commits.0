From: akpm@linux-foundation.org
Subject: [merged] taskstats-add_del_listener-should-ignore-valid-listeners.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:31 -0700
Message-ID: <201108161847.p7GIlcWq015114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925Ab1HPSyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bsingharora@gmail.com, jmarchan@redhat.com, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: add_del_listener() should ignore !valid listeners
has been removed from the -mm tree.  Its filename was
     taskstats-add_del_listener-should-ignore-valid-listeners.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

ipc-introduce-shm_rmid_forced-sysctl-testing.patch

