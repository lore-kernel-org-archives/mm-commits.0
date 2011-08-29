From: akpm@linux-foundation.org
Subject: + um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:45 -0700
Message-ID: <201108292135.p7TLZkEf030280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1H2Vpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
has been added to the -mm tree.  Its filename is
     um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
