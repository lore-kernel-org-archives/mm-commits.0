From: akpm@linux-foundation.org
Subject: - add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:56:26 -0800
Message-ID: <200802040356.m143u76T012736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbYBDD4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:56:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: export __cap_ symbols
has been removed from the -mm tree.  Its filename was
     add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch

This patch was dropped because it was folded into add-64-bit-capability-support-to-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch
capabilities-introduce-per-process-capability-bounding-set.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
oom_kill-remove-uid==0-checks.patch
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
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
pid-namespaces-vs-locks-interaction.patch
reiser4-replace-uid==0-check-with-capability.patch
