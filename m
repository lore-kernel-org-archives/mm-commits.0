From: akpm@linux-foundation.org
Subject: + 64bit-capability-support-legacy-support-fix.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:10:26 -0800
Message-ID: <200711200210.lAK2AQ1D008695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762182AbXKTCLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:11:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kjwinchester@gmail.com, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     64bit capability support (legacy support fix)
has been added to the -mm tree.  Its filename is
     64bit-capability-support-legacy-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 64bit capability support (legacy support fix)
From: Andrew Morgan <morgan@kernel.org>

Legacy support requires that we don't return an error for previously
legitimate calls. Removing this check, we make a fail-safe best effort
to support legacy applications.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Serge Hallyn <serue@us.ibm.com>
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
@@ -109,13 +109,26 @@ out:
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

file-capabilities-allow-sigcont-within-session-v2.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
64bit-capability-support-legacy-support-fix.patch
remove-unnecessary-include-from-include-linux-capabilityh.patch
