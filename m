From: akpm@linux-foundation.org
Subject: - add-a-kmem_cache-for-nsproxy-objects.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:58 -0700
Message-ID: <200707162056.l6GKuwhF002136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbXGPVUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     add a kmem_cache for nsproxy objects
has been removed from the -mm tree.  Its filename was
     add-a-kmem_cache-for-nsproxy-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add a kmem_cache for nsproxy objects
From: Cedric Le Goater <clg@fr.ibm.com>

It should improve performance in some scenarii where a lot of
these nsproxy objects are created by unsharing namespaces. This is
a typical use of virtual servers that are being created or entered.

This is also a good tool to find leaks and gather statistics on
namespace usage.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/nsproxy.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN kernel/nsproxy.c~add-a-kmem_cache-for-nsproxy-objects kernel/nsproxy.c
--- a/kernel/nsproxy.c~add-a-kmem_cache-for-nsproxy-objects
+++ a/kernel/nsproxy.c
@@ -21,6 +21,8 @@
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 
+static struct kmem_cache *nsproxy_cachep;
+
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
 static inline void get_nsproxy(struct nsproxy *ns)
@@ -43,9 +45,11 @@ static inline struct nsproxy *clone_nspr
 {
 	struct nsproxy *ns;
 
-	ns = kmemdup(orig, sizeof(struct nsproxy), GFP_KERNEL);
-	if (ns)
+	ns = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
+	if (ns) {
+		memcpy(ns, orig, sizeof(struct nsproxy));
 		atomic_set(&ns->count, 1);
+	}
 	return ns;
 }
 
@@ -109,7 +113,7 @@ out_uts:
 	if (new_nsp->mnt_ns)
 		put_mnt_ns(new_nsp->mnt_ns);
 out_ns:
-	kfree(new_nsp);
+	kmem_cache_free(nsproxy_cachep, new_nsp);
 	return ERR_PTR(err);
 }
 
@@ -160,7 +164,7 @@ void free_nsproxy(struct nsproxy *ns)
 		put_pid_ns(ns->pid_ns);
 	if (ns->user_ns)
 		put_user_ns(ns->user_ns);
-	kfree(ns);
+	kmem_cache_free(nsproxy_cachep, ns);
 }
 
 /*
@@ -185,3 +189,12 @@ int unshare_nsproxy_namespaces(unsigned 
 		err = PTR_ERR(*new_nsp);
 	return err;
 }
+
+static int __init nsproxy_cache_init(void)
+{
+	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
+					   0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+module_init(nsproxy_cache_init);
_

Patches currently in -mm which might be from clg@fr.ibm.com are

origin.patch
containersv10-add-tasks-file-interface-fix-2.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
