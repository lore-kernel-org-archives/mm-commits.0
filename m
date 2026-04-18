Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E9337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498531; cv=none; b=NsSQ9SM60HTX9AmhNd5sJX+MBQiQFWDtYQDMGA8d4m/QFyin9Bh/VuamTaZE21fT3rVAFVMZlWng1VfnK87B0OzWY91YhKXLhkwLK5CeFsroLkcyZt4+v5M3SM5OLd6yPBXyvrq3+WHWtYLeNVjDnhKFpCfIenxJpxbEi38A+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498531; c=relaxed/simple;
	bh=UJlbSTlymouB/zNd4wh7Jah9bnTH0MU2LkeI+zju3fI=;
	h=Date:To:From:Subject:Message-Id; b=oxz5Pa7vhyRbNLAd6taYRE6fy+JNRnGJfbqCZK6yae5KftWNmPavMEaX5wiDVf1KuHPAqFy8aqmOXqDcieDjFwfZE7Zw17O0bYrr6SMEDMnE6/fSiugoqj0ComX/F6z900GMNsFLNUMvBkvwoj3Q4eZKOXYBI4fOyZVDvbGltYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lG/4jyZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lG/4jyZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD397C19424;
	Sat, 18 Apr 2026 07:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498531;
	bh=UJlbSTlymouB/zNd4wh7Jah9bnTH0MU2LkeI+zju3fI=;
	h=Date:To:From:Subject:From;
	b=lG/4jyZub8zu3X+YAC3Jxff5ITvbHWnTB4JC1GzKsfD4J4XgRSUMll1i32sA3+Gpz
	 27EcAIbMXli7vYqDVkPLqcKIvhR3QvYrwgK2CveEu6HFNugOHxdFnHsyqb9xkOJMkh
	 QvKpIybRQvRLbRQQ7Qq2oDjLket7PIyr7JPgHXE0=
Date: Sat, 18 Apr 2026 00:48:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping.patch removed from -mm tree
Message-Id: <20260418074849.BD397C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
has been removed from the -mm tree.  Its filename was
     mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Thu, 5 Mar 2026 19:52:31 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In __folio_migrate_mapping(), the rcu read lock is employed to safeguard
against the release of the memory cgroup in folio_migrate_mapping().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/0f156c2f1188f256855617953f8305f43e066065.1772711148.git.zhengqi.arch@bytedance.com
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

 mm/migrate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/migrate.c~mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping
+++ a/mm/migrate.c
@@ -672,6 +672,7 @@ static int __folio_migrate_mapping(struc
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -699,6 +700,7 @@ static int __folio_migrate_mapping(struc
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


