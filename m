From: akpm@linux-foundation.org
Subject: + selinux-fix-sel_netnode_insert-suspicious-rcu-dereference.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:57:13 -0700
Message-ID: <20120815235713.D95A9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33019 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2HOX5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:57:15 -0400
Received: by obbwc20 with SMTP id wc20so1554369obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:57:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, eparis@parisplace.org, jmorris@namei.org, paul@paul-moore.com, paulmck@linux.vnet.ibm.com


The patch titled
     Subject: selinux: fix sel_netnode_insert() suspicious rcu dereference
has been added to the -mm tree.  Its filename is
     selinux-fix-sel_netnode_insert-suspicious-rcu-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: selinux: fix sel_netnode_insert() suspicious rcu dereference

===============================
[ INFO: suspicious RCU usage. ]
3.5.0-rc1+ #63 Not tainted
-------------------------------
security/selinux/netnode.c:178 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by trinity-child1/8750:
 #0:  (sel_netnode_lock){+.....}, at: [<ffffffff812d8f8a>] sel_netnode_sid+0x16a/0x3e0

stack backtrace:
Pid: 8750, comm: trinity-child1 Not tainted 3.5.0-rc1+ #63
Call Trace:
 [<ffffffff810cec2d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff812d91d1>] sel_netnode_sid+0x3b1/0x3e0
 [<ffffffff812d8e20>] ? sel_netnode_find+0x1a0/0x1a0
 [<ffffffff812d24a6>] selinux_socket_bind+0xf6/0x2c0
 [<ffffffff810cd1dd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810cdb55>] ? lock_release_holdtime.part.9+0x15/0x1a0
 [<ffffffff81093841>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff812c9536>] security_socket_bind+0x16/0x20
 [<ffffffff815550ca>] sys_bind+0x7a/0x100
 [<ffffffff816c03d5>] ? sysret_check+0x22/0x5d
 [<ffffffff810d392d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [<ffffffff8133b09e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816c03a9>] system_call_fastpath+0x16/0x1b

This patch below does what Paul McKenney suggested in the previous thread.

Signed-off-by: Dave Jones <davej@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/netnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN security/selinux/netnode.c~selinux-fix-sel_netnode_insert-suspicious-rcu-dereference security/selinux/netnode.c
--- a/security/selinux/netnode.c~selinux-fix-sel_netnode_insert-suspicious-rcu-dereference
+++ a/security/selinux/netnode.c
@@ -174,7 +174,8 @@ static void sel_netnode_insert(struct se
 	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
 		struct sel_netnode *tail;
 		tail = list_entry(
-			rcu_dereference(sel_netnode_hash[idx].list.prev),
+			rcu_dereference_protected(sel_netnode_hash[idx].list.prev,
+						  lockdep_is_held(&sel_netnode_lock)),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
 		kfree_rcu(tail, rcu);
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
selinux-fix-sel_netnode_insert-suspicious-rcu-dereference.patch

