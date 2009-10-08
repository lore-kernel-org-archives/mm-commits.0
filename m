From: akpm@linux-foundation.org
Subject: + connector-fix-regression-introduced-by-sid-connector.patch added to -mm tree
Date: Thu, 08 Oct 2009 15:59:09 -0700
Message-ID: <200910082259.n98MxAt6004269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbZJHXBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 19:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borntraeger@de.ibm.com, davem@davemloft.net, matthltc@us.ibm.com, oleg@redhat.com, scott@ubuntu.com, zbr@ioremap.net


The patch titled
     connector: fix regression introduced by sid connector
has been added to the -mm tree.  Its filename is
     connector-fix-regression-introduced-by-sid-connector.patch

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
__set_special_pids to sys_setsid.

We also agreed that it is sufficient to change the check from
task_session(curr) != pid into err > 0, since if we don't change the
session, this means we were already the leader and return -EPERM.

One last thing:
There is also daemonize(), and some people might want to get a
notification in that case. Since daemonize() is only needed if a user
space does kernel_thread this does not look important (and there seems
to be no consensus if this connector should be called in daemonize). If
we really want this, we can add proc_sid_connector to daemonize() in an
additional patch (Scott?)

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Scott James Remnant <scott@ubuntu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
+		proc_sid_connector(group_leader);
 	return err;
 }
 
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

origin.patch
linux-next.patch
connector-fix-regression-introduced-by-sid-connector.patch

