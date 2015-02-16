From: akpm@linux-foundation.org
Subject: [merged]
 kernfs-convert-node-name-allocation-to-kstrdup_const.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:38 -0800
Message-ID: <54e24fea.HPCovf1JeiIKPsh0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbBPUQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: convert node name allocation to kstrdup_const
has been removed from the -mm tree.  Its filename was
     kernfs-convert-node-name-allocation-to-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: kernfs: convert node name allocation to kstrdup_const

sysfs frequently performs duplication of strings located in read-only
memory section.  Replacing kstrdup by kstrdup_const allows to avoid such
operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/dir.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/kernfs/dir.c~kernfs-convert-node-name-allocation-to-kstrdup_const fs/kernfs/dir.c
--- a/fs/kernfs/dir.c~kernfs-convert-node-name-allocation-to-kstrdup_const
+++ a/fs/kernfs/dir.c
@@ -412,7 +412,7 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 	if (!(kn->flags & KERNFS_STATIC_NAME))
-		kfree(kn->name);
+		kfree_const(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
 			security_release_secctx(kn->iattr->ia_secdata,
@@ -506,12 +506,12 @@ static struct kernfs_node *__kernfs_new_
 					     const char *name, umode_t mode,
 					     unsigned flags)
 {
-	char *dup_name = NULL;
+	const char *dup_name = NULL;
 	struct kernfs_node *kn;
 	int ret;
 
 	if (!(flags & KERNFS_STATIC_NAME)) {
-		name = dup_name = kstrdup(name, GFP_KERNEL);
+		name = dup_name = kstrdup_const(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
 	}
@@ -538,7 +538,7 @@ static struct kernfs_node *__kernfs_new_
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-	kfree(dup_name);
+	kfree_const(dup_name);
 	return NULL;
 }
 
@@ -1264,7 +1264,7 @@ int kernfs_rename_ns(struct kernfs_node
 	/* rename kernfs_node */
 	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup_const(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 	} else {
@@ -1297,7 +1297,7 @@ int kernfs_rename_ns(struct kernfs_node
 	kernfs_link_sibling(kn);
 
 	kernfs_put(old_parent);
-	kfree(old_name);
+	kfree_const(old_name);
 
 	error = 0;
  out:
_

Patches currently in -mm which might be from a.hajda@samsung.com are

origin.patch

