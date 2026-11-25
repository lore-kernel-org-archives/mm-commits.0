Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795572665;
	b=BGgheF3tv0p+sZ4/XHIGmTrvErktKKD4XLPhYvZ5NYLmPpJwESEtY4/v7a9cDpq1CZ0X
	 wX7bSrlhxEP63g7MocjQw+wnYyz67Cwlr0bku2O7MK/u1B0bHUQWeR3p4adPqmlPgOeyy
	 3+yh2QdNShT1fWoxiO5F3BilaY2hj9NQbwHrT9RNBigEeFz1mdt2Jwia9BOHaGi9iwJhP
	 FH4q97K9OLTyk1BhAI5dVDPPP6Mz3ix1LOn342AZOT/Q3kFFmnO550aDzoZF0nBn9uH5s
	 5KDDf/3Akfx//5Cr37s3gfmjLhcDZi0mymzPy/W++x+uzWsa/MEIEbY3uFZZ+Q8WlvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795572665;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=DhF2dnPc15yah+Y1isyDgW9HtPetiqP9rAM13eleWss=;
	b=atRyEpvOQwAKLryna5XbZISAnvUZarWFjiiu2PNd0vfB6Ys5RLdGle4ncbaLWFQ2hm+v
	 uM7LWneRregJNO7TJkXuMwaaMSNEAJXmTPsPJVIQFfpyguEm7EiKE3yUVHOY/jNWIqCKe
	 W9CMz8TuZineGPNI8hSV3TNrSLO9mqglrKZW1vA8hUlhK7kEmoKjXp4GjFmWoQsX9W+Xw
	 GklpQ9DZtet1bcrjOr4JpfSgmSK96ofEXtuhTvBGloWH7j9z6cbIaol00uN96TEOkeeht
	 LxWBQiyeIb+pWVQLk2nBFuFnOu1BFHFAff6b8dAHvEq9lTBjRAiu2mEmsjmW7f/yHtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sLnBDxVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D0606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sLnBDxVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A27C1F000C4;
	Wed, 25 Nov 2026 02:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795572664;
	bh=DhF2dnPc15yah+Y1isyDgW9HtPetiqP9rAM13eleWss=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sLnBDxVhN3WCcmyNMknDCv8cFjnxDLHDVa3/BX6IKXgycn0p7tZT0TUhyGPixkl1b
	 DmviLN24mtso4jRyD8IzWklvsRMRKAcUmJnpSEm3fYrEUyvM0aI7iOvgXHGzjTmWQz
	 dGd25UgROgkjhSZsBKeIZJK6q9lHC0ErXv/JxRzw=
Date: Tue, 24 Nov 2026 18:11:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,
	brendan.jackman@linux.dev,evanfengff@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117214947.13471-1-evanfengff@gmail.com>
References: <20261117214947.13471-1-evanfengff@gmail.com>
Subject: + tools-mm-page_owner_sort-fix-slab-allocator-labelling.patch added to mm-new branch
Message-Id: <20261125021104.4A27C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm/page_owner_sort: fix slab allocator labelling
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-fix-slab-allocator-labelling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-fix-slab-allocator-labelling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yifan Feng <evanfengff@gmail.com>
Subject: tools/mm/page_owner_sort: fix slab allocator labelling
Date: Tue, 17 Nov 2026 13:49:47 -0800

page_owner_sort labels a page as allocated by slab when the page flags in
the "PFN" line contain "slab".  Since commit 46df8e73a4a3 ("mm: free up
PG_slab") slab is a page type and is not printed there any more, so slab
pages are reported as allocated by OTHERS.

Also look for the slab page allocation in the stack trace, as is done for
vmalloc.  The frame is new_slab(), or allocate_slab() when new_slab() is
inlined, as in the example in Documentation/mm/page_owner.rst.  Slab pages
allocated before page_owner is initialised have no stack trace and are
still not labelled.

Link: https://patch.msgid.link/20261117214947.13471-1-evanfengff@gmail.com
Fixes: 46df8e73a4a3 ("mm: free up PG_slab")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>

 tools/mm/page_owner_sort.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-fix-slab-allocator-labelling
+++ a/tools/mm/page_owner_sort.c
@@ -489,7 +489,8 @@ static int get_allocator(const char *buf
 
 	if (strstr(migrate_info, "CMA"))
 		allocator |= ALLOCATOR_CMA;
-	if (strstr(migrate_info, "slab"))
+	if (strstr(migrate_info, "slab") || strstr(buf, "new_slab") ||
+	    strstr(buf, "allocate_slab"))
 		allocator |= ALLOCATOR_SLAB;
 	tmp = strstr(buf, "__vmalloc_node_range");
 	if (tmp) {
_

Patches currently in -mm which might be from evanfengff@gmail.com are

mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch
mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch
tools-mm-page_owner_sort-fix-slab-allocator-labelling.patch

