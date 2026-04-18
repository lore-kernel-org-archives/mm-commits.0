Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD7E25CC74
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498684; cv=none; b=LOcIoHbWSPNfpXOSSKE+k6pyH5WEektFXMH1w2H6xSLirfTj2bGPR9Jkkxbn2vUwydZ3SJ9AfQkSOgHeg344AWtBNynE/soeZGPThZuZ+QNIRRbFOmHXZBllutyaaktJjpdWJhaGijK1lSNxWbtlcC3YSWU3BWgnOe1f8N8JzYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498684; c=relaxed/simple;
	bh=4JEC8UEzF5Jj++XH0yEXRJDK5DL18/JQRXA7S6HN23M=;
	h=Date:To:From:Subject:Message-Id; b=DMtMxdPoPLkPMk7z/BUapJv0E/VRmFyT52THtL0DavtI5WKEgQM+9cVgreOq4T2Ms5Yp8LfJ36G3oi36UFTbWUj0rHjzSUZQg/y9jcrEt2F7QZnGbWqTHJLPSEuYRQ9UrINtxpjPbM6HOYzfO5WPVlv1z0+2JPrYkbuZ+xMHGTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pg40smHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pg40smHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1749C19424;
	Sat, 18 Apr 2026 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498684;
	bh=4JEC8UEzF5Jj++XH0yEXRJDK5DL18/JQRXA7S6HN23M=;
	h=Date:To:From:Subject:From;
	b=Pg40smHgsrLfsLRfpFsx5VJdSkioof9tA9OZrQMXcdGHB02PXl8EG6jQf/RCfEPN0
	 D0+Yj8OrBxBjaQ/lCozd5Yjth5HiFQ+hj0MfoZqD4jbUnuhOtYmccMDJSzM8Myr8E5
	 cNt8cDMIUwCuOYpp1v/2nz9SeYWp+sfIkLzEIU9M=
Date: Sat, 18 Apr 2026 00:51:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch removed from -mm tree
Message-Id: <20260418075123.A1749C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
Date: Fri, 27 Mar 2026 18:16:30 +0800

The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
count.  During the reparenting of LRU folios, the value passed to it can
potentially exceed the maximum value of a 32-bit integer.  It should be
declared as long instead of int to match the types used in lruvec size
accounting and to prevent possible overflow.

Update the parameter type to long to ensure correctness.

Link: https://lore.kernel.org/fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size
+++ a/include/linux/memcontrol.h
@@ -878,7 +878,7 @@ static inline bool mem_cgroup_online(str
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int zid, int nr_pages);
+		int zid, long nr_pages);
 
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size
+++ a/mm/memcontrol.c
@@ -1472,7 +1472,7 @@ retry:
  * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int zid, int nr_pages)
+				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
@@ -1489,7 +1489,7 @@ void mem_cgroup_update_lru_size(struct l
 
 	size = *lru_size;
 	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %d): lru_size %ld\n",
+		"%s(%p, %d, %ld): lru_size %ld\n",
 		__func__, lruvec, lru, nr_pages, size)) {
 		VM_BUG_ON(1);
 		*lru_size = 0;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


