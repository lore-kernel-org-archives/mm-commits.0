Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38B0E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbjJDUTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244050AbjJDUTL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:19:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E6CC9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:19:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8E3C433C7;
        Wed,  4 Oct 2023 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450746;
        bh=gCPe/lAR6ODQ9mrDURdZtYgP3NxpzyWlcylDyuPpCTU=;
        h=Date:To:From:Subject:From;
        b=KBus0WWjdSb8TWngKU5TD+pdDDkIMgaRiH5MuLWno8I+u+ISg/atw8SXXsH+f71xi
         l6tORRNa/6POuiWT1UvoVNVvBOXcY4H1KtYfF1qqCYDlt8Z2VFWXw5Igk9BmdLt9Uc
         uQl3VPS60KBotea/qjHfq22KpPHFpC57j/45vv+k=
Date:   Wed, 04 Oct 2023 13:19:04 -0700
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
Subject: [merged mm-stable] drm-ttm-introduce-pool_shrink_rwsem.patch removed from -mm tree
Message-Id: <20231004201905.CE8E3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/ttm: introduce pool_shrink_rwsem
has been removed from the -mm tree.  Its filename was
     drm-ttm-introduce-pool_shrink_rwsem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: drm/ttm: introduce pool_shrink_rwsem
Date: Mon, 11 Sep 2023 17:25:17 +0800

Currently, synchronize_shrinkers() is only used by TTM pool.  It only
requires that no shrinkers run in parallel.

After we use RCU+refcount method to implement the lockless slab shrink, we
can not use shrinker_rwsem or synchronize_rcu() to guarantee that all
shrinker invocations have seen an update before freeing memory.

So we introduce a new pool_shrink_rwsem to implement a private
ttm_pool_synchronize_shrinkers(), so as to achieve the same purpose.

Link: https://lkml.kernel.org/r/20230911092517.64141-5-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Christian Brauner <brauner@kernel.org>
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

 drivers/gpu/drm/ttm/ttm_pool.c |   17 ++++++++++++++++-
 include/linux/shrinker.h       |    1 -
 mm/shrinker.c                  |   15 ---------------
 3 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_pool.c~drm-ttm-introduce-pool_shrink_rwsem
+++ a/drivers/gpu/drm/ttm/ttm_pool.c
@@ -74,6 +74,7 @@ static struct ttm_pool_type global_dma32
 static spinlock_t shrinker_lock;
 static struct list_head shrinker_list;
 static struct shrinker mm_shrinker;
+static DECLARE_RWSEM(pool_shrink_rwsem);
 
 /* Allocate pages of size 1 << order with the given gfp_flags */
 static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
@@ -317,6 +318,7 @@ static unsigned int ttm_pool_shrink(void
 	unsigned int num_pages;
 	struct page *p;
 
+	down_read(&pool_shrink_rwsem);
 	spin_lock(&shrinker_lock);
 	pt = list_first_entry(&shrinker_list, typeof(*pt), shrinker_list);
 	list_move_tail(&pt->shrinker_list, &shrinker_list);
@@ -329,6 +331,7 @@ static unsigned int ttm_pool_shrink(void
 	} else {
 		num_pages = 0;
 	}
+	up_read(&pool_shrink_rwsem);
 
 	return num_pages;
 }
@@ -573,6 +576,18 @@ void ttm_pool_init(struct ttm_pool *pool
 EXPORT_SYMBOL(ttm_pool_init);
 
 /**
+ * ttm_pool_synchronize_shrinkers - Wait for all running shrinkers to complete.
+ *
+ * This is useful to guarantee that all shrinker invocations have seen an
+ * update, before freeing memory, similar to rcu.
+ */
+static void ttm_pool_synchronize_shrinkers(void)
+{
+	down_write(&pool_shrink_rwsem);
+	up_write(&pool_shrink_rwsem);
+}
+
+/**
  * ttm_pool_fini - Cleanup a pool
  *
  * @pool: the pool to clean up
@@ -593,7 +608,7 @@ void ttm_pool_fini(struct ttm_pool *pool
 	/* We removed the pool types from the LRU, but we need to also make sure
 	 * that no shrinker is concurrently freeing pages from the pool.
 	 */
-	synchronize_shrinkers();
+	ttm_pool_synchronize_shrinkers();
 }
 EXPORT_SYMBOL(ttm_pool_fini);
 
--- a/include/linux/shrinker.h~drm-ttm-introduce-pool_shrink_rwsem
+++ a/include/linux/shrinker.h
@@ -103,7 +103,6 @@ extern int __printf(2, 3) register_shrin
 					    const char *fmt, ...);
 extern void unregister_shrinker(struct shrinker *shrinker);
 extern void free_prealloced_shrinker(struct shrinker *shrinker);
-extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
--- a/mm/shrinker.c~drm-ttm-introduce-pool_shrink_rwsem
+++ a/mm/shrinker.c
@@ -692,18 +692,3 @@ void unregister_shrinker(struct shrinker
 	shrinker->nr_deferred = NULL;
 }
 EXPORT_SYMBOL(unregister_shrinker);
-
-/**
- * synchronize_shrinkers - Wait for all running shrinkers to complete.
- *
- * This is equivalent to calling unregister_shrink() and register_shrinker(),
- * but atomically and with less overhead. This is useful to guarantee that all
- * shrinker invocations have seen an update, before freeing memory, similar to
- * rcu.
- */
-void synchronize_shrinkers(void)
-{
-	down_write(&shrinker_rwsem);
-	up_write(&shrinker_rwsem);
-}
-EXPORT_SYMBOL(synchronize_shrinkers);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


