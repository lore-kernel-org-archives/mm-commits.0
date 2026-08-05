Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DB33BD638
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896596; cv=none; b=rcthJMdllsIexSqsMJ5XyKcwaui+kTdvJEUako2q7NCWRwQooTH2ZLLJQ2o8KWX1az+X4XDApxwSjg7LAlnrXRW2Ar0jyoCpYx/mOKGWIf4/lTZPXdsvoMfAgqb5bbcReMphhVp1J4rScAKM4Y25ppCjZof5KqGJFKev2XsuSVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896596; c=relaxed/simple;
	bh=l76U3WP5bElmZkL0GXZIwU3v8fbK9xvhXj2OCYlL05Q=;
	h=Date:To:From:Subject:Message-Id; b=Bskqu08NpHo+jzvQ0FvBgGdV4x46gLSr6grL4UMrDY2j1uXXIg6Dm90aI4mW7kYBxEX8nHgx5YLNXYCFVrSVyRGwwXfABUyYG5CuJqGSREXr2yFp/ivKecwKX1g4K9mt7qhq5AhLyMXsXSRH1ilVfohQ/vUHa5Zc2K41ERrelnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bpJNFGja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bpJNFGja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B241F000E9;
	Wed,  5 Aug 2026 02:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896595;
	bh=Q/WaAHjOINyituVXwoQ278tkd3TG2zThRWpP9XNnmRo=;
	h=Date:To:From:Subject;
	b=bpJNFGjaxSZRIwRx/kx1Y1F5bMyMbGMZCE6a9ytZGrTFWF3TV5esR4Z7Mh334hsMF
	 3zDy7ZNTJBjWJ9tYRmL/PiJ9iazVlLscB7WeW3wlaTgFCbRxwOinNoBX5gGGrWSdP4
	 sIDmIfvVW3A8B9MYNEuw3CyjzPnpzZtb+J7vFi/8=
Date: Tue, 04 Aug 2026 19:23:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch removed from -mm tree
Message-Id: <20260805022315.81B241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
Date: Thu, 09 Jul 2026 14:06:05 -0400

Tail pages are expected to have (and optionally be checked) zeroed
->private when they are freed.  It stays true during subsequent
reallocation, so replace the tail_page->private initialization with a
VM_WARN_ON_ONCE() in compound page preparation.

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-5-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-page_alloc-remove-set_page_private-in-prep_compound_tail
+++ a/mm/internal.h
@@ -741,7 +741,7 @@ static inline void prep_compound_tail(st
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch

