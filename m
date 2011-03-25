From: akpm@linux-foundation.org
Subject: [merged] userns-allow-killing-tasks-in-your-own-or-child-userns.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:50 -0700
Message-ID: <201103250726.p2P7Qi1R026174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933986Ab1CYH0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: allow killing tasks in your own or child userns
has been removed from the -mm tree.  Its filename was
     userns-allow-killing-tasks-in-your-own-or-child-userns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: allow killing tasks in your own or child userns
From: "Serge E. Hallyn" <serge@hallyn.com>

Changelog:
	Dec  8: Fixed bug in my check_kill_permission pointed out by
	        Eric Biederman.
	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
	        for clarity
	Dec 31: address comment by Eric Biederman:
		don't need cred/tcred in check_kill_permission.
	Jan  1: use const cred struct.
	Jan 11: Per Bastian Blank's advice, clean up kill_ok_by_cred().
	Feb 16: kill_ok_by_cred: fix bad parentheses
	Feb 23: per akpm, let compiler inline kill_ok_by_cred

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~userns-allow-killing-tasks-in-your-own-or-child-userns kernel/signal.c
--- a/kernel/signal.c~userns-allow-killing-tasks-in-your-own-or-child-userns
+++ a/kernel/signal.c
@@ -636,13 +636,33 @@ static inline bool si_fromuser(const str
 }
 
 /*
+ * called with RCU read lock from check_kill_permission()
+ */
+static int kill_ok_by_cred(struct task_struct *t)
+{
+	const struct cred *cred = current_cred();
+	const struct cred *tcred = __task_cred(t);
+
+	if (cred->user->user_ns == tcred->user->user_ns &&
+	    (cred->euid == tcred->suid ||
+	     cred->euid == tcred->uid ||
+	     cred->uid  == tcred->suid ||
+	     cred->uid  == tcred->uid))
+		return 1;
+
+	if (ns_capable(tcred->user->user_ns, CAP_KILL))
+		return 1;
+
+	return 0;
+}
+
+/*
  * Bad permissions for sending the signal
  * - the caller must hold the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	const struct cred *cred, *tcred;
 	struct pid *sid;
 	int error;
 
@@ -656,14 +676,8 @@ static int check_kill_permission(int sig
 	if (error)
 		return error;
 
-	cred = current_cred();
-	tcred = __task_cred(t);
 	if (!same_thread_group(current, t) &&
-	    (cred->euid ^ tcred->suid) &&
-	    (cred->euid ^ tcred->uid) &&
-	    (cred->uid  ^ tcred->suid) &&
-	    (cred->uid  ^ tcred->uid) &&
-	    !capable(CAP_KILL)) {
+	    !kill_ok_by_cred(t)) {
 		switch (sig) {
 		case SIGCONT:
 			sid = task_session(t);
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

