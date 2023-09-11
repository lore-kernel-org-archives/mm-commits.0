Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79071CA0ECD
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbjIKWYK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244524AbjIKUjr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 16:39:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88BC127
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 13:39:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6796BC433C7;
        Mon, 11 Sep 2023 20:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694464780;
        bh=V+bbXacb4pRFWqVx2mR+uvYisKaDK6WEO/tZSgdLQ2I=;
        h=Date:To:From:Subject:From;
        b=Tekcg+xDWGxXMzEXZhhBUZ2r10P37uAZDACVDsbNeRROxd/lP+1DLhQY+kMKLSL8E
         y3ZaF1QNFaQN9guGfrOlWQ7C9j6O5u7QWG7ACekCzlJIJR+09sevDzQB6hCejORavv
         jYKlMZIhcADZfyE+qudkS4eMxTlS/fElZsjvnVTo=
Date:   Mon, 11 Sep 2023 13:39:39 -0700
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
Subject: + mbcache-dynamically-allocate-the-mbcache-shrinker.patch added to mm-unstable branch
Message-Id: <20230911203940.6796BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mbcache: dynamically allocate the mbcache shrinker
has been added to the -mm mm-unstable branch.  Its filename is
     mbcache-dynamically-allocate-the-mbcache-shrinker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mbcache-dynamically-allocate-the-mbcache-shrinker.patch

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
Subject: mbcache: dynamically allocate the mbcache shrinker
Date: Mon, 11 Sep 2023 17:44:28 +0800

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the mbcache shrinker, so that it can be freed
asynchronously via RCU. Then it doesn't need to wait for RCU read-side
critical section when releasing the struct mb_cache.

Link: https://lkml.kernel.org/r/20230911094444.68966-30-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Alasdair Kergon <agk@redhat.com>
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
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Coly Li <colyli@suse.de>
Cc: Dai Ngo <Dai.Ngo@oracle.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Marijn Suijten <marijn.suijten@somainline.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Olga Kornievskaia <kolga@netapp.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sean Paul <sean@poorly.run>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Song Liu <song@kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mbcache.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/mbcache.c~mbcache-dynamically-allocate-the-mbcache-shrinker
+++ a/fs/mbcache.c
@@ -37,7 +37,7 @@ struct mb_cache {
 	struct list_head	c_list;
 	/* Number of entries in cache */
 	unsigned long		c_entry_count;
-	struct shrinker		c_shrink;
+	struct shrinker		*c_shrink;
 	/* Work for shrinking when the cache has too many entries */
 	struct work_struct	c_shrink_work;
 };
@@ -293,8 +293,7 @@ EXPORT_SYMBOL(mb_cache_entry_touch);
 static unsigned long mb_cache_count(struct shrinker *shrink,
 				    struct shrink_control *sc)
 {
-	struct mb_cache *cache = container_of(shrink, struct mb_cache,
-					      c_shrink);
+	struct mb_cache *cache = shrink->private_data;
 
 	return cache->c_entry_count;
 }
@@ -333,8 +332,7 @@ static unsigned long mb_cache_shrink(str
 static unsigned long mb_cache_scan(struct shrinker *shrink,
 				   struct shrink_control *sc)
 {
-	struct mb_cache *cache = container_of(shrink, struct mb_cache,
-					      c_shrink);
+	struct mb_cache *cache = shrink->private_data;
 	return mb_cache_shrink(cache, sc->nr_to_scan);
 }
 
@@ -377,15 +375,19 @@ struct mb_cache *mb_cache_create(int buc
 	for (i = 0; i < bucket_count; i++)
 		INIT_HLIST_BL_HEAD(&cache->c_hash[i]);
 
-	cache->c_shrink.count_objects = mb_cache_count;
-	cache->c_shrink.scan_objects = mb_cache_scan;
-	cache->c_shrink.seeks = DEFAULT_SEEKS;
-	if (register_shrinker(&cache->c_shrink, "mbcache-shrinker")) {
+	cache->c_shrink = shrinker_alloc(0, "mbcache-shrinker");
+	if (!cache->c_shrink) {
 		kfree(cache->c_hash);
 		kfree(cache);
 		goto err_out;
 	}
 
+	cache->c_shrink->count_objects = mb_cache_count;
+	cache->c_shrink->scan_objects = mb_cache_scan;
+	cache->c_shrink->private_data = cache;
+
+	shrinker_register(cache->c_shrink);
+
 	INIT_WORK(&cache->c_shrink_work, mb_cache_shrink_worker);
 
 	return cache;
@@ -406,7 +408,7 @@ void mb_cache_destroy(struct mb_cache *c
 {
 	struct mb_cache_entry *entry, *next;
 
-	unregister_shrinker(&cache->c_shrink);
+	shrinker_free(cache->c_shrink);
 
 	/*
 	 * We don't bother with any locking. Cache must not be used at this
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

