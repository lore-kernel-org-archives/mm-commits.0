From: akpm@linux-foundation.org
Subject: + vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:32:52 -0800
Message-ID: <20130215233253.4E04F5A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44047 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3BOXcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:32:54 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so389902qcr.2
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:32:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
has been added to the -mm tree.  Its filename is
     vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

