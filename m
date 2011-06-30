From: akpm@linux-foundation.org
Subject: + ipc-introduce-shm_rmid_forced-sysctl-comments.patch added to -mm tree
Date: Thu, 30 Jun 2011 11:15:32 -0700
Message-ID: <201106301815.p5UIFWUG004783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435Ab1F3SPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jun 2011 14:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-comments
has been added to the -mm tree.  Its filename is
     ipc-introduce-shm_rmid_forced-sysctl-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

