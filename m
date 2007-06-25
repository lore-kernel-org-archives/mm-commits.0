From: akpm@linux-foundation.org
Subject: - fix-refcounting-of-nsproxy-object-when-unshared.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:25 -0700
Message-ID: <200706250920.l5P9KPgk031018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbXFYJVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, oleg@tv-sign.ru, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix refcounting of nsproxy object when unshared
has been removed from the -mm tree.  Its filename was
     fix-refcounting-of-nsproxy-object-when-unshared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix refcounting of nsproxy object when unshared
From: Cedric Le Goater <clg@fr.ibm.com>

When a namespace is unshared, a refcount on the previous nsproxy is
abusively taken, leading to a memory leak of nsproxy objects.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/nsproxy.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/nsproxy.c~fix-refcounting-of-nsproxy-object-when-unshared kernel/nsproxy.c
--- a/kernel/nsproxy.c~fix-refcounting-of-nsproxy-object-when-unshared
+++ a/kernel/nsproxy.c
@@ -145,13 +145,11 @@ void free_nsproxy(struct nsproxy *ns)
 
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
- * On sucess, returns the new nsproxy and a reference to old nsproxy
- * to make sure it stays around.
+ * On success, returns the new nsproxy.
  */
 int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 		struct nsproxy **new_nsp, struct fs_struct *new_fs)
 {
-	struct nsproxy *old_ns = current->nsproxy;
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
@@ -170,13 +168,9 @@ int unshare_nsproxy_namespaces(unsigned 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	get_nsproxy(old_ns);
-
 	*new_nsp = create_new_namespaces(unshare_flags, current,
 				new_fs ? new_fs : current->fs);
-	if (IS_ERR(*new_nsp)) {
+	if (IS_ERR(*new_nsp))
 		err = PTR_ERR(*new_nsp);
-		put_nsproxy(old_ns);
-	}
 	return err;
 }
_

Patches currently in -mm which might be from clg@fr.ibm.com are

mm-merge-nopfn-into-fault-spufs-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
containersv10-add-tasks-file-interface-fix-2.patch
