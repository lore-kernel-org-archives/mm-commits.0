Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2942133F5B5
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498524; cv=none; b=Y/R6BEq5D6uBfbxzLs4vaNDZqsImymmI6Y/iTpTgjMoQxdmAgU8Fug8FGqRAn3CV6xAqNUqm1MPWl97tv3v3KnK/zZa6jzkAaEo3uyTIzfJ5zzHj7fo+qDr8MpNdr3iSkXjcTjURgNWXD7s3ni1Gxq2oBPSVdRwki5wisiA6/pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498524; c=relaxed/simple;
	bh=V1JQHhVr8QebBdGf1l4F1p2z7RcFgv0WJNmwJXu3ekg=;
	h=Date:To:From:Subject:Message-Id; b=tGMMzc9cQNGCz64kLvHAOXDfE/OUnnw7Lw2pUBhph6K+/nJgosLtjujMhWtLR1MybW78BP5bb1OsLcz9eA6N1hOHo26LX5a7g1NzjwxHBirrzI721p+zkw6yDYt7UXzkd2GvhGWzXv4brUcwPgeY2C+OH8cOPCaWWRArBKjTcAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OKBXgYWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OKBXgYWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DB4C19424;
	Sat, 18 Apr 2026 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498524;
	bh=V1JQHhVr8QebBdGf1l4F1p2z7RcFgv0WJNmwJXu3ekg=;
	h=Date:To:From:Subject:From;
	b=OKBXgYWXzCHJ2hOjpd8BXKwLMoIZ+4zg3/DeET8qKEKj6DOz6i+cjfWECW++m4OcZ
	 jD04VyiWx2HBZOc0MxfNcYDR/okQPAHsbEw5nCSagtmuv2kVQHt0wHYgM8tpxjNbB+
	 zOnos1efUYcHZ5qVQN0iPvxnu+GgV5hgL6O+d99g=
Date: Sat, 18 Apr 2026 00:48:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-prevent-memory-cgroup-release-in-page_io-module.patch removed from -mm tree
Message-Id: <20260418074842.A8DB4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_io: prevent memory cgroup release in page_io module
has been removed from the -mm tree.  Its filename was
     mm-page_io-prevent-memory-cgroup-release-in-page_io-module.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: page_io: prevent memory cgroup release in page_io module
Date: Thu, 5 Mar 2026 19:52:30 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in swap_writeout() and
bio_associate_blkg_from_page().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/7c3708358412fb02c482d0985feb5e9513a863ef.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-prevent-memory-cgroup-release-in-page_io-module
+++ a/mm/page_io.c
@@ -276,10 +276,14 @@ int swap_writeout(struct folio *folio, s
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
+
+	rcu_read_lock();
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
+	rcu_read_unlock();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -307,11 +311,11 @@ static void bio_associate_blkg_from_page
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


