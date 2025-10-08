Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299BB21C19E
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759882936; cv=none; b=unDXlanM2zOSQZNPkjPxlnbFWfxFRl/1++2HgBjLqiIP1JfdKjTiEFkrJp3ujWoQkiHf85b8o1vXmgECXnmHS8qpZ0uT8d1b8+AnbpASqN8R9FjAPeYb1PzgHcn/JvexL7ESRLojMeBCy3STYoMU7JU7d/9Oj0C9fanQKvK+1Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759882936; c=relaxed/simple;
	bh=dQvyKlD/qVLXsmax0VyO5x/QJLlhRywsvNvLS3orIcg=;
	h=Date:To:From:Subject:Message-Id; b=T++HK3OBhghv1gmUqPNywVcEMNJuPm29pGCvRLmHd4EnY76itIvNyyCgJVQ6r4Lh9PcyntoRXNOv+Vp9XAYdeA+wVV4sYJ425CC1JHs3278Dncn9l14hTfhTsRDkgcbI72MhzSkCuu8nkqb+LgIOxfx/t/3nNDAURUp6t7hAA+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3ai/bp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3ai/bp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA25EC4CEF1;
	Wed,  8 Oct 2025 00:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759882935;
	bh=dQvyKlD/qVLXsmax0VyO5x/QJLlhRywsvNvLS3orIcg=;
	h=Date:To:From:Subject:From;
	b=C3ai/bp3PJ+wucR24RaTn/YEii0hehp8bPQxND7+IK9BRVjHTojUxeaHhYUFSjLAq
	 kwsxU+HkHzCMyyZxU4K6nzOA6esg30fS7YiMvXXRpOCiWzSntcbXi4AGxsnbZGbc2P
	 6Fvv9viZ8TnvKXrCHErl1RwDEN0vqGIyb5Hk/44c=
Date: Tue, 07 Oct 2025 17:22:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-s-red-black-tree-xarray.patch added to mm-new branch
Message-Id: <20251008002215.DA25EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: s/red-black tree/xarray/
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-s-red-black-tree-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-s-red-black-tree-xarray.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: s/red-black tree/xarray/
Date: Fri, 3 Oct 2025 13:38:50 -0700

Changes made by commit 796c2c23e14e ("zswap: replace RB tree with xarray")
are not reflected on a comment.  Update the comment.

Link: https://lkml.kernel.org/r/20251003203851.43128-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-s-red-black-tree-xarray
+++ a/mm/zswap.c
@@ -175,7 +175,7 @@ static struct shrinker *zswap_shrinker;
  * This structure contains the metadata for tracking a single compressed
  * page within zswap.
  *
- * swpentry - associated swap entry, the offset indexes into the red-black tree
+ * swpentry - associated swap entry, the offset indexes into the xarray
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression.
  * referenced - true if the entry recently entered the zswap pool. Unset by the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

