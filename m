Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253C17579
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723251196; cv=none; b=VqVnUxdjcR9AzSWC0Z6h/s6UAjgqgSL3BHZHKRYZM1Vf3WmVWXhyRjTDEClVeOy185ThKYRuO89S9moPA0IvhYGZXbl24EwhxAGqwhMzYIOgjEChDOEz9O2Lmq7muOdB0yBAAaENowWXlT9h+us6s/O8sPQLCGJr2ARP8q95HAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723251196; c=relaxed/simple;
	bh=Nf2X+znJdizYcmiZFXmwVAUZnRrYrBYyw8zvBg9601I=;
	h=Date:To:From:Subject:Message-Id; b=rNm82atW6tTr2U2pMUr1qilFcY6a/7LTDrHhH/Td+1CcBDn/NHhAUiphyMwcJENeisvQZSI3qA7zlUsjf3mEmXM0lA8zCCSEpcz3/HIfFQnfKTJNSKPuwW5vT8lhhw2So6H/TZa4IMe1VdxFfq9/mIINUetPBadeVcFkiGz6slo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sfxgkzs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sfxgkzs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D53AC32782;
	Sat, 10 Aug 2024 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723251195;
	bh=Nf2X+znJdizYcmiZFXmwVAUZnRrYrBYyw8zvBg9601I=;
	h=Date:To:From:Subject:From;
	b=sfxgkzs9fiD9609DVp/rnJA1MokuSth7xKlXKUO4AstEhhcz9fzqr6M6jCERwBDod
	 gJ80AjIjENfRnRIGdrA23UoloQO/QEGgheYu+MO7aMtQa7iqK6VS9lvpzrUJjfPJ4H
	 JLV2Ib9Wz+ggK7f6e0ojtEb4VSoM0pkitWWWLC94=
Date: Fri, 09 Aug 2024 17:53:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-replace-memcg-id-idr-with-xarray.patch added to mm-unstable branch
Message-Id: <20240810005315.7D53AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: replace memcg ID idr with xarray
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-replace-memcg-id-idr-with-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-replace-memcg-id-idr-with-xarray.patch

This patch will later appear in the mm-unstable branch at
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
Subject: memcg: replace memcg ID idr with xarray
Date: Fri, 9 Aug 2024 10:26:18 -0700

At the moment memcg IDs are managed through IDR which requires external
synchronization mechanisms and makes the allocation code a bit awkward. 
Let's switch to xarray and make the code simpler.

Link: https://lkml.kernel.org/r/20240809172618.2946790-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-memcg-id-idr-with-xarray
+++ a/mm/memcontrol.c
@@ -3395,29 +3395,12 @@ static void memcg_wb_domain_size_changed
  */
 
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
-static DEFINE_IDR(mem_cgroup_idr);
-static DEFINE_SPINLOCK(memcg_idr_lock);
-
-static int mem_cgroup_alloc_id(void)
-{
-	int ret;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&memcg_idr_lock);
-	ret = idr_alloc(&mem_cgroup_idr, NULL, 1, MEM_CGROUP_ID_MAX + 1,
-			GFP_NOWAIT);
-	spin_unlock(&memcg_idr_lock);
-	idr_preload_end();
-	return ret;
-}
+static DEFINE_XARRAY_ALLOC1(mem_cgroup_ids);
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->id.id > 0) {
-		spin_lock(&memcg_idr_lock);
-		idr_remove(&mem_cgroup_idr, memcg->id.id);
-		spin_unlock(&memcg_idr_lock);
-
+		xa_erase(&mem_cgroup_ids, memcg->id.id);
 		memcg->id.id = 0;
 	}
 }
@@ -3452,7 +3435,7 @@ static inline void mem_cgroup_id_put(str
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return idr_find(&mem_cgroup_idr, id);
+	return xa_load(&mem_cgroup_ids, id);
 }
 
 #ifdef CONFIG_SHRINKER_DEBUG
@@ -3551,11 +3534,10 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg)
 		return ERR_PTR(error);
 
-	memcg->id.id = mem_cgroup_alloc_id();
-	if (memcg->id.id < 0) {
-		error = memcg->id.id;
+	error = xa_alloc(&mem_cgroup_ids, &memcg->id.id, NULL,
+			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
+	if (error)
 		goto fail;
-	}
 
 	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats),
 				 GFP_KERNEL_ACCOUNT);
@@ -3696,9 +3678,7 @@ static int mem_cgroup_css_online(struct
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	spin_lock(&memcg_idr_lock);
-	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
-	spin_unlock(&memcg_idr_lock);
+	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
 offline_kmem:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch

