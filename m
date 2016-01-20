From: akpm@linux-foundation.org
Subject: [folded-merged]
 ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 14:35:00 -0800
Message-ID: <56a00b94.OsAobCVHrLgEF4h2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934912AbcATWfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:35:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jann@thejh.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix
has been removed from the -mm tree.  Its filename was
     ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch

This patch was dropped because it was folded into ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix

fix warning

kernel/ptrace.c: In function '__ptrace_may_access':
kernel/ptrace.c:238: warning: ISO C90 forbids mixed declarations and code

Cc: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix
+++ a/kernel/ptrace.c
@@ -219,6 +219,7 @@ static int ptrace_has_cap(struct user_na
 static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	const struct cred *cred = current_cred(), *tcred;
+	int dumpable = 0;
 	kuid_t caller_uid;
 	kgid_t caller_gid;
 
@@ -235,7 +236,7 @@ static int __ptrace_may_access(struct ta
 	 * because setting up the necessary parent/child relationship
 	 * or halting the specified task is impossible.
 	 */
-	int dumpable = 0;
+
 	/* Don't let security modules deny introspection */
 	if (same_thread_group(task, current))
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch

