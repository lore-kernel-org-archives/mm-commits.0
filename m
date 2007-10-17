From: akpm@linux-foundation.org
Subject: - capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:38:14 -0700
Message-ID: <200710170138.l9H1cEsw027979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760403AbXJQBoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: reset current->pdeath_signal when increasing capabilities
has been removed from the -mm tree.  Its filename was
     capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: capabilities: reset current->pdeath_signal when increasing capabilities
From: "Serge E. Hallyn" <serge@hallyn.com>

If running a program which has file capabilities which are not a subset of
the capabilities of the current task, reset pdeath_signal = 0 to prevent
the task parent from (deliberately) signaling a more privileged app.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN security/commoncap.c~capabilities-reset-current-pdeath_signal-when-increasing-capabilities security/commoncap.c
--- a/security/commoncap.c~capabilities-reset-current-pdeath_signal-when-increasing-capabilities
+++ a/security/commoncap.c
@@ -267,6 +267,7 @@ void cap_bprm_apply_creds (struct linux_
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
+		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
ifdef-struct-task_structsecurity.patch
implement-file-posix-capabilities.patch
capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
