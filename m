Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110213624A8
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498570; cv=none; b=TCxgEj0110f0J5iX6QgTd5UscFJz9QKPZV7Ry0nk59Og+nKHoYClJsNhMggAY1TfJV4HXA2OkQuYXNZ+XsTfqtMqTSQFAcLR8fCHtusY9VlZCwI8c2yjjMee7lLoObAg4n1KkIdiDDS3Atob+UveptQfJFStSVRFITr0SQ67Gv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498570; c=relaxed/simple;
	bh=9hAX3uQZ4aAovtopPp1IkUUjVV/vCOk1HhS4PrSNeSo=;
	h=Date:To:From:Subject:Message-Id; b=EfujlAVdEZnffgqVyOaqnGZ3XfYthdX8Sr+rWicZvKikMhnmvxK06Rsti/X79JR9CofL/lGjZkoikaQK6xCrczfFiszMOk3EvOb+fHpLX88v1UfB3GaegBmwa2W5kVC6rP3jwa8nwJvCwVEjzhi6NmU041nrPimmv+Eek3mAa4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEaAe/lK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEaAe/lK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4572C19424;
	Sat, 18 Apr 2026 07:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498569;
	bh=9hAX3uQZ4aAovtopPp1IkUUjVV/vCOk1HhS4PrSNeSo=;
	h=Date:To:From:Subject:From;
	b=QEaAe/lKv6P2T9cKElwgYma9/XR5lPhvez+YRDJRy/+C17T2nVk2pvkwROC0r+Fmc
	 CfXf0oDceahMmVQwjZ4KZvqRv/OUROBpxtHousjS9yl1bnD6Hf3zckozezo54XbNzh
	 H28xXebAYfW2YgPyP2ZnuFAxug430TlLTbc82JnM=
Date: Sat, 18 Apr 2026 00:49:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-prevent-lruvec-release-in-workingset_refault.patch removed from -mm tree
Message-Id: <20260418074928.E4572C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: prevent lruvec release in workingset_refault()
has been removed from the -mm tree.  Its filename was
     mm-workingset-prevent-lruvec-release-in-workingset_refault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: workingset: prevent lruvec release in workingset_refault()
Date: Thu, 5 Mar 2026 19:52:37 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  So an lruvec returned by folio_lruvec() could be released without
the rcu read lock or a reference to its memory cgroup.

In the current patch, the rcu read lock is employed to safeguard against
the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/e3a8c19a9b18422b43213f6c89c451c5b6ca1577.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/workingset.c~mm-workingset-prevent-lruvec-release-in-workingset_refault
+++ a/mm/workingset.c
@@ -546,6 +546,7 @@ bool workingset_test_recent(void *shadow
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -567,11 +568,12 @@ void workingset_refault(struct folio *fo
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	lruvec = folio_lruvec(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -587,6 +589,8 @@ void workingset_refault(struct folio *fo
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	mem_cgroup_put(memcg);
 }
 
 /**
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


