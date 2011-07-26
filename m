From: akpm@linux-foundation.org
Subject: [folded] ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:57:10 -0700
Message-ID: <201107262257.p6QMvATf014664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1GZW5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-cleanup
has been removed from the -mm tree.  Its filename was
     ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch

This patch was dropped because it was folded into ipc-introduce-shm_rmid_forced-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-introduce-shm_rmid_forced-sysctl-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

readability/conventionality tweaks

Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl-cleanup ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl-cleanup
+++ a/ipc/ipc_sysctl.c
@@ -31,6 +31,7 @@ static int proc_ipc_dointvec(ctl_table *
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
+
 	memcpy(&ipc_table, table, sizeof(ipc_table));
 	ipc_table.data = get_ipc(table);
 
@@ -41,6 +42,7 @@ static int proc_ipc_dointvec_minmax(ctl_
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
+
 	memcpy(&ipc_table, table, sizeof(ipc_table));
 	ipc_table.data = get_ipc(table);
 
@@ -52,6 +54,7 @@ static int proc_ipc_dointvec_minmax_orph
 {
 	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
 	int err = proc_ipc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
 	if (err < 0)
 		return err;
 	if (ns->shm_rmid_forced)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

