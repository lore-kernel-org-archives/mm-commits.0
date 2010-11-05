From: akpm@linux-foundation.org
Subject: [merged] audit-use-rcu-for-task-lookup-protection.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:05 -0700
Message-ID: <201011051830.oA5IUldr025671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab0KESbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, eparis@redhat.com, oleg@redhat.com, peterz@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: use rcu for task lookup protection
has been removed from the -mm tree.  Its filename was
     audit-use-rcu-for-task-lookup-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: use rcu for task lookup protection
From: Thomas Gleixner <tglx@linutronix.de>

Protect the task lookups in audit_receive_msg() with rcu_read_lock()
instead of tasklist_lock and use lock/unlock_sighand to protect against
the exit race.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff -puN kernel/audit.c~audit-use-rcu-for-task-lookup-protection kernel/audit.c
--- a/kernel/audit.c~audit-use-rcu-for-task-lookup-protection
+++ a/kernel/audit.c
@@ -873,17 +873,16 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		struct task_struct *tsk;
+		unsigned long flags;
 
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
-		if (!tsk)
-			err = -ESRCH;
-		else {
-			spin_lock_irq(&tsk->sighand->siglock);
+		if (tsk && lock_task_sighand(tsk, &flags)) {
 			s.enabled = tsk->signal->audit_tty != 0;
-			spin_unlock_irq(&tsk->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+			unlock_task_sighand(tsk, &flags);
+		} else
+			err = -ESRCH;
+		rcu_read_unlock();
 
 		if (!err)
 			audit_send_reply(NETLINK_CB(skb).pid, seq,
@@ -893,22 +892,21 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_TTY_SET: {
 		struct audit_tty_status *s;
 		struct task_struct *tsk;
+		unsigned long flags;
 
 		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
 			return -EINVAL;
 		s = data;
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
-		if (!tsk)
-			err = -ESRCH;
-		else {
-			spin_lock_irq(&tsk->sighand->siglock);
+		if (tsk && lock_task_sighand(tsk, &flags)) {
 			tsk->signal->audit_tty = s->enabled != 0;
-			spin_unlock_irq(&tsk->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+			unlock_task_sighand(tsk, &flags);
+		} else
+			err = -ESRCH;
+		rcu_read_unlock();
 		break;
 	}
 	default:
_

Patches currently in -mm which might be from tglx@linutronix.de are

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

