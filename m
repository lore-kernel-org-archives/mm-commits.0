Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736BEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355594AbiCYBc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344355AbiCYBcV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128685E16A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987B761929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E883DC340ED;
        Fri, 25 Mar 2022 01:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171834;
        bh=hoQxvx2ANy8pYW6bshj0VZSB/aXGMyo34es4kDcHlNU=;
        h=Date:To:From:Subject:From;
        b=JRY3HGKQ1hjqDdJzg3SwLSCj5VrXk+Kuib+fW7TpaZMQr9necVIYwN062Oxsdo/wQ
         iVNH7BkyYlejkZ4lWhaArchvuD6HOehMkfrnv/qjQCnw6xK9P/i2BQ88khldK0CtEu
         U2tqIsEYlFxRkIjbFgas66hnvFlDh+kxu1eAurEw=
Date:   Thu, 24 Mar 2022 18:30:33 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch removed from -mm tree
Message-Id: <20220325013033.E883DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: dcache: use kmem_cache_alloc_lru() to allocate dentry
has been removed from the -mm tree.  Its filename was
     mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: dcache: use kmem_cache_alloc_lru() to allocate dentry

Like inode cache, the dentry will also be added to its memcg list_lru.  So
replace kmem_cache_alloc() with kmem_cache_alloc_lru() to allocate dentry.

Link: https://lkml.kernel.org/r/20220228122126.37293-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dcache.c~mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry
+++ a/fs/dcache.c
@@ -1766,7 +1766,8 @@ static struct dentry *__d_alloc(struct s
 	char *dname;
 	int err;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
+	dentry = kmem_cache_alloc_lru(dentry_cache, &sb->s_dentry_lru,
+				      GFP_KERNEL);
 	if (!dentry)
 		return NULL;
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


