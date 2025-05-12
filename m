Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C0225332D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 22:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088026; cv=none; b=FfghA3CK9O3ir2b+cqjxiN41uZiJ54cA6AHDRX42792h6wGA096HViHOMFwTa3U1obe2vpXkHZfv4eKIY0R3DcjKhElvWpsnwWsA4eWMFEiYuFWOrHz+3p1Y95V/ozpf/szUQpE9cAF3vyvMIaAijwsdWDDC4f6YpkfgI+y+krY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088026; c=relaxed/simple;
	bh=21TuUav2GrAPiov72PWqmeL2ZMorFES6rNHKMWrKNxY=;
	h=Date:To:From:Subject:Message-Id; b=l75na34yfbB8HjPQtHlRihRc15iIxNaEeVYk19MPUsgcNmosBDyfvnGnOVDkwXkSP0Zq/njSem7hkRp+pgEck7L172rjtnB25tKy2vbG9+3n6f1z2FmOyI26NQvBXpJCQBYI1bFlix6XtEC2PvzSO/ZP2lSWPoBJllNiuUUcUSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hCbSxdjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCbSxdjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B2C4CEE7;
	Mon, 12 May 2025 22:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747088025;
	bh=21TuUav2GrAPiov72PWqmeL2ZMorFES6rNHKMWrKNxY=;
	h=Date:To:From:Subject:From;
	b=hCbSxdjVuCRN0zecVYH0YP1zoqzPFXhZBVTWDONmUUCp8pHLM8o8yyXzCa///SEge
	 NhPWE27e+0QlQw95d317fXgVoPwoj3QyauvjLRgOV/5Gnx6OTtdO9sJTI1pzjus1Yq
	 nvuGsCDnyheE8nLv+YQfILd3Q/tKwVJ49Gm4vzBE=
Date: Mon, 12 May 2025 15:13:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-page-allocator-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250512221345.C04B2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update page allocator section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-page-allocator-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-page-allocator-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maintainers-update-page-allocator-section.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

