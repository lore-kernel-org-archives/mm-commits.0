Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F75135AC3E
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498591; cv=none; b=HlKtNhIMj8FwLePg0BnxlCSsiJysrf3zxiqm/1irAfvUCRxP7o8IfMlxEo69jICZSrFf/reTcqkE9s8RPll9yV4rquQTwVT7rCI4tAOuoo4IP1Dg12JgwLSHLvVQs0HqrTe6tGA1XPu5f6QNJa3tnWhFhJJQ1ISDIg8gFLDzbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498591; c=relaxed/simple;
	bh=kQspx2z7CEAJDZDTg8IeALdAA/gcKVcC4wRMe5KFD6E=;
	h=Date:To:From:Subject:Message-Id; b=IHvW9/3FZ85Z2YRcHPvKIvP/buag+83ABNb5R5vZ/E045M65ObOFqFNOZ8iWV1d3STobCnyIaM7EFsV1Um+BKTbwnAurGqkbCxFDqVbE5HHaj9L70Arfr/Rzrh5LR7wy5OmhjJ6RtCJ9sxQb0/h6/jZ2PfQ/LidZn7RD0jk6zhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Esn1n0r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Esn1n0r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3152C19424;
	Sat, 18 Apr 2026 07:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498591;
	bh=kQspx2z7CEAJDZDTg8IeALdAA/gcKVcC4wRMe5KFD6E=;
	h=Date:To:From:Subject:From;
	b=Esn1n0r1i4jNfxFHrOvqs8wCJwq/JnhGHlNsL7yZapqCqM2go+I/FPuwhRhpj7nD6
	 kfpep2diSNowGLl5wDVMn+uwL49AW4nANXFCYCtfnaPuHErWAiO6g6j7sdRcItwCdW
	 XDUe2KATtXznDvMfTXDB3wk/XSXDSdHREqmATXNI=
Date: Sat, 18 Apr 2026 00:49:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-prevent-lruvec-release-in-workingset_activation.patch removed from -mm tree
Message-Id: <20260418074949.C3152C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: prevent lruvec release in workingset_activation()
has been removed from the -mm tree.  Its filename was
     mm-workingset-prevent-lruvec-release-in-workingset_activation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: workingset: prevent lruvec release in workingset_activation()
Date: Thu, 5 Mar 2026 19:52:40 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  So an lruvec returned by folio_lruvec() could be released without
the rcu read lock or a reference to its memory cgroup.

In the current patch, the rcu read lock is employed to safeguard against
the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/c6130476affbba0a7d309a887c3df11e0167990b.1772711148.git.zhengqi.arch@bytedance.com
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

 mm/workingset.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/workingset.c~mm-workingset-prevent-lruvec-release-in-workingset_activation
+++ a/mm/workingset.c
@@ -603,8 +603,11 @@ void workingset_activation(struct folio
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


