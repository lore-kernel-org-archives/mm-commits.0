From: akpm@linux-foundation.org
Subject: [merged] um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:56 -0700
Message-ID: <201109151935.p8FJZuiq014559@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934580Ab1IOTgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
has been removed from the -mm tree.  Its filename was
     um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
From: Al Viro <viro@ftp.linux.org.uk>

It's 32bit-only, not 64bit-only...  And while we are at it, it's
set_fpxregs(), not set_fpregs()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/ptrace.c   |   14 +++++++++++++-
 arch/um/sys-x86_64/ptrace.c |   14 +-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/um/sys-i386/ptrace.c~um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch
+++ a/arch/um/sys-i386/ptrace.c
@@ -206,5 +206,17 @@ int set_fpxregs(struct user_fxsr_struct 
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	return -EIO;
+	int ret = -EIO;
+	void __user *datap = (void __user *) data;
+
+	switch (request) {
+	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
+		ret = get_fpxregs(datap, child);
+		break;
+	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
+		ret = set_fpxregs(datap, child);
+		break;
+	}
+
+	return ret;
 }
diff -puN arch/um/sys-x86_64/ptrace.c~um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -178,17 +178,5 @@ int set_fpregs(struct user_i387_struct _
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	int ret = -EIO;
-	void __user *datap = (void __user *) data;
-
-	switch (request) {
-	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpregs(datap, child);
-		break;
-	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpregs(datap, child);
-		break;
-	}
