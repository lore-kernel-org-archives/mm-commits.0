Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774EEE7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbjJDUTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244080AbjJDUTM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:19:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8503BD9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:19:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98E9C433C9;
        Wed,  4 Oct 2023 20:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450748;
        bh=4CE3K0AaOHw8Wv/urEGXAAMn6jjvfBguXk9NPiAVGN8=;
        h=Date:To:From:Subject:From;
        b=HbGmLv4Kd+hwhE3VWF2wnfaCfgCBBhfwDfa9I1RZvrpFROp7uz13/dn6zP4HooZ2a
         O9CoGeqQZZMO+ONr8uxXMiqDUTras0ZYIvMXzQeKhbVmTqU92xZk7HP7oIJotE6ovx
         sy2Xwajzfcnr09MYMbRrXfWHLLbAxlLz7TdvPuvQ=
Date:   Wed, 04 Oct 2023 13:19:06 -0700
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
Subject: [merged mm-stable] mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations.patch removed from -mm tree
Message-Id: <20231004201907.C98E9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shrinker: remove redundant shrinker_rwsem in debugfs operations
has been removed from the -mm tree.  Its filename was
     mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinker: remove redundant shrinker_rwsem in debugfs operations
Date: Mon, 11 Sep 2023 17:25:16 +0800

debugfs_remove_recursive() will wait for debugfs_file_put() to return, so
the shrinker will not be freed when doing debugfs operations (such as
shrinker_debugfs_count_show() and shrinker_debugfs_scan_write()), so there
is no need to hold shrinker_rwsem during debugfs operations.

Link: https://lkml.kernel.org/r/20230911092517.64141-4-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
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

 mm/shrinker_debug.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinker-remove-redundant-shrinker_rwsem-in-debugfs-operations
+++ a/mm/shrinker_debug.c
@@ -51,17 +51,12 @@ static int shrinker_debugfs_count_show(s
 	struct mem_cgroup *memcg;
 	unsigned long total;
 	bool memcg_aware;
-	int ret, nid;
+	int ret = 0, nid;
 
 	count_per_node = kcalloc(nr_node_ids, sizeof(unsigned long), GFP_KERNEL);
 	if (!count_per_node)
 		return -ENOMEM;
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		kfree(count_per_node);
-		return ret;
-	}
 	rcu_read_lock();
 
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
@@ -94,7 +89,6 @@ static int shrinker_debugfs_count_show(s
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	rcu_read_unlock();
-	up_read(&shrinker_rwsem);
 
 	kfree(count_per_node);
 	return ret;
@@ -119,7 +113,6 @@ static ssize_t shrinker_debugfs_scan_wri
 	struct mem_cgroup *memcg = NULL;
 	int nid;
 	char kbuf[72];
-	ssize_t ret;
 
 	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
@@ -148,12 +141,6 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EINVAL;
 	}
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		mem_cgroup_put(memcg);
-		return ret;
-	}
-
 	sc.nid = nid;
 	sc.memcg = memcg;
 	sc.nr_to_scan = nr_to_scan;
@@ -161,7 +148,6 @@ static ssize_t shrinker_debugfs_scan_wri
 
 	shrinker->scan_objects(shrinker, &sc);
 
-	up_read(&shrinker_rwsem);
 	mem_cgroup_put(memcg);
 
 	return size;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


