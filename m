Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEB3367281
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876980; cv=none; b=OwDCWRW3ggudBo8JyY9PcCjrOrEjaFudkjuK55/lBp2DKMFwT6Fv5AuQV34GkC14gijlJEbNbRfXvxtX8OgxRfgBKJgAKLIfZkoPQnw3G+psOrHJ1BHBrjIisfMEdUfFGJEC2pYp8PHRU2xZi3qYDqofGfi55UbaotL9oRIwehk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876980; c=relaxed/simple;
	bh=S0q79Q3BooHiNan8OpM1eDiZ++1lx6nO100jwD+zRfU=;
	h=Date:To:From:Subject:Message-Id; b=IzzOOPWiwJgMSvdSNJNLmj9r1+mavvqFSAkmdMkeF6CPaksJ/8qy2Ggm0VPRw6EN9Wi+TS5wRGUObAX8lPyX4gCKqaOkJd/dhJUtvRkyHKCB6cSY1VA3e5oyZGz7SbdUgdC9HEXw5pVGiIN4EC5qpODggahQJfE1mvu9avKL4Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k7s5GSrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k7s5GSrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88391F00A3A;
	Wed,  1 Jul 2026 03:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876979;
	bh=agjz3T+aHOq8x6ggxEdrrE62jnB4aGX5NqoxUA6cEWE=;
	h=Date:To:From:Subject;
	b=k7s5GSrqsL8GlgKIUcYqxsMHM8E6LOAkxrpMc/Ni8hMq6ZqQmd50AOj2PszLNQKQi
	 uoViKYjqxiLIIUhjYDoXHxamt6ISrJWkyJ8Y15CUV3QeZOriXVywHrfy3vtF3Dolos
	 RemiuFJphsoh5a1lPcX43jQxPDB91XzSjAtz+GNE=
Date: Tue, 30 Jun 2026 20:36:18 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch removed from -mm tree
Message-Id: <20260701033618.D88391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Thu, 25 Jun 2026 09:47:05 +0800

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages and
NULL memcg_data.  However, at the end it calls PageMemcgKmem(page) which
internally calls folio_memcg_kmem() — and that function re-reads
folio->memcg_data and page->compound_head locklessly, wrapping both in
VM_BUG_ON assertions:

    VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
    VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page or a
slab page between the initial guards and this final call, the VM_BUG_ON
assertions can fire on debug builds (CONFIG_DEBUG_VM=y), causing a kernel
panic.

Fix by reusing the memcg_data snapshot already taken at function entry
instead of calling PageMemcgKmem(), which is semantically equivalent:
PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM. 
This avoids both the TOCTOU window and the assertions entirely.

Link: https://lore.kernel.org/20260625014708.87386-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on
+++ a/mm/page_owner.c
@@ -561,7 +561,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
_

Patches currently in -mm which might be from ye.liu@linux.dev are

a.patch

