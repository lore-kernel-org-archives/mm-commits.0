From: akpm@linux-foundation.org
Subject: + file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:32:30 -0700
Message-ID: <20071101193230.74BB2432BDC@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:34075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXKATd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@epoch.ncsc.mil


The patch titled
     file capabilities: remove the non-matching uid special case for kill
has been added to the -mm tree.  Its filename is
     file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: remove the non-matching uid special case for kill
From: "Serge E. Hallyn" <serue@us.ibm.com>

There I went again having one patch do two (related) things.

Remove the special check I had added to cap_task_kill() for
non-matching uids.  In fact it turns out the check wouldn't be
safe even if I'd coded it correctly.  A binary can be setuid
and owned by a non-root user user1, have file capabilities, and
be executed by user2.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Stephen Smalley <sds@epoch.ncsc.mil>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill security/commoncap.c
--- a/security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill
+++ a/security/commoncap.c
@@ -526,11 +526,6 @@ int cap_task_kill(struct task_struct *p,
 	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
 		return 0;
 
-	/* if tasks have same uid, then check_kill_permission did check */
-	if (current->uid == p->uid || current->euid == p->uid ||
-		current->uid == p->suid || current->euid == p->suid)
-		return 0;
-
 	/* sigcont is permitted within same session */
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-unionfs.patch
file-capabilities-allow-sigcont-within-session-v2.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill.patch
