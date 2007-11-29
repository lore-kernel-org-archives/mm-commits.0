From: akpm@linux-foundation.org
Subject: + capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:41:55 -0800
Message-ID: <200711292341.lATNftrk013262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXK2XmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:42:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, jirislaby@gmail.com


The patch titled
     capabilities: correct logic at capset_check
has been added to the -mm tree.  Its filename is
     capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: capabilities: correct logic at capset_check
From: "Serge E. Hallyn" <serue@us.ibm.com>

Fix typo at capset_check introduced with capability bounding set
patch.

Signed-off-by: "Serge E. Hallyn" <serue@us.ibm.com>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/commoncap.c~capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check security/commoncap.c
--- a/security/commoncap.c~capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check
+++ a/security/commoncap.c
@@ -119,7 +119,7 @@ int cap_capset_check (struct task_struct
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
-	if (!!cap_issubset(*inheritable,
+	if (!cap_issubset(*inheritable,
 			   cap_combine(target->cap_inheritable,
 				       current->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
_

Patches currently in -mm which might be from serue@us.ibm.com are

isolate-the-uts-namespaces-domainname-and-hostname-back.patch
git-unionfs.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
64bit-capability-support-legacy-support-fix.patch
capabilities-introduce-per-process-capability-bounding-set.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
smack-using-capabilities-32-and-33.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
