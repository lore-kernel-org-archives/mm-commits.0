From: akpm@linux-foundation.org
Subject: + kernfs-convert-node-name-allocation-to-kstrdup_const.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 15:49:26 -0800
Message-ID: <54b5af06.MrZ2niKjNcJx4QDD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbAMXt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 18:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: convert node name allocation to kstrdup_const
has been added to the -mm tree.  Its filename is
     kernfs-convert-node-name-allocation-to-kstrdup_const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernfs-convert-node-name-allocation-to-kstrdup_const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernfs-convert-node-name-allocation-to-kstrdup_const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/dir.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/kernfs/dir.c~kernfs-convert-node-name-allocation-to-kstrdup_const fs/kernfs/dir.c
--- a/fs/kernfs/dir.c~kernfs-convert-node-name-allocation-to-kstrdup_const
+++ a/fs/kernfs/dir.c
@@ -408,7 +408,7 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 	if (!(kn->flags & KERNFS_STATIC_NAME))
-		kfree(kn->name);
+		kfree_const(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
 			security_release_secctx(kn->iattr->ia_secdata,
@@ -502,12 +502,12 @@ static struct kernfs_node *__kernfs_new_
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
@@ -534,7 +534,7 @@ static struct kernfs_node *__kernfs_new_
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-	kfree(dup_name);
+	kfree_const(dup_name);
 	return NULL;
 }
 
@@ -1260,7 +1260,7 @@ int kernfs_rename_ns(struct kernfs_node
 	/* rename kernfs_node */
 	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup_const(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 	} else {
@@ -1293,7 +1293,7 @@ int kernfs_rename_ns(struct kernfs_node
 	kernfs_link_sibling(kn);
 
 	kernfs_put(old_parent);
-	kfree(old_name);
+	kfree_const(old_name);
 
 	error = 0;
  out:
_

Patches currently in -mm which might be from a.hajda@samsung.com are

mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

