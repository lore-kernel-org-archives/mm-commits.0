Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81031553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011023; cv=none; b=OxgQMf2SGRt0uivZ6ve/OjcmatA6dq0YnMuRk7dru01Mx0HoTUoEc7XG+JEzERJslYXtoYYM6XU1T4WR7TSQ0yCHg571IU9tfqwBozSNkyalIUM+m1BSRctzEa/VfkeZwsdEaq8c4IQKqvG7fN2+EdgyfStN+HXewQtN9nYP/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011023; c=relaxed/simple;
	bh=NpEMd0W07KmQ0WBdQxOt2FjaCHh1Wcjlj9tgiX9u7Uw=;
	h=Date:To:From:Subject:Message-Id; b=Nlc6NZICKYs08p0SGPhZzaDMUvWbqcY/Q1AWM3v6v9s+8oOr3O3mk5RxS9vU9/NSF54ygcJHCCU4wXOYmphYpYLhku2kiNvXNENhugF6mirmnsM0j2OgWLDsZHXoBFqUz5BAagavFobZTJAZWeAWmquoMVaB2jYZ3HE6vo1zPhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6vgSWrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6vgSWrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA51C4CEE4;
	Mon, 12 May 2025 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011023;
	bh=NpEMd0W07KmQ0WBdQxOt2FjaCHh1Wcjlj9tgiX9u7Uw=;
	h=Date:To:From:Subject:From;
	b=K6vgSWrnLnvHr8Kplf7rNomnd6usviyOSNV4l/72YdzCyc9DUikRX8euPJU9v52Wz
	 ddUHmlyRGSWk9eyfmatinvREPornQ7HFJIECh15l+JwUBUojHY3hwSGMgBV0j0Q5bh
	 BbK3iAUapEWvkfnPQ9DxXOO+cXKG9rYvOexv9Ss4=
Date: Sun, 11 May 2025 17:50:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-no-refilling-stock-from-obj_cgroup_release.patch removed from -mm tree
Message-Id: <20250512005023.8AA51C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: no refilling stock from obj_cgroup_release
has been removed from the -mm tree.  Its filename was
     memcg-no-refilling-stock-from-obj_cgroup_release.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: no refilling stock from obj_cgroup_release
Date: Thu, 3 Apr 2025 18:39:09 -0700

obj_cgroup_release is called when all the references to the objcg have
been released i.e.  no more memory objects are pointing to it.  Most
probably objcg->memcg will be pointing to some ancestor memcg.  In
obj_cgroup_release(), the kernel calls obj_cgroup_uncharge_pages() which
refills the local stock.

There is no need to refill the local stock with some ancestor memcg and
flush the local stock.  Let's decouple obj_cgroup_release() from the local
stock by uncharging instead of refilling.  One additional benefit of this
change is that it removes the requirement to only call obj_cgroup_put()
outside of local_lock.

Link: https://lkml.kernel.org/r/20250404013913.1663035-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~memcg-no-refilling-stock-from-obj_cgroup_release
+++ a/mm/memcontrol.c
@@ -129,8 +129,7 @@ bool mem_cgroup_kmem_disabled(void)
 	return cgroup_memory_nokmem;
 }
 
-static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
-				      unsigned int nr_pages);
+static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -163,8 +162,16 @@ static void obj_cgroup_release(struct pe
 	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
-	if (nr_pages)
-		obj_cgroup_uncharge_pages(objcg, nr_pages);
+	if (nr_pages) {
+		struct mem_cgroup *memcg;
+
+		memcg = get_mem_cgroup_from_objcg(objcg);
+		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+		memcg1_account_kmem(memcg, -nr_pages);
+		if (!mem_cgroup_is_root(memcg))
+			memcg_uncharge(memcg, nr_pages);
+		mem_cgroup_put(memcg);
+	}
 
 	spin_lock_irqsave(&objcg_lock, flags);
 	list_del(&objcg->list);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

