Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20D1E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjJFVru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjJFVrm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3214212D
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B5EC433C9;
        Fri,  6 Oct 2023 21:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628858;
        bh=yljazXQU22JxNK3HnAaZzReh+KcJn+zGIzRaeFF5dV0=;
        h=Date:To:From:Subject:From;
        b=AH9BtNpJw7vS1veuXjcacth2TzpbLHXMm96LWL9aYQzjLbrXwiWk2MAorNZ5s2H5q
         N+KNcSywx2GqAnJ8FrE9shsWKzSEr+ru6Ty9KOLeDxasT/5KSeaT0PgJE834ly+Bm4
         hQHOvL2OjwsEwS6VtMGMuMK/t2tU6YvevKrWiF68=
Date:   Fri, 06 Oct 2023 14:47:35 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        wangkefeng.wang@huawei.com, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-expose-swapcache-stat-for-memcg-v1.patch removed from -mm tree
Message-Id: <20231006214738.59B5EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: expose swapcache stat for memcg v1
has been removed from the -mm tree.  Its filename was
     memcg-expose-swapcache-stat-for-memcg-v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: memcg: expose swapcache stat for memcg v1
Date: Fri, 15 Sep 2023 18:58:44 +0800

Patch series "Expose swapcache stat for memcg v1", v2.

Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2")
adds swapcache stat for the cgroup v2, it seems there is no reason to hide
it in memcg v1.  Conversely, with swapcached it is more accurate to
evaluate the available memory for memcg.

Link: https://lkml.kernel.org/r/20230915105845.3199656-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20230915105845.3199656-2-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    1 +
 mm/memcontrol.c                                |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-expose-swapcache-stat-for-memcg-v1
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -551,6 +551,7 @@ memory.stat file includes following stat
                     event happens each time a page is unaccounted from the
                     cgroup.
     swap            # of bytes of swap usage
+    swapcached      # of bytes of swap cached in memory
     dirty           # of bytes that are waiting to get written back to the disk.
     writeback       # of bytes of file/anon cache that are queued for syncing to
                     disk.
--- a/mm/memcontrol.c~memcg-expose-swapcache-stat-for-memcg-v1
+++ a/mm/memcontrol.c
@@ -4068,7 +4068,10 @@ static const unsigned int memcg1_stats[]
 	NR_WRITEBACK,
 	WORKINGSET_REFAULT_ANON,
 	WORKINGSET_REFAULT_FILE,
+#ifdef CONFIG_SWAP
 	MEMCG_SWAP,
+	NR_SWAPCACHE,
+#endif
 };
 
 static const char *const memcg1_stat_names[] = {
@@ -4083,7 +4086,10 @@ static const char *const memcg1_stat_nam
 	"writeback",
 	"workingset_refault_anon",
 	"workingset_refault_file",
+#ifdef CONFIG_SWAP
 	"swap",
+	"swapcached",
+#endif
 };
 
 /* Universal VM events cgroup1 shows, original sort order */
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

