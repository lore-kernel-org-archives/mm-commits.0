From: akpm@linux-foundation.org
Subject: - security-filesystem-capabilities-fix-cap_setpcap-handling.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:09 -0700
Message-ID: <200807070305.m67359ju004797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbYGGDGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, dhowells@redhat.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security: filesystem capabilities: fix CAP_SETPCAP handling
has been removed from the -mm tree.  Its filename was
     security-filesystem-capabilities-fix-cap_setpcap-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: filesystem capabilities: fix CAP_SETPCAP handling
From: Andrew G. Morgan <morgan@kernel.org>

The filesystem capability support meaning for CAP_SETPCAP is less powerful
than the non-filesystem capability support.  As such, when filesystem
capabilities are configured, we should not permit CAP_SETPCAP to 'enhance'
the current process through strace manipulation of a child process.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN security/commoncap.c~security-filesystem-capabilities-fix-cap_setpcap-handling security/commoncap.c
--- a/security/commoncap.c~security-filesystem-capabilities-fix-cap_setpcap-handling
+++ a/security/commoncap.c
@@ -103,10 +103,16 @@ static inline int cap_inh_is_capped(void
 	return (cap_capable(current, CAP_SETPCAP) != 0);
 }
 
+static inline int cap_limit_ptraced_target(void) { return 1; }
+
 #else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 
 static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
 static inline int cap_inh_is_capped(void) { return 1; }
+static inline int cap_limit_ptraced_target(void)
+{
+	return !capable(CAP_SETPCAP);
+}
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
@@ -342,9 +348,10 @@ void cap_bprm_apply_creds (struct linux_
 				bprm->e_uid = current->uid;
 				bprm->e_gid = current->gid;
 			}
-			if (!capable (CAP_SETPCAP)) {
-				new_permitted = cap_intersect (new_permitted,
-							current->cap_permitted);
+			if (cap_limit_ptraced_target()) {
+				new_permitted =
+					cap_intersect(new_permitted,
+						      current->cap_permitted);
 			}
 		}
 	}
_

Patches currently in -mm which might be from morgan@kernel.org are

security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
security-filesystem-capabilities-refactor-kernel-code.patch
security-filesystem-capabilities-no-longer-experimental.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

