Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A13AEF22;
	Wed, 16 Sep 2026 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789522474; cv=none; b=cAn3DZ2DztDVuM4ra/+X65hL+AQAIoL9JzJRdwg9wQsoqOWe9065t3nuFfSDUl+OzUj4ulDMGHeLrG70ns6qLwEcFtn0sww0HvaQKbyiwAnBlilKerkVu13ZRudveP2D13Hpx8spr8fXQpjTPm3QKdBtozQtUnHZSZTSXpRjs6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789522474; c=relaxed/simple;
	bh=B87jgNhE0GBRu06KWV5iGaHebMD3P3PfKCmKFeF5s9k=;
	h=Date:To:From:Subject:Message-Id; b=BjXTMI9mEUadjk45q398ZO4JHDuAA+t3dY1qI3ksEa+bzeatVgjbOJaLIWJtrv/keYaPHbzOeNsBAuQKzu4T5x/ZYZ15YyIwfU/mD6h0eC62QDSGbLs2fh8szHzAkhNltLWnPEXQJRu6h9f0NBoN4YqnemgT2bttoXUkK+mn09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WP9le/TT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WP9le/TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C68E1F000FF;
	Wed, 16 Sep 2026 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789522464;
	bh=bRIvncnvkj/eMHS6w3A6vZYHFvMh7jh+T7BTFCUZq+4=;
	h=Date:To:From:Subject;
	b=WP9le/TTFVGmBf9W7wIb/uNyUQPVvyfmFnORKDwBeFDL5BgM3poU/Qr3p143CiuaZ
	 2+n5uxHgg4iyd28jJov2ysKp5eiz0hlS5/Ejh42/kZ/yliGdSKk/bkK5G6ktPWHZaS
	 z4dkPnqxCjw7EdIaNqyqcMK+4Pd5Os9LmR+VXvP8=
Date: Tue, 15 Sep 2026 18:34:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch removed from -mm tree
Message-Id: <20260916013424.0C68E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiqi Liu <liuqiqi@kylinos.cn>
Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Mon, 14 Sep 2026 10:45:55 +0800

alloc_pages_bulk_noprof() does not call current_gfp_context(), so per-task
scoped allocation constraints (PF_MEMALLOC_NOIO, PF_MEMALLOC_NOFS,
PF_MEMALLOC_PIN) are not applied on the bulk fast path.

The most direct consequence is PF_MEMALLOC_PIN: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the PCP
list, and a task under memalloc_pin_save() receives movable pages from the
bulk allocator.

Link: https://lore.kernel.org/20260914024555.138125-1-liuqiqi@kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator
+++ a/mm/page_alloc.c
@@ -5201,6 +5201,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are

mm-page_alloc-add-missing-hooks-to-bulk-allocation-path.patch

