Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A360337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498585; cv=none; b=onsQXhdcgc5Pls3OzPifqW3sRkk76dUobX3zlscLrtzhrm2EEvE3970qedtohK0prZ9Zab1x4IQkYxUERSLxwObFkf7QbvQ2TWJ2WnzvlSf2JEcwyKBalwrPWgrReF/6SsAkZtJsvivdQKCkvF8q2kfGQJ9/VmzfRX7HFQbjm94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498585; c=relaxed/simple;
	bh=LlutI2ozvRKwHSARu1m0LMTMsA1ZOMh0F7PiX3+lp+4=;
	h=Date:To:From:Subject:Message-Id; b=LDwk3XeMGahVNIUKR3hjNc21cq9Z8pZqDeV2LMHwiEBPuZ2rDwocW12NjO9+7wLZepxhAXj3VY1b2uhRO302LYCDvh7gYa4eEj+cofs42zYcxt63CF4SfnqJQm9y/nQ/ajX9RhD1qVa0/6cMzo647fG/QXaGpWYdqkESm+t+/8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOIXpp8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOIXpp8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56730C19424;
	Sat, 18 Apr 2026 07:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498585;
	bh=LlutI2ozvRKwHSARu1m0LMTMsA1ZOMh0F7PiX3+lp+4=;
	h=Date:To:From:Subject:From;
	b=TOIXpp8MP0opcyBKpG4i2sgIbjksxSXNg3r+i62cMWbK9/fRa3xqT8DoQerRs2D2W
	 O9wTdYYK3bbA3k5HWhd/yFO5QVfWKVf2dS43fHGB/+6WDfFaxRAVtImooOC6a/ACDG
	 qhn+9jDft4ruh+5mAI8dKw7EZ05SXoNeTIDxDmgs=
Date: Sat, 18 Apr 2026 00:49:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs.patch removed from -mm tree
Message-Id: <20260418074943.56730C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: prevent lruvec release in lru_gen_clear_refs()
has been removed from the -mm tree.  Its filename was
     mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Thu, 5 Mar 2026 19:52:39 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  So an lruvec returned by folio_lruvec() could be released without
the rcu read lock or a reference to its memory cgroup.

In the current patch, the rcu read lock is employed to safeguard against
the release of the lruvec in lru_gen_clear_refs().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/986cd26227191a48a7c34a2a15812d361f4ebd53.1772711148.git.zhengqi.arch@bytedance.com
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

 mm/swap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/swap.c~mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs
+++ a/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct foli
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


