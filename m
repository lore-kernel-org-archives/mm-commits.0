From: akpm@linux-foundation.org
Subject: - security-filesystem-capabilities-fix-cap_setpcap-handling-fix.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:33:40 -0700
Message-ID: <200807040733.m647XeCg019582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYGDHl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, dhowells@redhat.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security-filesystem-capabilities-fix-cap_setpcap-handling-fix
has been removed from the -mm tree.  Its filename was
     security-filesystem-capabilities-fix-cap_setpcap-handling-fix.patch

This patch was dropped because it was folded into security-filesystem-capabilities-fix-cap_setpcap-handling.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security-filesystem-capabilities-fix-cap_setpcap-handling-fix
From: Andrew G. Morgan <morgan@kernel.org>

Within the kernel, ptraced is a more appropriate name.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN security/commoncap.c~security-filesystem-capabilities-fix-cap_setpcap-handling-fix security/commoncap.c
--- a/security/commoncap.c~security-filesystem-capabilities-fix-cap_setpcap-handling-fix
+++ a/security/commoncap.c
@@ -103,13 +103,13 @@ static inline int cap_inh_is_capped(void
 	return (cap_capable(current, CAP_SETPCAP) != 0);
 }
 
-static inline int cap_limit_straced_target(void) { return 1; }
+static inline int cap_limit_ptraced_target(void) { return 1; }
 
 #else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 
 static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
 static inline int cap_inh_is_capped(void) { return 1; }
-static inline int cap_limit_straced_target(void)
+static inline int cap_limit_ptraced_target(void)
 {
 	return !capable(CAP_SETPCAP);
 }
@@ -348,7 +348,7 @@ void cap_bprm_apply_creds (struct linux_
 				bprm->e_uid = current->uid;
 				bprm->e_gid = current->gid;
 			}
-			if (cap_limit_straced_target()) {
+			if (cap_limit_ptraced_target()) {
 				new_permitted =
 					cap_intersect(new_permitted,
 						      current->cap_permitted);
_

Patches currently in -mm which might be from morgan@kernel.org are

security-filesystem-capabilities-fix-fragile-setuid-fixup-code.patch
security-filesystem-capabilities-fix-cap_setpcap-handling.patch
security-filesystem-capabilities-fix-cap_setpcap-handling-fix.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
security-filesystem-capabilities-refactor-kernel-code.patch
security-filesystem-capabilities-no-longer-experimental.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

