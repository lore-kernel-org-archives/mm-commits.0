Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3421E7C4F9
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243883AbjJDUTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244105AbjJDUTr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:19:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CE6EC
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:19:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F004C433C8;
        Wed,  4 Oct 2023 20:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450778;
        bh=pJKLZ65bo4G9sZ1GxsZ0SdyPqocMmHNXopv7GBuHy10=;
        h=Date:To:From:Subject:From;
        b=XutH5aKlzVusnt5mJIlrMAaXYZnXhXxPZTR025X/2sm0hzY78pq62BWaojmN20eau
         4h8O5g5NNrNOqSXyqUYWWMTJqC0qcH61eGM10nYnhgHXxuD5ch0fJ+qppN69WpDmTC
         XqRBCTpFRYwTUOLRToSFm0yLgIzjUIrjSvwJJKcQ=
Date:   Wed, 04 Oct 2023 13:19:37 -0700
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
Subject: [merged mm-stable] rcu-dynamically-allocate-the-rcu-kfree-shrinker.patch removed from -mm tree
Message-Id: <20231004201938.6F004C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rcu: dynamically allocate the rcu-kfree shrinker
has been removed from the -mm tree.  Its filename was
     rcu-dynamically-allocate-the-rcu-kfree-shrinker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: rcu: dynamically allocate the rcu-kfree shrinker
Date: Mon, 11 Sep 2023 17:44:15 +0800

Use new APIs to dynamically allocate the rcu-kfree shrinker.

Link: https://lkml.kernel.org/r/20230911094444.68966-17-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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

 kernel/rcu/tree.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/kernel/rcu/tree.c~rcu-dynamically-allocate-the-rcu-kfree-shrinker
+++ a/kernel/rcu/tree.c
@@ -3449,13 +3449,6 @@ kfree_rcu_shrink_scan(struct shrinker *s
 	return freed == 0 ? SHRINK_STOP : freed;
 }
 
-static struct shrinker kfree_rcu_shrinker = {
-	.count_objects = kfree_rcu_shrink_count,
-	.scan_objects = kfree_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
-
 void __init kfree_rcu_scheduler_running(void)
 {
 	int cpu;
@@ -4931,6 +4924,7 @@ static void __init kfree_rcu_batch_init(
 {
 	int cpu;
 	int i, j;
+	struct shrinker *kfree_rcu_shrinker;
 
 	/* Clamp it to [0:100] seconds interval. */
 	if (rcu_delay_page_cache_fill_msec < 0 ||
@@ -4962,8 +4956,17 @@ static void __init kfree_rcu_batch_init(
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
-	if (register_shrinker(&kfree_rcu_shrinker, "rcu-kfree"))
-		pr_err("Failed to register kfree_rcu() shrinker!\n");
+
+	kfree_rcu_shrinker = shrinker_alloc(0, "rcu-kfree");
+	if (!kfree_rcu_shrinker) {
+		pr_err("Failed to allocate kfree_rcu() shrinker!\n");
+		return;
+	}
+
+	kfree_rcu_shrinker->count_objects = kfree_rcu_shrink_count;
+	kfree_rcu_shrinker->scan_objects = kfree_rcu_shrink_scan;
+
+	shrinker_register(kfree_rcu_shrinker);
 }
 
 void __init rcu_init(void)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


