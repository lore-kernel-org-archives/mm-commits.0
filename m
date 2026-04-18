Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5160337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498576; cv=none; b=ULjg1NxKOA6xRI/K7D5FFFfVAfEIP8Zo5Uy7jHE1x7ibo37Jok0x5osYvu0MP60gx5NdjVkeegetompYGBBN8M/1GarkN9sH2Q6rC+RYlwT0YJnbtlVIQFjbEC60TWMmuwGgcpWGQVzBgyKMYhpbfm6DvCEQ2GVHuM5aS3Bds7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498576; c=relaxed/simple;
	bh=6bew7yLijDvSltF2CPeCKTQ4RAkY5FhpmkVeiCgxX40=;
	h=Date:To:From:Subject:Message-Id; b=eSGRqWDbPeFStToEN9TQ03zQbrx7/5vblHtE22h6L2Ck/D16k69upWF8s/zCcN1T4ABSe04VTtxMnJMyEgtUHkT9FhjUJrWtq+wSznS6dbaN7OEgitPZhPs+/FN+YnspXfXDlkcZSz5Rn+tr9A6dehoEvUSQTCU0TsI5Og7qL3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2aBsnY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2aBsnY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830DC19424;
	Sat, 18 Apr 2026 07:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498576;
	bh=6bew7yLijDvSltF2CPeCKTQ4RAkY5FhpmkVeiCgxX40=;
	h=Date:To:From:Subject:From;
	b=o2aBsnY7Ex/mnXGgL9SExET9bIDD8o71mQQoLPXUoHHKBsOq6NxzdDXJhnARY7aRh
	 dGxLBn+EZgHTj0FY3h77oQ3OujmzIGkDRGawVpmfKXLE5d7FU+tPz10kZYjsW6bNju
	 QSumwUgExbsJnZqulvfB6OSJ9jvTNWwFZx8wtVIc=
Date: Sat, 18 Apr 2026 00:49:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin.patch removed from -mm tree
Message-Id: <20260418074935.A830DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: prevent lruvec release in zswap_folio_swapin()
has been removed from the -mm tree.  Its filename was
     mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Thu, 5 Mar 2026 19:52:38 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  So an lruvec returned by folio_lruvec() could be released without
the rcu read lock or a reference to its memory cgroup.

In the current patch, the rcu read lock is employed to safeguard against
the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/02b3f76ee8d1132f69ac5baaedce38fb82b09a48.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
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

 mm/zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zswap.c~mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin
+++ a/mm/zswap.c
@@ -664,8 +664,10 @@ void zswap_folio_swapin(struct folio *fo
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


