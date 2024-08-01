Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964F140E5F;
	Thu,  1 Aug 2024 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722541155; cv=none; b=IqQP1fPx8swSk111MN4IgSPthpv6iQKziP9aPitXnJ1RJGnvg4DKeiXonK93p0QWDe/dePkPYJtaxLajXj6ndJoEGTa7Pqp2mlOpvizyyFdUZqeNK0tKIuYTOTmdtq0aAJ3XyUj5s9IhHSuNETAEyx+mUBYBn77SPJpaJB7HgEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722541155; c=relaxed/simple;
	bh=9ERZPVIoREyolJnOrNuN4w+ujpvZ4J4LyAgluCe135M=;
	h=Date:To:From:Subject:Message-Id; b=Cl2U8Wblatmq9iU/Pu3c4HSePIbWEs6y/SxVv8PtDpPiKjFdqS3jIbS09KHf4aG7XvuyjFs23HbGEba0mSLPP1ADGfw4JcJaPqbqZq+HJEQP74d49tKv9fHqTBUqJy/pG7cgmlnGqXjOagEtFAua7oHedKjo5SrDQ+b4x1vXoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhDRvhFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhDRvhFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AD2C32786;
	Thu,  1 Aug 2024 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722541155;
	bh=9ERZPVIoREyolJnOrNuN4w+ujpvZ4J4LyAgluCe135M=;
	h=Date:To:From:Subject:From;
	b=BhDRvhFEIlQSFKrDD6VscDdC14PZZpCPF6H2dy0WTTTl+suKon3uVx0tMPFCEcXxC
	 akPHsbpNKNsGxs43RbKGLjkC/xjjhlneXcHXHdV03WB23+on9HJTL04qgaS1CcZHG/
	 wuQKHkPZaJfDIChhfILHi8jS1LUcufgS/hnwpAVo=
Date: Thu, 01 Aug 2024 12:39:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240801193915.29AD2C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-list_lru-fix-uaf-for-memory-cgroup-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-list_lru-fix-uaf-for-memory-cgroup-v2
Date: Thu, 1 Aug 2024 10:46:03 +0800

only grab rcu lock when necessary, per Vlastimil

Link: https://lkml.kernel.org/r/20240801024603.1865-1-songmuchun@bytedance.com
Fixes: 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node selection")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-uaf-for-memory-cgroup-v2
+++ a/mm/list_lru.c
@@ -112,12 +112,14 @@ bool list_lru_add_obj(struct list_lru *l
 {
 	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
-	ret = list_lru_add(lru, item, nid, memcg);
-	rcu_read_unlock();
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_add(lru, item, nid, NULL);
+	}
 
 	return ret;
 }
@@ -148,12 +150,14 @@ bool list_lru_del_obj(struct list_lru *l
 {
 	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
-	ret = list_lru_del(lru, item, nid, memcg);
-	rcu_read_unlock();
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_del(lru, item, nid, NULL);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-fix-uaf-for-memory-cgroup.patch
mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch
mm-kmem-remove-mem_cgroup_from_obj.patch

