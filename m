From: akpm@linux-foundation.org
Subject: [folded] namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:29:39 -0700
Message-ID: <200904062229.n36MTdwC015791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbZDFWci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipc namespace: initialize init_ipc_ns.count to 1
has been removed from the -mm tree.  Its filename was
     namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch

This patch was dropped because it was folded into namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc namespace: initialize init_ipc_ns.count to 1
From: "Serge E. Hallyn" <serue@us.ibm.com>

Hi Andrew,

when I sent an earlier version of the posix mqueue namespaces patchset
you called me on setting init_ipc_ns.count to 2.  The following patch
changes that to 1.  This is safe because the 1-count is for swapper, who
cannot unshare the namespace.  Having init do unshare(CLONE_NEWIPC) only
drops the count to 1.  No pre-init resources other than tasks pin (and
therefore can decrease the refcount on) an ipc_ns.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/msgutil.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1 ipc/msgutil.c
--- a/ipc/msgutil.c~namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1
+++ a/ipc/msgutil.c
@@ -26,8 +26,7 @@ DEFINE_SPINLOCK(mq_lock);
  * and not CONFIG_IPC_NS.
  */
 struct ipc_namespace init_ipc_ns = {
-	/* It's not for this patch to change, but should this be 1? */
-	.count		= ATOMIC_INIT(2),
+	.count		= ATOMIC_INIT(1),
 #ifdef CONFIG_POSIX_MQUEUE
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
reiser4.patch

