Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBEC36EA9E
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027600; cv=none; b=rFwFfAeGjexlnyhM0+KQO69P3mejiIaj8asCQGqsF0cCxUQFxtfNQbAlbnduX+JbrRfWD8otCXid/g3u2Z9LDDDhyRtOE/WnKm8boYXcM+WVqZzJ8pzZO9XPR0kWZztuMaJiZTzmG/+tlch50isq/sIu/KLYKUF77RWWnQa9isY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027600; c=relaxed/simple;
	bh=Ovs1KIsZFIgLFNgMXJKZH3snLIncTlcId9hVckDPUSY=;
	h=Date:To:From:Subject:Message-Id; b=qABhepGuNSsHrFvRyIrrURCWwDT1camgWSGlWTeOr1q3d8q6uhvCc8bKeKPxWYbJDXpYM4Q2dL8EqjIRkxhjfDKmJ0/LIlSNSisDz/ArpGij20BPw86WJLYH3S0wFORZ6oL9okyzBlOQFrQ8TevklYMO9gJQCQ7LkFnO+RGsb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHkoYQ+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHkoYQ+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4038D1F00898;
	Fri, 29 May 2026 04:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027599;
	bh=6K1IrDb00kP22bWpMRry2tCAs6tocvLGyRUVgmFRdDQ=;
	h=Date:To:From:Subject;
	b=NHkoYQ+yDX2j0yOr8KfMqkqzLN3t/anLWm2AFL8iAZHds7NTDNfnGX0KZgmJOjflK
	 3Z1xWgMhWffoNeAIxertdf412mc97HYY2LedO2NRmnhjcN3zJ3TUZQNE+tz6IWp3if
	 Ybe5eh7GSXEruheMVD2fBuvBE87nxMvM2Wk/wmJw=
Date: Thu, 28 May 2026 21:06:38 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch removed from -mm tree
Message-Id: <20260529040639.4038D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove unnecessary NULL check before allocating mem_section
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/sparse: remove unnecessary NULL check before allocating mem_section
Date: Sun, 19 Apr 2026 23:42:25 +0900

Commit 850ed20539a4 ("mm: move array mem_section init code out of
memory_present()") moved mem_section allocation logic into
memblocks_present().

Before that move, memory_present() could be called multiple times, so
unlikely() matched the common case, where most calls found mem_section
already allocated.

After that move, memblocks_present() is called exactly once from
sparse_init().  Under CONFIG_SPARSEMEM_EXTREME, mem_section is always NULL
when it is called.

So remove unnecessary NULL check before allocating mem_section.  No
functional change.

Link: https://lore.kernel.org/20260419144225.2875654-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section
+++ a/mm/sparse.c
@@ -201,13 +201,11 @@ static void __init memblocks_present(voi
 	int i, nid;
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
-		unsigned long size, align;
+	unsigned long size, align;
 
-		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc_or_panic(size, align);
-	}
+	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+	align = 1 << (INTERNODE_CACHE_SHIFT);
+	mem_section = memblock_alloc_or_panic(size, align);
 #endif
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment.patch

