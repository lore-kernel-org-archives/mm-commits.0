From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch
 removed from -mm tree
Date: Wed, 01 Apr 2020 14:04:33 -0700
Message-ID: <20200401210433.v7INQ1nqS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbgDAVEf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 17:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-fix.patch

This patch was dropped because it was folded into ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission.patch

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
ipc-mqueuec-change-__do_notify-to-bypass-check_kill_permission-v2.patch
aio-simplify-read_events.patch
