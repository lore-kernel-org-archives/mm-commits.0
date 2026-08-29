Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061341A909
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788045104; cv=none; b=pYOnMhiQ3fU2BeW1EPaACaHY9J/rrCSftc7w0jV5bDzAuE6LgReVYJrXfraMTT4k7HK7TKWBfMWeIqhGvem6aSnpt5Lizq8YWIrQkzDjwDygdVi0c5M6m2EbNeUUZo1tntzF4Pvq57lzwaenDrEl4ICG3mcQfde/Q3fcvexFZkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788045104; c=relaxed/simple;
	bh=WqmJ4YZCg3/IyPu2Ks0lVjKeaA73cAgOgJT2SRdKpHI=;
	h=Date:To:From:Subject:Message-Id; b=eOUrLbaOgcFElps7peKNuQK4tk7YvE/u5fj6z8V1nkP2q20cgEq54TJ8FrumXb0x6u700GJS0CqybVjmA808lGdP54bfX6jsTC6W33j02kg8qN1UiMdNxEQVlsH2bGNWo4KcyK6pfQBbCYgHYAPhmrOO9MsPM8vK6Jh7TRA4Yks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZR+N30Fj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZR+N30Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0268D1F000E9;
	Sat, 29 Aug 2026 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045102;
	bh=HcoTxaWzoZqskRPmVCuPBd7PROCJbh30/W2jRTlBhiQ=;
	h=Date:To:From:Subject;
	b=ZR+N30FjlZss1u4ZRBTRbTIOB/o2+vIo15+SMYmwSbS4l9NEY+NWdEnTEpY1CoKd+
	 ms/Q16jZebiyIqV0qYYx//froW0jl2yz7JxAcnF3DVwzT7QBvLDHXL0lkciPsL5C6F
	 1sKH89IoqfbcJjdna23779LrDPShCJjuC1zYdu2s=
Date: Sat, 29 Aug 2026 16:11:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,libaokun1@huawei.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-out-dated-document-of-__gfp_nofail.patch removed from -mm tree
Message-Id: <20260829231142.0268D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove out-dated document of __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-remove-out-dated-document-of-__gfp_nofail.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: remove out-dated document of __GFP_NOFAIL
Date: Thu, 27 Aug 2026 03:05:48 +0000

Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
with __GFP_NOFAIL") remove a warning on allocating large folio with
__GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
illegal __GFP_NOFAIL usage in a more appropriate location and manner").

While in that commit, it also documented this behavior which is out-dated
now.

Adjust the document to align to current code, and adjust the comment while
at it.

Link: https://lore.kernel.org/20260827030548.16631-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baokun Li <libaokun1@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    2 --
 mm/page_alloc.c           |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/gfp_types.h~mm-remove-out-dated-document-of-__gfp_nofail
+++ a/include/linux/gfp_types.h
@@ -243,8 +243,6 @@ enum {
  * used only when there is no reasonable failure policy) but it is
  * definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
- * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
- * not supported. Please consider using kvmalloc() instead.
  */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)
 #define __GFP_FS	((__force gfp_t)___GFP_FS)
--- a/mm/page_alloc.c~mm-remove-out-dated-document-of-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	if (unlikely(nofail)) {
 		/*
-		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
+		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
 		 */
 		WARN_ON_ONCE(!can_direct_reclaim);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-adjust-out-dated-document-of-__gfp_nofail.patch

