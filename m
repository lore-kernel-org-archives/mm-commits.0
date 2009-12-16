From: akpm@linux-foundation.org
Subject: [merged] signals-cosmetic-collect_signal-use-si_user.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:21 -0800
Message-ID: <200912162038.nBGKcLvw013417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964940AbZLPUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     signals: cosmetic, collect_signal: use SI_USER
has been removed from the -mm tree.  Its filename was
     signals-cosmetic-collect_signal-use-si_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: cosmetic, collect_signal: use SI_USER
From: Oleg Nesterov <oleg@redhat.com>

Trivial, s/0/SI_USER/ in collect_signal() for grep.

This is a bit confusing, we don't know the source of this signal.
But we don't care, and "info->si_code = 0" is imho worse.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-cosmetic-collect_signal-use-si_user kernel/signal.c
--- a/kernel/signal.c~signals-cosmetic-collect_signal-use-si_user
+++ a/kernel/signal.c
@@ -423,7 +423,7 @@ still_pending:
 		 */
 		info->si_signo = sig;
 		info->si_errno = 0;
-		info->si_code = 0;
+		info->si_code = SI_USER;
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

