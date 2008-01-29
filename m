From: akpm@linux-foundation.org
Subject: - fix-filesystem-capability-support.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:37 -0800
Message-ID: <200801290147.m0T1lbY1027292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbYA2BsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix filesystem capability support
has been removed from the -mm tree.  Its filename was
     fix-filesystem-capability-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix filesystem capability support
From: "Andrew G. Morgan" <morgan@kernel.org>

In linux-2.6.24-rc1, security/commoncap.c:cap_inh_is_capped() was
introduced. It has the exact reverse of its intended behavior. This
led to an unintended privilege esculation involving a process'
inheritable capability set.

To be exposed to this bug, you need to have Filesystem Capabilities
enabled and in use. That is:

- CONFIG_SECURITY_FILE_CAPABILITIES must be defined for the buggy code
  to be compiled in.

- You also need to have files on your system marked with fI bits raised.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN security/commoncap.c~fix-filesystem-capability-support security/commoncap.c
--- a/security/commoncap.c~fix-filesystem-capability-support
+++ a/security/commoncap.c
@@ -59,6 +59,12 @@ int cap_netlink_recv(struct sk_buff *skb
 
 EXPORT_SYMBOL(cap_netlink_recv);
 
+/*
+ * NOTE WELL: cap_capable() cannot be used like the kernel's capable()
+ * function.  That is, it has the reverse semantics: cap_capable()
+ * returns 0 when a task has a capability, but the kernel's capable()
+ * returns 1 for this case.
+ */
 int cap_capable (struct task_struct *tsk, int cap)
 {
 	/* Derived from include/linux/sched.h:capable. */
@@ -107,10 +113,11 @@ static inline int cap_block_setpcap(stru
 static inline int cap_inh_is_capped(void)
 {
 	/*
-	 * return 1 if changes to the inheritable set are limited
-	 * to the old permitted set.
+	 * Return 1 if changes to the inheritable set are limited
+	 * to the old permitted set. That is, if the current task
+	 * does *not* possess the CAP_SETPCAP capability.
 	 */
-	return !cap_capable(current, CAP_SETPCAP);
+	return (cap_capable(current, CAP_SETPCAP) != 0);
 }
 
 #else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
_

Patches currently in -mm which might be from morgan@kernel.org are

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
remove-unnecessary-include-from-include-linux-capabilityh.patch
capabilities-introduce-per-process-capability-bounding-set.patch
oom_kill-remove-uid==0-checks.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-using-capabilities-32-and-33.patch
smack-mutex-capability-pointers-and-spelling-cleanup.patch
smack-socket-label-setting-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
