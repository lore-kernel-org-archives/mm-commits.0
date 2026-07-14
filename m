Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7245238A70A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998662; cv=none; b=L6Tiyh0mZnTmfmbbCPxlQkT8Us+euy57CAP+7z8O41ittRngM+gYB6ojyBc30GQfcMTez09C163juEDU2Xf4/LHnmjIBFsTT9KLeydUpgmdVwwMMmkNFKYa5FcF0h34aa/Om5U4HIB1+4cbWikkfQZM1v69LZg7wHGaLadW+XBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998662; c=relaxed/simple;
	bh=GhO5dWI5FmdB1zJnSvlVrnMTqe9hOYe1HXhJQy3Zwkc=;
	h=Date:To:From:Subject:Message-Id; b=O/RndQtk6oHDzB6g2XMsOKOsYRt2MkUG9UfUHOmimQESgklw1P6cczdsq8/6sDZhh1JOcTRaPC57POMDT/rgVP43av/jAcu/XXNJ+L3p4GKJPJLGSd20guiOz3tuTXe1/jOJx1hSGM7Ex2+EMRXFEoQvDAnNcyGDvNdVZYQri1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXeuxfBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXeuxfBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415061F000E9;
	Tue, 14 Jul 2026 03:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998661;
	bh=nFMB5fSyn86+6ZOrJzt9OUaTmH1wNguHYukhTXUU1iI=;
	h=Date:To:From:Subject;
	b=CXeuxfBhINpKmCR6N0ReDdBN0WPzeW3eHq+VWeELDkxSiKz31EQGg4DckSyzYcGT8
	 woKnbn46tSpdQfLqUnErMc3FcYM5KBQzAVywsKCknNFiL3smwDgZycKcK165JmHWks
	 nTe1Kh0PAiQMDQ2BsuGoe6fF6KbWXfFHP0OOAJNA=
Date: Mon, 13 Jul 2026 20:11:00 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch removed from -mm tree
Message-Id: <20260714031101.415061F000E9@smtp.kernel.org>
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
Date: Wed, 1 Jul 2026 14:10:52 +0800

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

Link: https://lore.kernel.org/20260701061101.344679-10-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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


