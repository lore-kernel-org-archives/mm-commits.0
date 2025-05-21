Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DAF32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806608; cv=none; b=SW7WM14AkGB9Jsm1yFsiTdsuk25WPUKHGexldw0jCYQQ4jMFqYgeDstbxdMGpVRVYCy3QvZ6ANwq5B7MSWc1lP1+e/capN5TT3kQsZXfRUmCKZScdiSBLknD0C5KJAhqUeDIDiaSNO40/Oo03vtNsZGNLpNd8/LxVbU9HZusKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806608; c=relaxed/simple;
	bh=qaPf3mcPJK1VIIXHaDttt88z7S6knV6d+AalvZWK+WU=;
	h=Date:To:From:Subject:Message-Id; b=rj5hEYOqUyYoODCfNypxovUolT//F07RTsUEosw5xxirue8TYmWe0PiudOS45x1vdJT0UlWQgwX0pxEwXjNz1pZD6V+RIVk9SN3Nye8kpmKZ8ctD3t/ccZ9oW1DI6HJ7XZ0T72UwT3lwqUlj3z8fIJltiJlcOvhStVnHfDE2jac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omK/Js/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omK/Js/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903ABC4CEED;
	Wed, 21 May 2025 05:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806607;
	bh=qaPf3mcPJK1VIIXHaDttt88z7S6knV6d+AalvZWK+WU=;
	h=Date:To:From:Subject:From;
	b=omK/Js/OtsW3GVqC59qsYBbbI2QAQbZABupd08el20sdaSWrkuIRNWhDashjXq8pj
	 c66pRQecuCm6pmPZ6HQ1Ymp+4fO66UvKt6p192gtGxoBzyqIQEJUVWQrFrNW097cwU
	 A5JLTFHOYzbo0fFzMi3WmenL+TaWL460WoZUl5mY=
Date: Tue, 20 May 2025 22:50:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-page-allocator-section.patch removed from -mm tree
Message-Id: <20250521055007.903ABC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update page allocator section
has been removed from the -mm tree.  Its filename was
     maintainers-update-page-allocator-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: update page allocator section
Date: Mon, 12 May 2025 15:46:03 +0100

Make Vlastimil maintainer of this section (with thanks to Vlastimil for
agreeing to this!) and add page isolation files for which this section
seem most appropriate.

We may wish to, in future, refactor/rename some of these files to more
logically fit what is actually being performed, but for the time being
this seems the most sensible place.

Additionally, fix the alphabetical ordering of files.

Link: https://lkml.kernel.org/r/20250512144603.90379-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-update-page-allocator-section
+++ a/MAINTAINERS
@@ -15566,7 +15566,7 @@ F:	mm/numa_memblks.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <jackmanb@google.com>
@@ -15574,10 +15574,12 @@ R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/compaction.h
+F:	include/linux/gfp.h
+F:	include/linux/page-isolation.h
 F:	mm/compaction.c
 F:	mm/page_alloc.c
-F:	include/linux/gfp.h
-F:	include/linux/compaction.h
+F:	mm/page_isolation.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

