Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE6D34CFD1
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498559; cv=none; b=LUjsNMHUpeOy7zIPgy+jQxeKv0/I1jv53J2xbfsFW/l0oVKBYJ9XOur5ejutMajIDtcQ455XJMmt5gj89wrWkhVGifrNaIQkcSK/v/t80oFnySbmuO5knB5tqmboM30c8JTYxMvnNtyUGf7LuEsmlmjnEACHlWuRC1obEXwPYWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498559; c=relaxed/simple;
	bh=Avn3PqPsLPVDzPDdGcdgpjnPKuMbAZNIcCB7TyTlXss=;
	h=Date:To:From:Subject:Message-Id; b=F2KXvZq1V8mSd0aHrCGeV7MiyBxBiI5WuamXxA/H8Rzn9aG4Lj5V0EP6aS7X6daByLG7xbb3ms3+3/oxoF83YeAyz7Ltk1rO7MKkcvOxrDndjtHkQeaJ//dtcn/CtV1yRdl6ZP6L/sNJIwKIkZp8w6ffLksFT1Vl05UfqV6lyU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlBr845H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlBr845H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044E0C19424;
	Sat, 18 Apr 2026 07:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498558;
	bh=Avn3PqPsLPVDzPDdGcdgpjnPKuMbAZNIcCB7TyTlXss=;
	h=Date:To:From:Subject:From;
	b=DlBr845HHk6HtY/Ca52FohTZgOV6qSvvQAzRRi2zqWA92cBcX8b0iupBpGGc23mh6
	 Jj0Cczwz2QQX7jdXQAjFw/9O1Lopab/2g9sd3u0jDFZqyAyD1XriNH4tmyQPYFj4eG
	 V8pTbPGT2kSEBZqxoUUKS20kRCdEPpTM0MnYiVUI=
Date: Sat, 18 Apr 2026 00:49:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch removed from -mm tree
Message-Id: <20260418074918.044E0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
has been removed from the -mm tree.  Its filename was
     mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Thu, 5 Mar 2026 19:52:35 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Link: https://lore.kernel.org/ca2957c0df1126b2c71b40c738018fd5255525a6.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
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
Cc: Muchun Song <songmuchun@bytedance.com>
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

 mm/huge_memory.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave
+++ a/mm/huge_memory.c
@@ -1218,13 +1218,29 @@ retry:
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	/*
+	 * The memcg destruction path is acquiring the split queue lock for
+	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
+	 */
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


