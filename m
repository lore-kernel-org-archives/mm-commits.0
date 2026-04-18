Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC807337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498564; cv=none; b=M1nvwhN2DG1Gmi7SIFIO+uc8JQQ8IjX6SSegpoPw9rXlYhUwRuQRe94vys3frvr63OVxawggHg0VFlTgYc0FPf+jF0gPL5OTMeruGi6CQuCWDAN5SN3C1RaOqxKB8DxkifoaZ4rHJvmvi2kTtBNL7TCEa9q8vodRVocwnmtEdno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498564; c=relaxed/simple;
	bh=RaqAHHHOpjOHMia/v2gBjVxImKukGdhDv/C7iA5D5B0=;
	h=Date:To:From:Subject:Message-Id; b=rmAOPxHaohBHQUGWqtQZSXF/URXTsPXqjx9KeQUntj3P5xp/U5MECHDEbRF71NSZmzqKAC7DrN6GfsVimT3QtljIgUxzbOG6Aiavib5zEG+bfjVF8V4hlglqvX2tjWcAG1ExVtvzb2Myi7DuZBEFS6NaqU5Msz2vaRpX6KjXX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DS8IgAfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DS8IgAfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9879EC19424;
	Sat, 18 Apr 2026 07:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498564;
	bh=RaqAHHHOpjOHMia/v2gBjVxImKukGdhDv/C7iA5D5B0=;
	h=Date:To:From:Subject:From;
	b=DS8IgAfoXIm+92oWliE4MRLXPnL5EIEeHFEpjm1PO4ySp2refqxLsjw6J0XkLRrHc
	 FGzw4dhErvtAfYDpWHFC8dcK/F9TCenMsXRMyrZyu9Y/fJKl9WQYUNCzF+ubsg9YeZ
	 CRlMZmKhD8PyQ/E6HiYewP0L3O9iij/WjPAqPvWI=
Date: Sat, 18 Apr 2026 00:49:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch removed from -mm tree
Message-Id: <20260418074923.9879EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: prevent memory cgroup release in zswap_compress()
has been removed from the -mm tree.  Its filename was
     mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Thu, 5 Mar 2026 19:52:36 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in zswap_compress().

Link: https://lore.kernel.org/340f315050fb8a67caaf01b4836d4f38a41cf1a8.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
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

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-prevent-memory-cgroup-release-in-zswap_compress
+++ a/mm/zswap.c
@@ -893,11 +893,14 @@ static bool zswap_compress(struct page *
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
+			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
+		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


