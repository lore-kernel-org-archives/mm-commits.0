From: akpm@linux-foundation.org
Subject: +
 security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch added to -mm tree
Date: Tue, 08 Dec 2015 13:14:17 -0800
Message-ID: <56674829.kaenbKM2RbJJ8KYZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbLHVOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 16:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, andriy.shevchenko@linux.intel.com, casey@schaufler-ca.com, ebiederm@xmission.com, james.l.morris@oracle.com, keescook@chromium.org, luto@kernel.org, mingo@redhat.com, oleg@redhat.com, serge.hallyn@ubuntu.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: security: let security modules use PTRACE_MODE_* with bitmasks
has been added to the -mm tree.  Its filename is
     security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: security: let security modules use PTRACE_MODE_* with bitmasks

It looks like smack and yama weren't aware that the ptrace mode
can have flags ORed into it - PTRACE_MODE_NOAUDIT until now, but
only for /proc/$pid/stat, and with the PTRACE_MODE_*CREDS patch,
all modes have flags ORed into them.

Signed-off-by: Jann Horn <jann@thejh.net>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    8 +++-----
 security/yama/yama_lsm.c   |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN security/smack/smack_lsm.c~security-let-security-modules-use-ptrace_mode_-with-bitmasks security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~security-let-security-modules-use-ptrace_mode_-with-bitmasks
+++ a/security/smack/smack_lsm.c
@@ -398,12 +398,10 @@ static int smk_copy_relabel(struct list_
  */
 static inline unsigned int smk_ptrace_mode(unsigned int mode)
 {
-	switch (mode) {
-	case PTRACE_MODE_READ:
-		return MAY_READ;
-	case PTRACE_MODE_ATTACH:
+	if (mode & PTRACE_MODE_ATTACH)
 		return MAY_READWRITE;
-	}
+	if (mode & PTRACE_MODE_READ)
+		return MAY_READ;
 
 	return 0;
 }
diff -puN security/yama/yama_lsm.c~security-let-security-modules-use-ptrace_mode_-with-bitmasks security/yama/yama_lsm.c
--- a/security/yama/yama_lsm.c~security-let-security-modules-use-ptrace_mode_-with-bitmasks
+++ a/security/yama/yama_lsm.c
@@ -281,7 +281,7 @@ static int yama_ptrace_access_check(stru
 	int rc = 0;
 
 	/* require ptrace target be a child of ptracer on attach */
-	if (mode == PTRACE_MODE_ATTACH) {
+	if (mode & PTRACE_MODE_ATTACH) {
 		switch (ptrace_scope) {
 		case YAMA_SCOPE_DISABLED:
 			/* No additional restrictions. */
@@ -307,7 +307,7 @@ static int yama_ptrace_access_check(stru
 		}
 	}
 
-	if (rc) {
+	if (rc && (mode & PTRACE_MODE_NOAUDIT) == 0) {
 		printk_ratelimited(KERN_NOTICE
 			"ptrace of pid %d was attempted by: %s (pid %d)\n",
 			child->pid, current->comm, current->pid);
_

Patches currently in -mm which might be from jann@thejh.net are

security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks.patch

