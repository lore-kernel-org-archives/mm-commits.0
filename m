From: akpm@linux-foundation.org
Subject: - signals-check_kill_permission-remove-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:05 -0700
Message-ID: <200805010927.m419R5lk030367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880AbYEAJlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: check_kill_permission: remove tasklist_lock
has been removed from the -mm tree.  Its filename was
     signals-check_kill_permission-remove-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: check_kill_permission: remove tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that task_session() can't return a false NULL, check_kill_permission()
doesn't need tasklist_lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/signal.c~signals-check_kill_permission-remove-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-check_kill_permission-remove-tasklist_lock
+++ a/kernel/signal.c
@@ -551,9 +551,7 @@ static int check_kill_permission(int sig
 	    !capable(CAP_KILL)) {
 		switch (sig) {
 		case SIGCONT:
-			read_lock(&tasklist_lock);
 			sid = task_session(t);
-			read_unlock(&tasklist_lock);
 			/*
 			 * We don't return the error if sid == NULL. The
 			 * task was unhashed, the caller must notice this.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

