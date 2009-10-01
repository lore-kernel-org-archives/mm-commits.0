From: akpm@linux-foundation.org
Subject: [failures] connector-fix-regression-introduced-by-sid-connector.patch removed from -mm tree
Date: Thu, 01 Oct 2009 13:52:00 -0700
Message-ID: <200910012114.n91LEctE022786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbZJAVOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 17:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, davem@davemloft.net, matthltc@us.ibm.com, oleg@redhat.com, scott@ubuntu.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     connector: fix regression introduced by sid connector
has been removed from the -mm tree.  Its filename was
     connector-fix-regression-introduced-by-sid-connector.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: connector: fix regression introduced by sid connector
From: Christian Borntraeger <borntraeger@de.ibm.com>

Since commit 02b51df1b07b4e9ca823c89284e704cadb323cd1 (proc connector: add
event for process becoming session leader) we have the following warning:

Badness at kernel/softirq.c:143
[...]
Krnl PSW : 0404c00180000000 00000000001481d4 (local_bh_enable+0xb0/0xe0)
[...]
Call Trace:
([<000000013fe04100>] 0x13fe04100)
 [<000000000048a946>] sk_filter+0x9a/0xd0
 [<000000000049d938>] netlink_broadcast+0x2c0/0x53c
 [<00000000003ba9ae>] cn_netlink_send+0x272/0x2b0
 [<00000000003baef0>] proc_sid_connector+0xc4/0xd4
 [<0000000000142604>] __set_special_pids+0x58/0x90
 [<0000000000159938>] sys_setsid+0xb4/0xd8
 [<00000000001187fe>] sysc_noemu+0x10/0x16
 [<00000041616cb266>] 0x41616cb266

The warning is
--->    WARN_ON_ONCE(in_irq() || irqs_disabled());

The network code must not be called with disabled interrupts but
sys_setsid holds the tasklist_lock with spinlock_irq while calling the
connector.

After a discussion we agreed that we can move proc_sid_connector from
__set_special_pids to sys_setsid.  We also agreed that it is sufficient to
change the check from task_session(curr) != pid into err > 0, since if we
don't change the session, this means we were already the leader and return
-EPERM.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Scott James Remnant <scott@ubuntu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +---
 kernel/sys.c  |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~connector-fix-regression-introduced-by-sid-connector kernel/exit.c
--- a/kernel/exit.c~connector-fix-regression-introduced-by-sid-connector
+++ a/kernel/exit.c
@@ -359,10 +359,8 @@ void __set_special_pids(struct pid *pid)
 {
 	struct task_struct *curr = current->group_leader;
 
-	if (task_session(curr) != pid) {
+	if (task_session(curr) != pid)
 		change_pid(curr, PIDTYPE_SID, pid);
-		proc_sid_connector(curr);
-	}
 
 	if (task_pgrp(curr) != pid)
 		change_pid(curr, PIDTYPE_PGID, pid);
diff -puN kernel/sys.c~connector-fix-regression-introduced-by-sid-connector kernel/sys.c
--- a/kernel/sys.c~connector-fix-regression-introduced-by-sid-connector
+++ a/kernel/sys.c
@@ -1110,6 +1110,8 @@ SYSCALL_DEFINE0(setsid)
 	err = session;
 out:
 	write_unlock_irq(&tasklist_lock);
+	if (err > 0)
+		proc_sid_connector(sid);
 	return err;
 }
 
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

connector-fix-regression-introduced-by-sid-connector.patch
linux-next.patch

