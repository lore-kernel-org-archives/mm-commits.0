From: akpm@linux-foundation.org
Subject: [merged] nsproxy-extract-create_nsproxy.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:40 -0700
Message-ID: <200906182247.n5IMlelc006814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756933AbZFRW5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     nsproxy: extract create_nsproxy()
has been removed from the -mm tree.  Its filename was
     nsproxy-extract-create_nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
procfs-provide-stack-information-for-threads-v08.patch

