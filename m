Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1731C695
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498463; cv=none; b=pwkF/5hEp3DnjWafg5CrczbdSL0ZIkX/dXaCZPPDf1d9jd7Djk7q1HGnM1JADJIE9nC8nNZMwwGzuRzu89I2mb7pK4Y7Iwt0/a8tkBYYXwffUfrfaRhHqGhmdE2zJglv7sAQU3foPJ0nB3Cr2Wt8yNYy6EbNEF7KufvfaULMr5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498463; c=relaxed/simple;
	bh=JQhZec5bsqPfKOL2YClguj03LTBnZ+FVd6UZshiEu/I=;
	h=Date:To:From:Subject:Message-Id; b=MHXg82xaaeqgYB4vPeGyedRjRKKZzQOtW7SeZ7OeXDa8IBc18c0aPzSHTtnjhaA6BMDTWoiCUFs6IBqw7sORhGl9R394U9hANOoXyClufFfU6iuX1KC93q/rdsjXoGQPEnB1RicIClwA99Wowm7Q1kM4CMVbsCCjLZt+bBmrZac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TsCnuR2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TsCnuR2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6254FC19424;
	Sat, 18 Apr 2026 07:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498463;
	bh=JQhZec5bsqPfKOL2YClguj03LTBnZ+FVd6UZshiEu/I=;
	h=Date:To:From:Subject:From;
	b=TsCnuR2xOvz+EoTVrtQdgEkaS8mAGjiacIfdatLNpEW6TViK+k98VFfE6sS5DlUmK
	 Rezagxe3Xw/8qkx2x/iMf3C1/5nNcr8ryBZ15EHERehuC/Qq3oJHL9ugG9d0ip4Zgm
	 OtKYhnLoESbVoK7jMeaQXWvApQYvgilQMTweEj1E=
Date: Sat, 18 Apr 2026 00:47:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-use-folio_lruvec-in-workingset_refault.patch removed from -mm tree
Message-Id: <20260418074742.6254FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: use folio_lruvec() in workingset_refault()
has been removed from the -mm tree.  Its filename was
     mm-workingset-use-folio_lruvec-in-workingset_refault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: workingset: use folio_lruvec() in workingset_refault()
Date: Thu, 5 Mar 2026 19:52:20 +0800

Use folio_lruvec() to simplify the code.

Link: https://lore.kernel.org/11bd2fbbf082f4f7972a1113ca42a61fbe2876a9.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
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

 mm/workingset.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/workingset.c~mm-workingset-use-folio_lruvec-in-workingset_refault
+++ a/mm/workingset.c
@@ -541,8 +541,6 @@ bool workingset_test_recent(void *shadow
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
-	struct pglist_data *pgdat;
-	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -564,10 +562,7 @@ void workingset_refault(struct folio *fo
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	memcg = folio_memcg(folio);
-	pgdat = folio_pgdat(folio);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
+	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


