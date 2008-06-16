From: akpm@linux-foundation.org
Subject: - capabilities-add-back-dummy-support-for-keepcaps.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:18 -0700
Message-ID: <200806160603.m5G63I3O010587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbYFPGEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: add (back) dummy support for KEEPCAPS
has been removed from the -mm tree.  Its filename was
     capabilities-add-back-dummy-support-for-keepcaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Serge Hallyn <serue@us.ibm.com>
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
security-protect-legacy-apps-from-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

