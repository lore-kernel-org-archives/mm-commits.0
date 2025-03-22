Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8BE12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619824; cv=none; b=k1tMnMSfTNnfpmqEBjbAW8MMRovk9wRsU0yFfRQLrdLmQLRhzYY+e8LFSvqT6dEg5tiggCdIFr1rRhWGehmPpEExPC615ts515iBfdCagTEMpnwAzSbn4SsfHsM0VNYk0gWJDVFYfamDROs+OQAXJKAwdh9HcQ99ySDsPZQReKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619824; c=relaxed/simple;
	bh=1oPFtNWK4pKHGBhpAIv9JbLtoJudiRySDRCR4NI2Ryk=;
	h=Date:To:From:Subject:Message-Id; b=rFX8Ix8Ua824TggQ2bV9C2ORD2hQRfRdwEV6cxnkzaxYJLY7RwEK0NleCGGBjnzAdXMOeSS+jhnW+HviXTDNXRiHM5Z37s+X/fTN8zvxYO/3+ql+BH55fwjTmiqTC0pcpoJ5fkRNUfnkiNCdLoNjWo0nULYI7BKbSSMnz8qp1Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPqXJZfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPqXJZfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8528DC4CEDD;
	Sat, 22 Mar 2025 05:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619823;
	bh=1oPFtNWK4pKHGBhpAIv9JbLtoJudiRySDRCR4NI2Ryk=;
	h=Date:To:From:Subject:From;
	b=WPqXJZfy13Exmw7i1rUvdfX6GdByYuYxyLDS7QyA381yJQYJlD58Ii288Thz63neG
	 cvXnJs5aiLKyXpNhK6jaAbu9KX3oDowRLhR6vxz7lRc2PNalYDRfHNtl+uBDc5Idau
	 7+Vf7DLEaA6d3DPi+bGx3o26WcXahgrrzID6CYDc=
Date: Fri, 21 Mar 2025 22:03:42 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,muchun.song@linux.dev,fvdl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch removed from -mm tree
Message-Id: <20250322050343.8528DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: rename __init_reserved_page_zone to __init_page_from_nid
has been removed from the -mm tree.  Its filename was
     mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    2 +-
 mm/internal.h |    2 +-
 mm/mm_init.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/hugetlb.c
@@ -3407,7 +3407,7 @@ static void __init hugetlb_bootmem_free_
 
 	while (npages--) {
 		pfn = page_to_pfn(page);
-		__init_reserved_page_zone(pfn, nid);
+		__init_page_from_nid(pfn, nid);
 		free_reserved_page(page);
 		page++;
 	}
--- a/mm/internal.h~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/internal.h
@@ -1518,7 +1518,7 @@ static inline bool pte_needs_soft_dirty_
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_reserved_page_zone(unsigned long pfn, int nid);
+void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid
+++ a/mm/mm_init.c
@@ -668,7 +668,7 @@ static inline void fixup_hashdist(void)
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
-void __meminit __init_reserved_page_zone(unsigned long pfn, int nid)
+void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
 	int zid;
@@ -748,7 +748,7 @@ static void __meminit init_reserved_page
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	__init_reserved_page_zone(pfn, nid);
+	__init_page_from_nid(pfn, nid);
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
_

Patches currently in -mm which might be from rppt@kernel.org are


