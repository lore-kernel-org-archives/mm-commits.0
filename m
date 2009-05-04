From: akpm@linux-foundation.org
Subject: + nsproxy-extract-create_nsproxy.patch added to -mm tree
Date: Mon, 04 May 2009 16:43:21 -0700
Message-ID: <200905042343.n44NhL3l023294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbZEDXqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     nsproxy: extract create_nsproxy()
has been added to the -mm tree.  Its filename is
     nsproxy-extract-create_nsproxy.patch

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
Subject: nsproxy: extract create_nsproxy()
From: Alexey Dobriyan <adobriyan@gmail.com>

clone_nsproxy() does useless copying of old nsproxy -- every pointer will
be rewritten to new ns or to old ns.  Remove copying, rename
clone_nsproxy(), create_nsproxy() will be used by C/R code to create fresh
nsproxy on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/nsproxy.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN kernel/nsproxy.c~nsproxy-extract-create_nsproxy kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-extract-create_nsproxy
+++ a/kernel/nsproxy.c
@@ -26,19 +26,14 @@ static struct kmem_cache *nsproxy_cachep
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
-/*
- * creates a copy of "orig" with refcount 1.
- */
-static inline struct nsproxy *clone_nsproxy(struct nsproxy *orig)
+static inline struct nsproxy *create_nsproxy(void)
 {
-	struct nsproxy *ns;
+	struct nsproxy *nsproxy;
 
-	ns = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
-	if (ns) {
-		memcpy(ns, orig, sizeof(struct nsproxy));
-		atomic_set(&ns->count, 1);
-	}
-	return ns;
+	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
+	if (nsproxy)
+		atomic_set(&nsproxy->count, 1);
+	return nsproxy;
 }
 
 /*
@@ -52,7 +47,7 @@ static struct nsproxy *create_new_namesp
 	struct nsproxy *new_nsp;
 	int err;
 
-	new_nsp = clone_nsproxy(tsk->nsproxy);
+	new_nsp = create_nsproxy();
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch

