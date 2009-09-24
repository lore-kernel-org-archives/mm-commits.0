From: akpm@linux-foundation.org
Subject: [merged] signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:48 -0700
Message-ID: <200909241935.n8OJZmkp001177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbZIXTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, a.p.zijlstra@chello.nl, eranian@googlemail.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_sigio: use do_send_sig_info() to avoid check_kill_permission()
has been removed from the -mm tree.  Its filename was
     signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_sigio: use do_send_sig_info() to avoid check_kill_permission()
From: Oleg Nesterov <oleg@redhat.com>

group_send_sig_info()->check_kill_permission() assumes that current is the
sender and uses current_cred().

This is not true in send_sigio_to_task() case.  From the security pov the
sender is not current, but the task which did fcntl(F_SETOWN), that is why
we have sigio_perm() which uses the right creds to check.

Fortunately, send_sigio() always sends either SEND_SIG_PRIV or
SI_FROMKERNEL() signal, so check_kill_permission() does nothing.  But
still it would be tidier to avoid this bogus security check and save a
couple of cycles.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission fs/fcntl.c
--- a/fs/fcntl.c~signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission
+++ a/fs/fcntl.c
@@ -461,11 +461,11 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!group_send_sig_info(signum, &si, p))
+			if (!do_send_sig_info(signum, &si, p, true))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
+			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, true);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

