From: akpm@linux-foundation.org
Subject: + audit-do-not-send-uninitialized-data-for-audit_tty_get.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:15:11 -0700
Message-ID: <201009072215.o87MFB3b009491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0IGWQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, eparis@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     audit: do not send uninitialized data for AUDIT_TTY_GET
has been added to the -mm tree.  Its filename is
     audit-do-not-send-uninitialized-data-for-audit_tty_get.patch

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
Subject: audit: do not send uninitialized data for AUDIT_TTY_GET
From: Thomas Gleixner <tglx@linutronix.de>

audit_receive_msg() sends uninitialized data for AUDIT_TTY_GET when the
task was not found.

Send reply only when task was found.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/audit.c~audit-do-not-send-uninitialized-data-for-audit_tty_get kernel/audit.c
--- a/kernel/audit.c~audit-do-not-send-uninitialized-data-for-audit_tty_get
+++ a/kernel/audit.c
@@ -884,8 +884,10 @@ static int audit_receive_msg(struct sk_b
 			spin_unlock_irq(&tsk->sighand->siglock);
 		}
 		read_unlock(&tasklist_lock);
-		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
-				 &s, sizeof(s));
+
+		if (!err)
+			audit_send_reply(NETLINK_CB(skb).pid, seq,
+					 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
audit-call-tty_audit_push_task-outside-preempt-disabled.patch
audit-do-not-send-uninitialized-data-for-audit_tty_get.patch
audit-use-rcu-for-task-lookup-protection.patch
time-compensate-for-rounding-on-odd-frequency-clocksources.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch
hpet-factor-timer-allocate-from-open.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
timer-initialize-the-field-slack-of-timer_list.patch
kernel-time-use-array_size-macro-in-timecomparec.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
epoll-make-epoll_wait-use-the-hrtimer-range-feature.patch

