Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB37437F723
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456384; cv=none; b=Lqzi+/EgFaEYWZJxfu2azL0EDG+3384sNpa2r4kNistspUG3jstcQ8fEfqq6+Zjl6gDnEtFLl43IbMuOQhGv80NWPK7m4ALhUFaazWFMbmwaeX/eGk9X4pI0d0SrobE9l3Ma7qkXfXj9oY/IYrqL5pyJQ7rmYhNNQDGTDWgfNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456384; c=relaxed/simple;
	bh=uixvqC5nj/enLVa5fBPJNI681rUAnsyqmaSpPQc62xo=;
	h=Date:To:From:Subject:Message-Id; b=MBh1olN6OBQ8iwiVB2/1IKYZNDIfbtIyCX3BARu9OyhC6t47Ib/6jvAebVgwkJfdnVgC5980EN/5t2ueVS7pa6QQlbh69iwRrIOOjOCpifATPSik1AIg9ZKNW25RP6g3xUxovRkehURhM5K2JQYbZK6EocKYEogXyDY+vXBgo4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y0tnb11T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y0tnb11T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6711F000FF;
	Sat, 26 Sep 2026 20:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456382;
	bh=d/7jckz/R5rwRilp3LN4V2FlJ9kpx8s/g/TUXL3V+zE=;
	h=Date:To:From:Subject;
	b=Y0tnb11TbAwFqbPexrggZtqLa+uW+99I9LLGTYNZcq/DG9FoU0wbdyNfXbUIf4E9k
	 kXPrCppEfO39CjN0deMp4PQ67MrfxiKRFgKE/yDz32UbfNFT06vmaJNb9YPEh6sl7+
	 vw/pRczDoRlBDgcv9D9mScDReib4Xp/QdIQJnjZs=
Date: Sat, 26 Sep 2026 13:59:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch removed from -mm tree
Message-Id: <20260926205942.5F6711F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
has been removed from the -mm tree.  Its filename was
     mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Thu, 10 Sep 2026 16:07:22 +0800

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim never
invokes the zswap shrinker: a cgroup under memory pressure does not write
back its own zswapped pages to make room; they are only written back by
global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without SHRINKER_NONSLAB,
so under nokmem it is treated as a slab shrinker: before commit
03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online() check in
shrink_slab_memcg(); since that commit it is demoted to non-memcg-aware at
registration.  But the zswap shrinker is not a slab shrinker: it tracks
zswap entries and resolves the owning memcg from the folio's objcg,
independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs under
memcg reclaim with nokmem.

Link: https://lore.kernel.org/20260910080722.3961351-5-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [1]
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab
+++ a/mm/zswap.c
@@ -1297,8 +1297,8 @@ static struct shrinker *zswap_alloc_shri
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

