Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15287337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498505; cv=none; b=UGwPkcHwre/CdMxm/8qIuo5KDcKVzUGxfMhyC6GDH/5DK2ll3U5Y221brzzgDtbh9PmuS+apda97eyKx8EwHm6K5GmbOZa+aZJD5MRLUW6pKyL14blEpPusggmMtwnB2rm6iu6X52ckXsrwX9U1DACwt1q+sF5WQ7fZdLOJyU1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498505; c=relaxed/simple;
	bh=jLxisUSY+Lkxbty8mpms8pyxEzYc9H6a8WRuoOBKX2c=;
	h=Date:To:From:Subject:Message-Id; b=PRkx7zxuuz3Thk5QwXizJsqpoYf/L0ecSpViBPB0Wqiy28g87uRWfR0KGz0IRi7K1xgsYYpoxABM/5hYEMqIz4ZPbrUz8ANXCrYQTxsuh8ttj8870AIkf9CKbyHQ7h5Z+pf8b7/cXfAbFjE9JGfX+wkWKnv5kyadr+4PjLhW+b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eTr+II0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTr+II0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E49C19424;
	Sat, 18 Apr 2026 07:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498504;
	bh=jLxisUSY+Lkxbty8mpms8pyxEzYc9H6a8WRuoOBKX2c=;
	h=Date:To:From:Subject:From;
	b=eTr+II0NmrdjfP4PFIXq+v/CwL7AHl9KhgiapigG+6mIUgYHyN4szDpeShrbKf8wP
	 eJxjGpaupIj2HmhmhAqQiUl0kSRIxlHdmNpktH3zIulPb0De4xMuLRO0JkkSaP/6EO
	 3TIsg+/1I//z32RFw44aA6yK0Zv3s7Ci85x3yDzg=
Date: Sat, 18 Apr 2026 00:48:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers.patch removed from -mm tree
Message-Id: <20260418074823.A8E49C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: prevent memory cgroup release in folio_alloc_buffers()
has been removed from the -mm tree.  Its filename was
     buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Thu, 5 Mar 2026 19:52:27 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the function get_mem_cgroup_from_folio() is employed
to safeguard against the release of the memory cgroup.  This serves as a
preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/d6d48fdcf329c549373ac0a1c80fd9f38067e34e.1772711148.git.zhengqi.arch@bytedance.com
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

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/buffer.c~buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers
+++ a/fs/buffer.c
@@ -922,8 +922,7 @@ struct buffer_head *folio_alloc_buffers(
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -944,6 +943,7 @@ struct buffer_head *folio_alloc_buffers(
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


