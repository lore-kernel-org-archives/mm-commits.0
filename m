Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FC3CA0ECF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbjIKWYB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244451AbjIKUgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 16:36:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0D127
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 13:36:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00833C433CA;
        Mon, 11 Sep 2023 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694464607;
        bh=b2wIq9B03U5bvMydFk8tl7wDzpSwA5uw1GuiqT5g8+0=;
        h=Date:To:From:Subject:From;
        b=sw+uWIB/rriG2AtYCK5EPob5I4p4CE6U5UmPC5SpEeVnmN4mcnCXxfKLKKsC/5e5J
         8wcWheRWtv41OjXf3CNbKQ7Xsln3eegoK83xG6GyLlzepWiCDNZJMpOXvAkPujSM90
         aR/tiNfYvQ5eRTckmjYemZD9uDuuiPwrEUZYqrFk=
Date:   Mon, 11 Sep 2023 13:36:46 -0700
To:     mm-commits@vger.kernel.org, xuanzhuo@linux.alibaba.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, tytso@mit.edu,
        tvrtko.ursulin@linux.intel.com, trond.myklebust@hammerspace.com,
        tom@talpey.com, tomeu.vizoso@collabora.com, tkhai@ya.ru,
        tglx@linutronix.de, steven.price@arm.com, sstabellini@kernel.org,
        songmuchun@bytedance.com, song@kernel.org, snitzer@kernel.org,
        senozhatsky@chromium.org, sean@poorly.run, rpeterso@redhat.com,
        roman.gushchin@linux.dev, rodrigo.vivi@intel.com, robh@kernel.org,
        robdclark@gmail.com, richard@nod.at, ray.huang@amd.com,
        quic_abhinavk@quicinc.com, paulmck@kernel.org,
        oleksandr_tyshchenko@epam.com, neilb@suse.de, namit@vmware.com,
        muchun.song@linux.dev, mst@redhat.com, mingo@redhat.com,
        minchan@kernel.org, marijn.suijten@somainline.org,
        kolga@netapp.com, kent.overstreet@gmail.com, josef@toxicpanda.com,
        joonas.lahtinen@linux.intel.com, joel@joelfernandes.org,
        jlayton@kernel.org, jgross@suse.com, jefflexu@linux.alibaba.com,
        jasowang@redhat.com, jani.nikula@linux.intel.com,
        jaegeuk@kernel.org, jack@suse.cz, huyue2@coolpad.com,
        hsiangkao@linux.alibaba.com, gregkh@linuxfoundation.org,
        dsterba@suse.com, dmitry.baryshkov@linaro.org, djwong@kernel.org,
        david@redhat.com, david@fromorbit.com, dave.hansen@linux.intel.com,
        daniel.vetter@ffwll.ch, daniel@ffwll.ch, Dai.Ngo@oracle.com,
        colyli@suse.de, cmllamas@google.com, clm@fb.com,
        christian.koenig@amd.com, chao@kernel.org, chandan.babu@oracle.com,
        cel@kernel.org, brauner@kernel.org, bp@alien8.de, arnd@arndb.de,
        anna@kernel.org, alyssa.rosenzweig@collabora.com,
        airlied@gmail.com, agruenba@redhat.com, agk@redhat.com,
        adilger.kernel@dilger.ca, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch added to mm-unstable branch
Message-Id: <20230911203647.00833C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move some shrinker-related function declarations to mm/internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch

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
Subject: mm: move some shrinker-related function declarations to mm/internal.h
Date: Mon, 11 Sep 2023 17:25:14 +0800

Patch series "cleanups for lockless slab shrink", v4.

This series is some cleanups for lockless slab shrink.


This patch (of 4):

The following functions are only used inside the mm subsystem, so it's
better to move their declarations to the mm/internal.h file.

1. shrinker_debugfs_add()
2. shrinker_debugfs_detach()
3. shrinker_debugfs_remove()

Link: https://lkml.kernel.org/r/20230911092517.64141-1-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/20230911092517.64141-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Coly Li <colyli@suse.de>
Cc: Dai Ngo <Dai.Ngo@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Marijn Suijten <marijn.suijten@somainline.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Olga Kornievskaia <kolga@netapp.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Song Liu <song@kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   19 -------------------
 mm/internal.h            |   26 ++++++++++++++++++++++++++
 mm/shrinker_debug.c      |    2 ++
 3 files changed, 28 insertions(+), 19 deletions(-)

--- a/include/linux/shrinker.h~mm-move-some-shrinker-related-function-declarations-to-mm-internalh
+++ a/include/linux/shrinker.h
@@ -106,28 +106,9 @@ extern void free_prealloced_shrinker(str
 extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
-extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
-					      int *debugfs_id);
-extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
-				    int debugfs_id);
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
-static inline int shrinker_debugfs_add(struct shrinker *shrinker)
-{
-	return 0;
-}
-static inline struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
-						     int *debugfs_id)
-{
-	*debugfs_id = -1;
-	return NULL;
-}
-static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
-					   int debugfs_id)
-{
-}
 static inline __printf(2, 3)
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 {
--- a/mm/internal.h~mm-move-some-shrinker-related-function-declarations-to-mm-internalh
+++ a/mm/internal.h
@@ -1155,4 +1155,30 @@ struct vma_prepare {
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
 };
+
+/* shrinker related functions */
+
+#ifdef CONFIG_SHRINKER_DEBUG
+extern int shrinker_debugfs_add(struct shrinker *shrinker);
+extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
+					      int *debugfs_id);
+extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
+				    int debugfs_id);
+#else /* CONFIG_SHRINKER_DEBUG */
+static inline int shrinker_debugfs_add(struct shrinker *shrinker)
+{
+	return 0;
+}
+static inline struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
+						     int *debugfs_id)
+{
+	*debugfs_id = -1;
+	return NULL;
+}
+static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
+					   int debugfs_id)
+{
+}
+#endif /* CONFIG_SHRINKER_DEBUG */
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/shrinker_debug.c~mm-move-some-shrinker-related-function-declarations-to-mm-internalh
+++ a/mm/shrinker_debug.c
@@ -6,6 +6,8 @@
 #include <linux/shrinker.h>
 #include <linux/memcontrol.h>
 
+#include "internal.h"
+
 /* defined in vmscan.c */
 extern struct rw_semaphore shrinker_rwsem;
 extern struct list_head shrinker_list;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-move-some-shrinker-related-function-declarations-to-mm-internalh.patch
mm-vmscan-move-shrinker-related-code-into-a-separate-file.patch
mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations.patch
drm-ttm-introduce-pool_shrink_rwsem.patch
mm-shrinker-add-infrastructure-for-dynamically-allocating-shrinker.patch
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

