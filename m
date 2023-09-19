Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFE0CD342E
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 03:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjISD0m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 23:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjISD0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 23:26:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AD610E
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 20:26:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FA4C433C8;
        Tue, 19 Sep 2023 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695093995;
        bh=9343aS5Mc46Hj+WjlGkaTDFDdzhfMvyUL/N+bIirkso=;
        h=Date:To:From:Subject:From;
        b=TmzIjk6ezQ7N6pYuZL7sGW7aQWXC0B/GNX2hgxrOne6enZvwyTjBEcJ+Hgg7FKZSO
         VFwaL7ugijkzqH6LZ5psqyrb2PwvzE/jqdic/3rfrMHYoONjwWWRdhNvFGT3aJBmdR
         5ClT6d3DWZ4n9Inlm2d51gB/rOcRCyvt6mU/kTIo=
Date:   Mon, 18 Sep 2023 20:26:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix.patch added to mm-unstable branch
Message-Id: <20230919032635.B1FA4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinker: some cleanup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinker: some cleanup
Date: Tue, 19 Sep 2023 10:46:07 +0800

Link: https://lkml.kernel.org/r/20230919024607.65463-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   14 ++++++++------
 mm/internal.h            |   17 ++++++++++++++---
 mm/shrinker.c            |   20 ++++++++++++--------
 mm/shrinker_debug.c      |   16 ----------------
 4 files changed, 34 insertions(+), 33 deletions(-)

--- a/include/linux/shrinker.h~mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix
+++ a/include/linux/shrinker.h
@@ -88,16 +88,18 @@ struct shrinker {
 };
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
-/* Flags */
-#define SHRINKER_REGISTERED	(1 << 0)
-#define SHRINKER_NUMA_AWARE	(1 << 1)
-#define SHRINKER_MEMCG_AWARE	(1 << 2)
+/* Internal flags */
+#define SHRINKER_REGISTERED	BIT(0)
+#define SHRINKER_ALLOCATED	BIT(1)
+
+/* Flags for users to use */
+#define SHRINKER_NUMA_AWARE	BIT(2)
+#define SHRINKER_MEMCG_AWARE	BIT(3)
 /*
  * It just makes sense when the shrinker is also MEMCG_AWARE for now,
  * non-MEMCG_AWARE shrinker should not have this flag set.
  */
-#define SHRINKER_NONSLAB	(1 << 3)
-#define SHRINKER_ALLOCATED	(1 << 4)
+#define SHRINKER_NONSLAB	BIT(4)
 
 struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
 void shrinker_register(struct shrinker *shrinker);
--- a/mm/internal.h~mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix
+++ a/mm/internal.h
@@ -1161,10 +1161,21 @@ unsigned long shrink_slab(gfp_t gfp_mask
 			  int priority);
 
 #ifdef CONFIG_SHRINKER_DEBUG
+static inline int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
+					      const char *fmt, va_list ap)
+{
+	shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
+
+	return shrinker->name ? 0 : -ENOMEM;
+}
+
+static inline void shrinker_debugfs_name_free(struct shrinker *shrinker)
+{
+	kfree_const(shrinker->name);
+	shrinker->name = NULL;
+}
+
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
-				       const char *fmt, va_list ap);
-extern void shrinker_debugfs_name_free(struct shrinker *shrinker);
 extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 					      int *debugfs_id);
 extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
--- a/mm/shrinker.c~mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix
+++ a/mm/shrinker.c
@@ -572,18 +572,23 @@ struct shrinker *shrinker_alloc(unsigned
 
 	if (flags & SHRINKER_MEMCG_AWARE) {
 		err = prealloc_memcg_shrinker(shrinker);
-		if (err == -ENOSYS)
+		if (err == -ENOSYS) {
+			/* Memcg is not supported, fallback to non-memcg-aware shrinker. */
 			shrinker->flags &= ~SHRINKER_MEMCG_AWARE;
-		else if (err == 0)
-			goto done;
-		else
+			goto non_memcg;
+		}
+
+		if (err)
 			goto err_flags;
+
+		return shrinker;
 	}
 
+non_memcg:
 	/*
 	 * The nr_deferred is available on per memcg level for memcg aware
 	 * shrinkers, so only allocate nr_deferred in the following cases:
-	 *  - non memcg aware shrinkers
+	 *  - non-memcg-aware shrinkers
 	 *  - !CONFIG_MEMCG
 	 *  - memcg is disabled by kernel command line
 	 */
@@ -595,7 +600,6 @@ struct shrinker *shrinker_alloc(unsigned
 	if (!shrinker->nr_deferred)
 		goto err_flags;
 
-done:
 	return shrinker;
 
 err_flags:
@@ -634,10 +638,10 @@ void shrinker_free(struct shrinker *shri
 		list_del(&shrinker->list);
 		debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 		shrinker->flags &= ~SHRINKER_REGISTERED;
-	} else {
-		shrinker_debugfs_name_free(shrinker);
 	}
 
+	shrinker_debugfs_name_free(shrinker);
+
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	up_write(&shrinker_rwsem);
--- a/mm/shrinker_debug.c~mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix
+++ a/mm/shrinker_debug.c
@@ -193,20 +193,6 @@ int shrinker_debugfs_add(struct shrinker
 	return 0;
 }
 
-int shrinker_debugfs_name_alloc(struct shrinker *shrinker, const char *fmt,
-				va_list ap)
-{
-	shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
-
-	return shrinker->name ? 0 : -ENOMEM;
-}
-
-void shrinker_debugfs_name_free(struct shrinker *shrinker)
-{
-	kfree_const(shrinker->name);
-	shrinker->name = NULL;
-}
-
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 {
 	struct dentry *entry;
@@ -255,8 +241,6 @@ struct dentry *shrinker_debugfs_detach(s
 
 	lockdep_assert_held(&shrinker_rwsem);
 
-	shrinker_debugfs_name_free(shrinker);
-
 	*debugfs_id = entry ? shrinker->debugfs_id : -1;
 	shrinker->debugfs_entry = NULL;
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch
mm-vmscan-move-shrinker-related-code-into-a-separate-file.patch
mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations.patch
drm-ttm-introduce-pool_shrink_rwsem.patch
mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker.patch
mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker-fix.patch
kvm-mmu-dynamically-allocate-the-x86-mmu-shrinker.patch
binder-dynamically-allocate-the-android-binder-shrinker.patch
drm-ttm-dynamically-allocate-the-drm-ttm_pool-shrinker.patch
xenbus-backend-dynamically-allocate-the-xen-backend-shrinker.patch
erofs-dynamically-allocate-the-erofs-shrinker.patch
f2fs-dynamically-allocate-the-f2fs-shrinker.patch
gfs2-dynamically-allocate-the-gfs2-glock-shrinker.patch
gfs2-dynamically-allocate-the-gfs2-qd-shrinker.patch
nfsv42-dynamically-allocate-the-nfs-xattr-shrinkers.patch
nfs-dynamically-allocate-the-nfs-acl-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-filecache-shrinker.patch
quota-dynamically-allocate-the-dquota-cache-shrinker.patch
ubifs-dynamically-allocate-the-ubifs-slab-shrinker.patch
rcu-dynamically-allocate-the-rcu-lazy-shrinker.patch
rcu-dynamically-allocate-the-rcu-kfree-shrinker.patch
mm-thp-dynamically-allocate-the-thp-related-shrinkers.patch
sunrpc-dynamically-allocate-the-sunrpc_cred-shrinker.patch
mm-workingset-dynamically-allocate-the-mm-shadow-shrinker.patch
drm-i915-dynamically-allocate-the-i915_gem_mm-shrinker.patch
drm-msm-dynamically-allocate-the-drm-msm_gem-shrinker.patch
drm-panfrost-dynamically-allocate-the-drm-panfrost-shrinker.patch
dm-dynamically-allocate-the-dm-bufio-shrinker.patch
dm-zoned-dynamically-allocate-the-dm-zoned-meta-shrinker.patch
md-raid5-dynamically-allocate-the-md-raid5-shrinker.patch
bcache-dynamically-allocate-the-md-bcache-shrinker.patch
vmw_balloon-dynamically-allocate-the-vmw-balloon-shrinker.patch
virtio_balloon-dynamically-allocate-the-virtio-balloon-shrinker.patch
mbcache-dynamically-allocate-the-mbcache-shrinker.patch
ext4-dynamically-allocate-the-ext4-es-shrinker.patch
jbd2ext4-dynamically-allocate-the-jbd2-journal-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-client-shrinker.patch
nfsd-dynamically-allocate-the-nfsd-reply-shrinker.patch
xfs-dynamically-allocate-the-xfs-buf-shrinker.patch
xfs-dynamically-allocate-the-xfs-inodegc-shrinker.patch
xfs-dynamically-allocate-the-xfs-qm-shrinker.patch
zsmalloc-dynamically-allocate-the-mm-zspool-shrinker.patch
fs-super-dynamically-allocate-the-s_shrink.patch
mm-shrinker-remove-old-apis.patch
mm-shrinker-add-a-secondary-array-for-shrinker_info-map-nr_deferred.patch
mm-shrinker-rename-preallocunregister_memcg_shrinker-to-shrinker_memcg_allocremove.patch
mm-shrinker-make-global-slab-shrink-lockless.patch
mm-shrinker-make-memcg-slab-shrink-lockless.patch
mm-shrinker-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex.patch

