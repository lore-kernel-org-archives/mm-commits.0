From: akpm@linux-foundation.org
Subject: [nacked] coredump-use-get_task_comm-for-%e-filename-format.patch removed from -mm tree
Date: Fri, 27 May 2011 12:54:07 -0700
Message-ID: <201105271952.p4RJqD4v017202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1E0Twq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     coredump: use get_task_comm() for %e filename format
has been removed from the -mm tree.  Its filename was
     coredump-use-get_task_comm-for-%e-filename-format.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: use get_task_comm() for %e filename format
From: Jiri Slaby <jslaby@suse.cz>

We currently access current->comm directly.  As we have
prctl(PR_SET_NAME), we need the access be protected by task_lock.  This is
exactly what get_task_comm does, so use it.

I'm not 100% convinced prctl(PR_SET_NAME) may be called at the time of
core dump, but the locking won't hurt.  Note that siglock is not held in
format_corename.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-use-get_task_comm-for-%e-filename-format fs/exec.c
--- a/fs/exec.c~coredump-use-get_task_comm-for-%e-filename-format
+++ a/fs/exec.c
@@ -1726,9 +1726,12 @@ static int format_corename(struct core_n
 				up_read(&uts_sem);
 				break;
 			/* executable */
-			case 'e':
-				err = cn_printf(cn, "%s", current->comm);
+			case 'e': {
+				char comm[TASK_COMM_LEN];
+				err = cn_printf(cn, "%s",
+						get_task_comm(comm, current));
 				break;
+			}
 			case 'E':
 				err = cn_print_exe_file(cn);
 				break;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

