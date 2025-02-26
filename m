Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586F2256D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536348; cv=none; b=KhzEcIyrhrtTxzd5iN4z0FqNbLQbv28QeonMif3Mvhy14HhQaaFdTFyE6ugwaaI4IHumCDd0uOddoTpJWIjDlHCGMo8HL1GOWn8SjxzyipZcFM4rMqJ2IUKX8QjyOuYTF8+fn9UkIBsVzGoPzzAlvfYxkMnAM/dCPlgu4BjTCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536348; c=relaxed/simple;
	bh=gT6+TWG5vf5G16dR1uyuytZV6ndL6kkulEM+coHV5BY=;
	h=Date:To:From:Subject:Message-Id; b=LaRHPnuzUeEO7T6T9+0uHM64VdZOY/xXMZ3sXZeuW4OBL6Ip60hZxeErrrPtrNc7TW3QXNrR+r9P0ebdlhDMd7w48GavPMG22Jb6WqcxB47DMIjFX3po4m62GXoLrKF2KG9dHpgq+OnJ1RzDYDrOyjrTxPqBDRdRLowLVDUJDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFWHGORz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFWHGORz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E1FC4CEDD;
	Wed, 26 Feb 2025 02:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740536347;
	bh=gT6+TWG5vf5G16dR1uyuytZV6ndL6kkulEM+coHV5BY=;
	h=Date:To:From:Subject:From;
	b=CFWHGORzRvkMGfoOc/YFaexvM7goTshSOgO+Xxp5g2Uhdti8oAITPYh1YyXLFnwfP
	 aDk8ZiiZrulLoBTbUG05IWQvNLHsON32vMc5izqVJjW/doLjKBgw4Xl8KN/q1VHkeH
	 sUxtVMwqFtwgDHIMDbacFZzSzxXTttGCTAA4bdYs=
Date: Tue, 25 Feb 2025 18:19:07 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,muchun.song@linux.dev,fvdl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch added to mm-unstable branch
Message-Id: <20250226021907.C4E1FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: rename __init_reserved_page_zone to __init_page_from_nid
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/mm_init: rename __init_reserved_page_zone to __init_page_from_nid
Date: Tue, 25 Feb 2025 10:30:16 +0200

__init_reserved_page_zone() function finds the zone for pfn and nid and
performs initialization of a struct page with that zone and nid.  There is
nothing in that function about reserved pages and it is misnamed.

Rename it to __init_page_from_nid() to better reflect what the function
does.

Link: https://lkml.kernel.org/r/20250225083017.567649-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    2 +-
 mm/internal.h |    2 +-
 mm/mm_init.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/hugetlb.c
@@ -3392,7 +3392,7 @@ static void __init hugetlb_bootmem_free_
 
 	while (npages--) {
 		pfn = page_to_pfn(page);
-		__init_reserved_page_zone(pfn, nid);
+		__init_page_from_nid(pfn, nid);
 		free_reserved_page(page);
 		page++;
 	}
--- a/mm/internal.h~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/internal.h
@@ -1465,7 +1465,7 @@ static inline bool pte_needs_soft_dirty_
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_reserved_page_zone(unsigned long pfn, int nid);
+void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/mm_init.c
@@ -653,7 +653,7 @@ static inline void fixup_hashdist(void)
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
-void __meminit __init_reserved_page_zone(unsigned long pfn, int nid)
+void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
 	int zid;
@@ -733,7 +733,7 @@ static void __meminit init_reserved_page
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	__init_reserved_page_zone(pfn, nid);
+	__init_page_from_nid(pfn, nid);
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

