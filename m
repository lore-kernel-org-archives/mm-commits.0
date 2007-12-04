From: akpm@linux-foundation.org
Subject: + add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch added to -mm tree
Date: Mon, 03 Dec 2007 21:52:01 -0800
Message-ID: <200712040552.lB45q1dk003314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbXLDFwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com


The patch titled
     capabilities: export __cap_ symbols
has been added to the -mm tree.  Its filename is
     add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: capabilities: export __cap_ symbols
From: "Serge E. Hallyn" <serue@us.ibm.com>

Export __cap_empty_set and friends so that the cap_clear(), cap_set_full()
and cap_set_init_eff() defines can be used by modules.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/capability.c~add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols kernel/capability.c
--- a/kernel/capability.c~add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols
+++ a/kernel/capability.c
@@ -29,6 +29,10 @@ const kernel_cap_t __cap_empty_set = CAP
 const kernel_cap_t __cap_full_set = CAP_FULL_SET;
 const kernel_cap_t __cap_init_eff_set = CAP_INIT_EFF_SET;
 
+EXPORT_SYMBOL(__cap_empty_set);
+EXPORT_SYMBOL(__cap_full_set);
+EXPORT_SYMBOL(__cap_init_eff_set);
+
 /*
  * More recent versions of libcap are available from:
  *
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-net.patch
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
add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch
capabilities-introduce-per-process-capability-bounding-set.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
