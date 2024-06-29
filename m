Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083AD6AAD
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627558; cv=none; b=MmdDW8cXYqwmkp1y/5o1okmlz1D0m7eOVbzeT2tBNPLCxxb71U9mEJ4DjsjqD5PvCAqicNfsHG8Xogvum+atGn33Vqgz65pSy0Cn8RFGqp4qPQbpZCqWzqjC1/FeHzZMnR5imAnfeadMuE+hQ2Nb372LSNlQj0d5Ndeb2eodeAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627558; c=relaxed/simple;
	bh=qBjZJzFv663m/1x2GHttAA2q9bcqurSrdABjbUVC9FE=;
	h=Date:To:From:Subject:Message-Id; b=gTAQS05YfcoI2av0MkZAlWegwkx9YKzkzar2AEf7OUncf/+s6EYIVXdGtzJP08oC0M2sdGn+GZ7fJOa0Kj/6n8qJmRYH7If6IGTfDALZRywHiupgmvX59fzS0sa44RwkGaqICkg4vZN+k5Lqkm6kug1aTGnBbhy6nmcjqphSaNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vv0QeET1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vv0QeET1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F14AC32786;
	Sat, 29 Jun 2024 02:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627557;
	bh=qBjZJzFv663m/1x2GHttAA2q9bcqurSrdABjbUVC9FE=;
	h=Date:To:From:Subject:From;
	b=Vv0QeET17w+cqaeaZYWfbBMY3ipBAPyqdQNxWpkoPBZEPaRJ5z3sChMvTsxR+47+5
	 bsoKrQot5fWH53NPEzH1Ls8c1AUJOYoV2saEF79Umw9LMAypmTQlMVcyGG2gMMuBbZ
	 CCAuXa8AcRWLWcGcef8LGpafRaeHwvVQ22zVs86Q=
Date: Fri, 28 Jun 2024 19:19:17 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pass-meminit_context-to-__free_pages_core-fix-2.patch removed from -mm tree
Message-Id: <20240629021917.9F14AC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix-2
has been removed from the -mm tree.  Its filename was
     mm-pass-meminit_context-to-__free_pages_core-fix-2.patch

This patch was dropped because it was folded into mm-pass-meminit_context-to-__free_pages_core.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-pass-meminit_context-to-__free_pages_core-fix-2
Date: Tue, 11 Jun 2024 12:05:09 +0200

fix up the memblock comment, per Oscar

Link: https://lkml.kernel.org/r/2ed64218-7f3b-4302-a5dc-27f060654fe2@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-pass-meminit_context-to-__free_pages_core-fix-2
+++ a/mm/page_alloc.c
@@ -1250,7 +1250,7 @@ void __free_pages_core(struct page *page
 		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
-		/* memblock adjusts totalram_pages() ahead of time. */
+		/* memblock adjusts totalram_pages() manually. */
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

