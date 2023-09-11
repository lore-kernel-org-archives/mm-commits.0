Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06BFCA0EC3
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbjIKWW1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244511AbjIKUjN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 16:39:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE02127
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 13:39:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1512FC433C7;
        Mon, 11 Sep 2023 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694464748;
        bh=r9xyVX6hqEtFaFJtckGjFk8tzLAvEDjoXv7R9QOtTto=;
        h=Date:To:From:Subject:From;
        b=qc8ErAI7EQ5fczv3drT8Y9vW4MN1etGts+zj3O2PbNkVcD3yoBPsvzSCduoNltHVr
         2i3Vdr3uw+qqyFr2E0tKW5XisHT7vbhmYLK7t1YTSzIOraxIUgu9Py49MJp9XIlv9a
         4yKrVu+m8luW3mHjEzQcr3sG3L8ohy10CjDXloWE=
Date:   Mon, 11 Sep 2023 13:39:07 -0700
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
Subject: + dm-dynamically-allocate-the-dm-bufio-shrinker.patch added to mm-unstable branch
Message-Id: <20230911203908.1512FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dm: dynamically allocate the dm-bufio shrinker
has been added to the -mm mm-unstable branch.  Its filename is
     dm-dynamically-allocate-the-dm-bufio-shrinker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dm-dynamically-allocate-the-dm-bufio-shrinker.patch

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
Subject: dm: dynamically allocate the dm-bufio shrinker
Date: Mon, 11 Sep 2023 17:44:22 +0800

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the dm-bufio shrinker, so that it can be freed
asynchronously via RCU. Then it doesn't need to wait for RCU read-side
critical section when releasing the struct dm_bufio_client.

Link: https://lkml.kernel.org/r/20230911094444.68966-24-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
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
Cc: Christian Brauner <brauner@kernel.org>
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

 drivers/md/dm-bufio.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-bufio.c~dm-dynamically-allocate-the-dm-bufio-shrinker
+++ a/drivers/md/dm-bufio.c
@@ -963,7 +963,7 @@ struct dm_bufio_client {
 
 	sector_t start;
 
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 	struct work_struct shrink_work;
 	atomic_long_t need_shrink;
 
@@ -2368,7 +2368,7 @@ static unsigned long dm_bufio_shrink_sca
 {
 	struct dm_bufio_client *c;
 
-	c = container_of(shrink, struct dm_bufio_client, shrinker);
+	c = shrink->private_data;
 	atomic_long_add(sc->nr_to_scan, &c->need_shrink);
 	queue_work(dm_bufio_wq, &c->shrink_work);
 
@@ -2377,7 +2377,7 @@ static unsigned long dm_bufio_shrink_sca
 
 static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
+	struct dm_bufio_client *c = shrink->private_data;
 	unsigned long count = cache_total(&c->cache);
 	unsigned long retain_target = get_retain_buffers(c);
 	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
@@ -2490,14 +2490,20 @@ struct dm_bufio_client *dm_bufio_client_
 	INIT_WORK(&c->shrink_work, shrink_work);
 	atomic_long_set(&c->need_shrink, 0);
 
-	c->shrinker.count_objects = dm_bufio_shrink_count;
-	c->shrinker.scan_objects = dm_bufio_shrink_scan;
-	c->shrinker.seeks = 1;
-	c->shrinker.batch = 0;
-	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
-			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
-	if (r)
+	c->shrinker = shrinker_alloc(0, "dm-bufio:(%u:%u)",
+				     MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+	if (!c->shrinker) {
+		r = -ENOMEM;
 		goto bad;
+	}
+
+	c->shrinker->count_objects = dm_bufio_shrink_count;
+	c->shrinker->scan_objects = dm_bufio_shrink_scan;
+	c->shrinker->seeks = 1;
+	c->shrinker->batch = 0;
+	c->shrinker->private_data = c;
+
+	shrinker_register(c->shrinker);
 
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
@@ -2537,7 +2543,7 @@ void dm_bufio_client_destroy(struct dm_b
 
 	drop_buffers(c);
 
-	unregister_shrinker(&c->shrinker);
+	shrinker_free(c->shrinker);
 	flush_work(&c->shrink_work);
 
 	mutex_lock(&dm_bufio_clients_lock);
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

