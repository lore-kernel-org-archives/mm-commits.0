From: akpm@linux-foundation.org
Subject: [folded] ipc-introduce-shm_rmid_forced-sysctl-comments.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:57:13 -0700
Message-ID: <201107262257.p6QMvDNT014667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1GZW55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-comments
has been removed from the -mm tree.  Its filename was
     ipc-introduce-shm_rmid_forced-sysctl-comments.patch

This patch was dropped because it was folded into ipc-introduce-shm_rmid_forced-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-introduce-shm_rmid_forced-sysctl-comments
From: Vasiliy Kulikov <segoon@openwall.com>

shm_may_destroy() and ipc_namespace.shm_forced_rmid lack comments.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 ++
 ipc/shm.c                     |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl-comments
+++ a/include/linux/ipc_namespace.h
@@ -44,6 +44,8 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+	/* Defines whether IPC_RMID is forced for _all_ shm segments
+	 * regardless of shmctl() */
 	int		shm_rmid_forced;
 
 	struct notifier_block ipcns_nb;
diff -puN ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-comments
+++ a/ipc/shm.c
@@ -187,6 +187,16 @@ static void shm_destroy(struct ipc_names
 	ipc_rcu_putref(shp);
 }
 
+/*
+ * shm_may_destroy - identifies whether shm segment should be destroyed now
+ *
+ * Returns true if and only if there are no active users of the segment and
+ * one of the following is true:
+ *
+ * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
+ *
+ * 2) sysctl kernel.shm_forced_rmid is set to 1.
+ */
 static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	return (shp->shm_nattch == 0) &&
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
proc-fix-a-race-in-do_io_accounting.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch

