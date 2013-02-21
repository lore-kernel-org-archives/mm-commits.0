From: akpm@linux-foundation.org
Subject: [withdrawn] vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:49:35 -0800
Message-ID: <20130221234936.69FDB31C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40337 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3BUXth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:49:37 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so12913qcr.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:49:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
has been removed from the -mm tree.  Its filename was
     vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: vfork: don't freezer_count() for in-kernel users of CLONE_VFORK

We don't need to call freezer_do_not_count() for in-kernel users of
CLONE_VFORK since exec will get called in bounded time.

We don't want to call freezer_count() for in-kernel users because they may
be holding locks.  freezer_count() calls try_to_freeze().  We don't want
to freeze an in-kernel user because it may be holding locks.

In a follow-up patch, I call debug_check_no_locks_held() from
try_to_freeze().  After applying this patch, I get no lockdep warnings
with that patch.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork kernel/fork.c
--- a/kernel/fork.c~vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork
+++ a/kernel/fork.c
@@ -718,9 +718,11 @@ static int wait_for_vfork_done(struct ta
 {
 	int killed;
 
-	freezer_do_not_count();
+	if (current->mm)
+		freezer_do_not_count();
 	killed = wait_for_completion_killable(vfork);
-	freezer_count();
+	if (current->mm)
+		freezer_count();
 
 	if (killed) {
 		task_lock(child);
_

Patches currently in -mm which might be from msb@chromium.org are

coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-v2.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

