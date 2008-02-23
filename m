From: akpm@linux-foundation.org
Subject: + file-capabilities-simplify-signal-check.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:28 -0800
Message-ID: <200802230729.m1N7TGtW017889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbYBWHaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, morgan@kernel.org, stable@kernel.org


The patch titled
     file capabilities: simplify signal check
has been added to the -mm tree.  Its filename is
     file-capabilities-simplify-signal-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: file capabilities: simplify signal check
From: "Serge E. Hallyn" <serue@us.ibm.com>

Simplify the uid equivalence check in cap_task_kill().  Anyone can kill a
process owned by the same uid.

Without this patch wireshark is reported to fail.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/commoncap.c~file-capabilities-simplify-signal-check security/commoncap.c
--- a/security/commoncap.c~file-capabilities-simplify-signal-check
+++ a/security/commoncap.c
@@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p,
 	 * allowed.
 	 * We must preserve legacy signal behavior in this case.
 	 */
-	if (p->euid == 0 && p->uid == current->uid)
+	if (p->uid == current->uid)
 		return 0;
 
 	/* sigcont is permitted within same session */
_

Patches currently in -mm which might be from serue@us.ibm.com are

file-capabilities-simplify-signal-check.patch
git-unionfs.patch
smack-update-for-file-capabilities.patch
capabilities-implement-per-process-securebits.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
reiser4-replace-uid==0-check-with-capability.patch
