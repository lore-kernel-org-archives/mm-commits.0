Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC22AC8CE
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987019; cv=none; b=di/rmCixuJprMszZBnmgh9rdsa9XgeU1CrzrWC1fOLFRhtq2x3+M8xx/qWrUJBrETgZ9BVIQztbukvLhoWHL6hpu3qtwhIe8hZaSZPBQQxyBB5gTVxAOxsn47XH9B7wmZsu0JxZGILiu2hXvxCOwTvMvF10Zx+0FAkMYN3V8wKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987019; c=relaxed/simple;
	bh=AsxFbGPHRSezRMZcT0N8cSk4VpiNH2cZlm7VENR4AEo=;
	h=Date:To:From:Subject:Message-Id; b=E1an/BONyZqo1bYCoC5OTLBdgaUjZnPmO17elPteZqymamJlROtNYll8rBz2qMdCWC+E6bMaMe5Njgpbu2bDgwu9/ZPp3Zv11FZdcZCmJrXScg4BqrcUbsucK0E5W/FVtML6XpHpd1t3DR0rXkfGFAug54ZpdrhkO3myeqDKuYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmkcf5m5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmkcf5m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F432C4CEE9;
	Mon,  7 Apr 2025 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987019;
	bh=AsxFbGPHRSezRMZcT0N8cSk4VpiNH2cZlm7VENR4AEo=;
	h=Date:To:From:Subject:From;
	b=gmkcf5m54jfJdWq2nuC25rT+h79G8tp2v31mqSKzCuRgT23hOl6Lp0pPT6fpP40x1
	 iBDFJG/KCwtH2EgwozIILST5tq/bAxMYMxBJPq4eK5vMnpWEycBoL36yVK8DVluj68
	 ojMLBx3aECPy2H4Gf6BQhR80VNoY9Oxd0GD6O0t8=
Date: Sun, 06 Apr 2025 17:50:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-no-refilling-stock-from-obj_cgroup_release.patch added to mm-new branch
Message-Id: <20250407005019.4F432C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: no refilling stock from obj_cgroup_release
has been added to the -mm mm-new branch.  Its filename is
     memcg-no-refilling-stock-from-obj_cgroup_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-no-refilling-stock-from-obj_cgroup_release.patch

This patch will later appear in the mm-new branch at
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

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch

