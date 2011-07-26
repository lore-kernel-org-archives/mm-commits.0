From: akpm@linux-foundation.org
Subject: [folded] ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:57:16 -0700
Message-ID: <201107262257.p6QMvGs8014670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711Ab1GZW57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-comments-fix
has been removed from the -mm tree.  Its filename was
     ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch

This patch was dropped because it was folded into ipc-introduce-shm_rmid_forced-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-introduce-shm_rmid_forced-sysctl-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix shm_rmid_forced/shm_forced_rmid confusion

- use standard comment layout

Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    6 ++++--
 ipc/shm.c                     |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments-fix include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments-fix
+++ a/include/linux/ipc_namespace.h
@@ -44,8 +44,10 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
-	/* Defines whether IPC_RMID is forced for _all_ shm segments
-	 * regardless of shmctl() */
+	/*
+	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
+	 * of shmctl()
+	 */
 	int		shm_rmid_forced;
 
 	struct notifier_block ipcns_nb;
diff -puN ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments-fix ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments-fix
+++ a/ipc/shm.c
@@ -195,7 +195,7 @@ static void shm_destroy(struct ipc_names
  *
  * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
  *
- * 2) sysctl kernel.shm_forced_rmid is set to 1.
+ * 2) sysctl kernel.shm_rmid_forced is set to 1.
  */
 static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

