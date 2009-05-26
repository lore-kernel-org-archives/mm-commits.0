From: akpm@linux-foundation.org
Subject: + ipcns-move-free_ipcs-proto.patch added to -mm tree
Date: Tue, 26 May 2009 16:16:45 -0700
Message-ID: <200905262316.n4QNGjAi031313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850AbZEZXRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     ipcns: move free_ipcs() proto
has been added to the -mm tree.  Its filename is
     ipcns-move-free_ipcs-proto.patch

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
Subject: ipcns: move free_ipcs() proto
From: Alexey Dobriyan <adobriyan@gmail.com>

Function is really private to ipc/ and avoid struct kern_ipc_perm
forward declaration.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
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
-
+void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
+		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cred-include-inith-in-credh.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
linux-next.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
groups-move-code-to-kernel-groupsc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
proc-merge-arrayc-into-basec.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch
ipcns-3-4-make-free_ipc_ns-static.patch
ipcns-move-free_ipcs-proto.patch

