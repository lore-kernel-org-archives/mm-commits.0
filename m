From: akpm@linux-foundation.org
Subject: + add-a-kmem_cache-for-nsproxy-objects.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:43:18 -0700
Message-ID: <200706191843.l5JIhIr0018310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762408AbXFSSnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, xemul@openvz.org


The patch titled
     add a kmem_cache for nsproxy objects
has been added to the -mm tree.  Its filename is
     add-a-kmem_cache-for-nsproxy-objects.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 17 insertions(+), 4 deletions(-)

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

fix-refcounting-of-nsproxy-object-when-unshared.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
containersv10-add-tasks-file-interface-fix-2.patch
