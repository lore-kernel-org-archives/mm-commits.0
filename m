Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8C282EE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247009; cv=none; b=nS7cALutG7sLIlWyJKsp0RrQxja2TmQLejAAnHVyHvdgMZcR4iHqUdEegeH3hc/GJ0LDTGYNGCvhrDmp+RTnX6m9fHPubgGJnKocjA4CPLQB2ZZYf+mLwevZOdO7lXonOr9Jp3ObNGjHOOsE9G34hQhgQrSd3a9AKB4JtrMrhEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247009; c=relaxed/simple;
	bh=ZBILbcRL5UkQAP3ICeQks81e3Fnpf+ECvEXIdUuhJew=;
	h=Date:To:From:Subject:Message-Id; b=frQhfxB/61n/sw+Z9DRoypnzwqsS3XaYWsYYsTv4ijU45F2LJZ/MuxXA41a1li9RrToMBvRE/UsztjInsRCYf/FZW6CyMi3X4boXHcQub1S/hpLJPi9apJqiUef/ESC/kEf+ZMUTyfXkFuYPNU5z8Pc1P1vLU7nytOxBHa+GqPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fnWQssvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fnWQssvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB49C4CEC3;
	Mon,  2 Sep 2024 03:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247008;
	bh=ZBILbcRL5UkQAP3ICeQks81e3Fnpf+ECvEXIdUuhJew=;
	h=Date:To:From:Subject:From;
	b=fnWQssvZnd6h77S2YecilK0RZFViVICbc8VzzEd4jgxtRuYNOv/VS6Xu4ubEX88O1
	 k/byyA86Ub7CEfHx+nMWRiELdi2h7SlJ1Ssni1SzQAXqGsqchz0bQgy7I/9jnZAlrG
	 usE4lT5NxIr6mOUFAn25V7EyMaJW6z1nJwuMddYc=
Date: Sun, 01 Sep 2024 20:16:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch removed from -mm tree
Message-Id: <20240902031648.8BB49C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmem: fix split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch

This patch was dropped because it was folded into mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kmem: fix split_page_memcg()
Date: Mon, 19 Aug 2024 16:04:15 +0800

split_page_memcg() does not care about the returned memcg for kmem
pages, so folio_memcg_charged() should be used, otherwise obj_cgroup_memcg
will complain about this.

Link: https://lkml.kernel.org/r/20240819080415.44964-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: syzbot+ef4ecf7b6bdc4157bfa4@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000006f7e4d0620042b96@google.com
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix
+++ a/mm/memcontrol.c
@@ -3035,12 +3035,11 @@ void __memcg_slab_free_hook(struct kmem_
 void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 	struct folio *folio = page_folio(head);
-	struct mem_cgroup *memcg = folio_memcg(folio);
 	int i;
 	unsigned int old_nr = 1 << old_order;
 	unsigned int new_nr = 1 << new_order;
 
-	if (mem_cgroup_disabled() || !memcg)
+	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
 
 	for (i = new_nr; i < old_nr; i += new_nr)
@@ -3049,7 +3048,7 @@ void split_page_memcg(struct page *head,
 	if (folio_memcg_kmem(folio))
 		obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
 	else
-		css_get_many(&memcg->css, old_nr / new_nr - 1);
+		css_get_many(&folio_memcg(folio)->css, old_nr / new_nr - 1);
 }
 
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kmem-remove-mem_cgroup_from_obj.patch
mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch

