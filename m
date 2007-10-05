From: akpm@linux-foundation.org
Subject: + fix-bogus-reporting-of-signals-by-audit.patch added to -mm tree
Date: Fri, 05 Oct 2007 15:59:35 -0700
Message-ID: <200710052259.l95MxZm8029337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbXJEXAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, eparis@redhat.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     fix bogus reporting of signals by audit
has been added to the -mm tree.  Its filename is
     fix-bogus-reporting-of-signals-by-audit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix bogus reporting of signals by audit
From: Al Viro <viro@ftp.linux.org.uk>

Async signals should not be reported as sent by current in audit log.  As
it is, we call audit_signal_info() too early in check_kill_permission(). 
Note that check_kill_permission() has that test already - it needs to know
if it should apply current-based permission checks.  So the solution is to
move the call of audit_signal_info() between those.

Bogosity in question is easily reproduced - add a rule watching for e.g. 
kill(2) from specific process (so that audit_signal_info() would not
short-circuit to nothing), say load_policy, watch the bogus OBJ_PID entry
in audit logs claiming that write(2) on selinuxfs file issued by
load_policy(8) had somehow managed to send a signal to syslogd...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/signal.c~fix-bogus-reporting-of-signals-by-audit kernel/signal.c
--- a/kernel/signal.c~fix-bogus-reporting-of-signals-by-audit
+++ a/kernel/signal.c
@@ -531,18 +531,18 @@ static int check_kill_permission(int sig
 	if (!valid_signal(sig))
 		return error;
 
-	error = audit_signal_info(sig, t); /* Let audit system see the signal */
-	if (error)
-		return error;
-
-	error = -EPERM;
-	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && ((sig != SIGCONT) ||
-		(process_session(current) != process_session(t)))
-	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
-	    && !capable(CAP_KILL))
+	if (info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info))) {
+		error = audit_signal_info(sig, t); /* Let audit system see the signal */
+		if (error)
+			return error;
+		error = -EPERM;
+		if (((sig != SIGCONT) ||
+			(process_session(current) != process_session(t)))
+		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
+		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+		    && !capable(CAP_KILL))
 		return error;
+	}
 
 	return security_task_kill(t, info, sig, 0);
 }
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

fix-bogus-reporting-of-signals-by-audit.patch
git-kbuild.patch
git-net.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch
