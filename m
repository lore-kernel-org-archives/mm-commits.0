From: akpm@linux-foundation.org
Subject: +
 ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch
 added to -mm tree
Date: Sat, 28 Mar 2020 13:01:59 -0700
Message-ID: <20200328200159.SxtizPJfo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgC1UCA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 16:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix
has been added to the -mm tree.  Its filename is
     ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix

s/PIDTYPE_PID/PIDTYPE_TGID/, per Eric

Link: http://lkml.kernel.org/r/20200327195643.GA9366@redhat.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/mqueue.c~ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix
+++ a/ipc/mqueue.c
@@ -801,7 +801,7 @@ static void __do_notify(struct mqueue_in
 			 * bypass check_kill_permission(). It is from kernel
 			 * but si_fromuser() can't know this.
 			 */
-			task = pid_task(info->notify_owner, PIDTYPE_PID);
+			task = pid_task(info->notify_owner, PIDTYPE_TGID);
 			if (task)
 				do_send_sig_info(info->notify.sigev_signo,
 						&sig_i, task, PIDTYPE_TGID);
_

Patches currently in -mm which might be from oleg@redhat.com are

ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch
ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch
aio-simplify-read_events.patch
