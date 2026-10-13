Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EBC3750D5
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865946; cv=none; b=Z/FDiK4mADw2NZue0t0kwshQY6XTeA8bu7oe02jYWmxhR226KiM26mSr6ehLpgyOGGIFtuuVf8DGyTnYHbV7gqXfHN9EN/76k6CBnIu4Qg90Tj4Puo5nDavxke8GN+WmH2/Pk3PAkDQHqYo9eAbGmaF38ek5Nqv6EkO2coYrqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865946; c=relaxed/simple;
	bh=LqQYLcLPuEA8NQjA2E3xR0R0FQ2ik22xpGj00JPQr/s=;
	h=Date:To:From:Subject:Message-Id; b=b0fqcEV4OS02eSDbxZtEzJc8YjRsyiyO/P4uVS/9jRXrQntQzb+2GuwxVoq8e7KkChyPaMuchk1iHN1qKAhxaNLSCByb4GEbz66snEHzAqZG/Ng19CJlBMY+DTGmGgHAEhS1aalp1myJQcYlLeOqpdHLVxifAP4ZZx1EMPXUxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhdFr3rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhdFr3rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908571F000FF;
	Tue, 13 Oct 2026 04:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865944;
	bh=Au/5v9rJaTSq/da2a0KXXj3lQPJh7UlKOlt8UbtOwKA=;
	h=Date:To:From:Subject;
	b=hhdFr3rTIAQ6H1y35c3m46SCISCfiQo9x0rktDN0dd79rbc2wAscnWwPdb/78L5YY
	 hc9yVyWUNPm5CHRdtEMFr+ckkH1RShfQ3YgyQ54aFiW4MSyxJVoD+QYO1v9dN5pqjw
	 48fMLXeG80dkh7oCJbP8jL1VyrrcyifpCczfP9jQ=
Date: Mon, 12 Oct 2026 21:32:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,liuqiqi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch removed from -mm tree
Message-Id: <20261013043224.908571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiqi Liu <liuqiqi@kylinos.cn>
Subject: mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Tue, 15 Sep 2026 15:49:28 +0800

alloc_pages_bulk_noprof() does not call current_gfp_context(), so per-task
scoped allocation constraints (PF_MEMALLOC_NOIO, PF_MEMALLOC_NOFS,
PF_MEMALLOC_PIN) are not applied on the bulk fast path.

By ignoring PF_MEMALLOC_NOIO and PF_MEMALLOC_NOFS, the allocation can
theoretically result in a deadlock.

Ignoring PF_MEMALLOC_PIN also has consequences: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the PCP
list, and a task with PF_MEMALLOC_PIN set receives movable pages from the
bulk allocator.  Once pinned, these pages can no longer be migrated but
remain in MOVABLE pageblocks, violating the mobility contract.  This can
increase fragmentation and interfere with compaction or contiguous-memory
allocations, eventually surfacing as higher allocation latency or
allocation failures under memory pressure.

Found via review of the bulk allocation tracepoint hooks [1].

Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
Link: https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/ [1]
Link: https://lore.kernel.org/20260915074928.327471-1-liuqiqi@kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-apply-per-task-gfp-context-in-bulk-allocator
+++ a/mm/page_alloc.c
@@ -5189,6 +5189,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
_

Patches currently in -mm which might be from liuqiqi@kylinos.cn are


