From: akpm@osdl.org
Subject: - add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:52:25 -0800
Message-ID: <200612080852.kB88qP5w013997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37289 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425212AbWLHIwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-process_session-helper-routine-deprecate-old-field-fix-warnings fix
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch

This patch was dropped because it was folded into add-process_session-helper-routine-deprecate-old-field.patch

------------------------------------------------------
Subject: add-process_session-helper-routine-deprecate-old-field-fix-warnings fix
From: Jeff Dike <jdike@addtoit.com>

add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
in -mm causes UML to hang at shutdown - init is sitting in a select on the
initctl socket.

This patch fixes it for me.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix fs/proc/array.c
--- a/fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix
+++ a/fs/proc/array.c
@@ -381,7 +381,7 @@ static int do_task_stat(struct task_stru
 			stime = cputime_add(stime, sig->stime);
 		}
 
-		signal_session(sig);
+		sid = signal_session(sig);
 		pgid = process_group(task);
 		ppid = rcu_dereference(task->real_parent)->tgid;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch
tty-switch-to-ktermios-uml-fix.patch

