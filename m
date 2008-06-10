From: akpm@linux-foundation.org
Subject: + capabilities-add-back-dummy-support-for-keepcaps.patch added to -mm tree
Date: Tue, 10 Jun 2008 10:55:05 -0700
Message-ID: <200806101755.m5AHt5qL021962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYFJR4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 13:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     capabilities: add (back) dummy support for KEEPCAPS
has been added to the -mm tree.  Its filename is
     capabilities-add-back-dummy-support-for-keepcaps.patch

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
Subject: capabilities: add (back) dummy support for KEEPCAPS
From: Andrew G. Morgan <morgan@kernel.org>

The dummy module is used by folk that run security conscious code(!?).  A
feature of such code (for example, dhclient) is that it tries to operate
with minimum privilege (dropping unneeded capabilities).  While the dummy
module doesn't restrict code execution based on capability state, the user
code expects the kernel to appear to support it.  This patch adds back
faked support for the PR_SET_KEEPCAPS etc., calls - making the kernel
behave as before 2.6.26.

For details see: http://bugzilla.kernel.org/show_bug.cgi?id=10748

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/dummy.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN security/dummy.c~capabilities-add-back-dummy-support-for-keepcaps security/dummy.c
--- a/security/dummy.c~capabilities-add-back-dummy-support-for-keepcaps
+++ a/security/dummy.c
@@ -27,6 +27,8 @@
 #include <linux/hugetlb.h>
 #include <linux/ptrace.h>
 #include <linux/file.h>
+#include <linux/prctl.h>
+#include <linux/securebits.h>
 
 static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
 {
@@ -607,7 +609,27 @@ static int dummy_task_kill (struct task_
 static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
 			     unsigned long arg4, unsigned long arg5, long *rc_p)
 {
-	return 0;
+	switch (option) {
+	case PR_CAPBSET_READ:
+		*rc_p = (cap_valid(arg2) ? 1 : -EINVAL);
+		break;
+	case PR_GET_KEEPCAPS:
+		*rc_p = issecure(SECURE_KEEP_CAPS);
+		break;
+	case PR_SET_KEEPCAPS:
+		if (arg2 > 1)
+			*rc_p = -EINVAL;
+		else if (arg2)
+			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+		else
+			current->securebits &=
+				~issecure_mask(SECURE_KEEP_CAPS);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
 }
 
 static void dummy_task_reparent_to_init (struct task_struct *p)
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
capabilities-add-back-dummy-support-for-keepcaps.patch
security-protect-legacy-apps-from-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

