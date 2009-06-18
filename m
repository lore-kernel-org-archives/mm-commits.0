From: akpm@linux-foundation.org
Subject: [merged] ipcns-move-free_ipcs-proto.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:44 -0700
Message-ID: <200906182247.n5IMliQq006824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759288AbZFRWsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: move free_ipcs() proto
has been removed from the -mm tree.  Its filename was
     ipcns-move-free_ipcs-proto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: move free_ipcs() proto
From: Alexey Dobriyan <adobriyan@gmail.com>

Function is really private to ipc/ and avoid struct kern_ipc_perm
forward declaration.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    4 ----
 ipc/util.h                    |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipcns-move-free_ipcs-proto include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipcns-move-free_ipcs-proto
+++ a/include/linux/ipc_namespace.h
@@ -96,10 +96,6 @@ static inline int mq_init_ns(struct ipc_
 #if defined(CONFIG_IPC_NS)
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 				       struct ipc_namespace *ns);
-extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-		      void (*free)(struct ipc_namespace *,
-				   struct kern_ipc_perm *));
-
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
diff -puN ipc/util.h~ipcns-move-free_ipcs-proto ipc/util.h
--- a/ipc/util.h~ipcns-move-free_ipcs-proto
+++ a/ipc/util.h
@@ -171,5 +171,6 @@ static inline void ipc_unlock(struct ker
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
