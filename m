From: akpm@linux-foundation.org
Subject: - 64bit-capability-support-legacy-support-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:56:19 -0800
Message-ID: <200802040356.m143u0oS012724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906AbYBDD5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kjwinchester@gmail.com, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     64bit capability support (legacy support fix)
has been removed from the -mm tree.  Its filename was
     64bit-capability-support-legacy-support-fix.patch

This patch was dropped because it was folded into add-64-bit-capability-support-to-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 64bit capability support (legacy support fix)
From: Andrew Morgan <morgan@kernel.org>

Legacy support requires that we don't return an error for previously
legitimate calls. Removing this check, we make a fail-safe best effort
to support legacy applications.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Tested-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -puN kernel/capability.c~64bit-capability-support-legacy-support-fix kernel/capability.c
--- a/kernel/capability.c~64bit-capability-support-legacy-support-fix
+++ a/kernel/capability.c
@@ -122,13 +122,26 @@ out:
 			kdata[i].permitted = pP.cap[i];
 			kdata[i].inheritable = pI.cap[i];
 		}
-		while (i < _LINUX_CAPABILITY_U32S) {
-			if (pE.cap[i] || pP.cap[i] || pP.cap[i]) {
-				/* Cannot represent w/ legacy structure */
-				return -ERANGE;
-			}
-			i++;
-		}
+
+		/*
+		 * Note, in the case, tocopy < _LINUX_CAPABILITY_U32S,
+		 * we silently drop the upper capabilities here. This
+		 * has the effect of making older libcap
+		 * implementations implicitly drop upper capability
+		 * bits when they perform a: capget/modify/capset
+		 * sequence.
+		 *
+		 * This behavior is considered fail-safe
+		 * behavior. Upgrading the application to a newer
+		 * version of libcap will enable access to the newer
+		 * capabilities.
+		 *
+		 * An alternative would be to return an error here
+		 * (-ERANGE), but that causes legacy applications to
+		 * unexpectidly fail; the capget/modify/capset aborts
+		 * before modification is attempted and the application
+		 * fails.
+		 */
 
 		if (copy_to_user(dataptr, kdata, tocopy
 				 * sizeof(struct __user_cap_data_struct))) {
_

Patches currently in -mm which might be from morgan@kernel.org are

revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
64bit-capability-support-legacy-support-fix.patch
remove-unnecessary-include-from-include-linux-capabilityh.patch
capabilities-introduce-per-process-capability-bounding-set.patch
oom_kill-remove-uid==0-checks.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-version-11c-simplified-mandatory-access-control-kernel-fix.patch
smack-using-capabilities-32-and-33.patch
smack-mutex-capability-pointers-and-spelling-cleanup.patch
smack-socket-label-setting-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
