Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC312F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619825; cv=none; b=LzNe+lzTOxf5hlklFPdNzANjD6ocVFB+6hc61OtzKsTl+Wj1ZjuBZVK9UOEOmGsmNJoKVqejTQXopgWVeBykMa+wWPX1p6ppSRaDTc+RtFUXXypT9L1SP1mcg92p1EUT5Nw6x5BVvHU0ppVSeEzxS1saF9gDFlxcii7OhtOaYNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619825; c=relaxed/simple;
	bh=A8l8pkSqZIrigd6HCgQ7rbPdmtjyi8UMtyrow/m42Mw=;
	h=Date:To:From:Subject:Message-Id; b=C1AgTVbtuuPbRktms7jaJIl8aOj9NpM/jSor5aYrBaJzqPSa15dSgKFWfcfBp72mSiSrA0ma7+ugxfAASigj69atykXf9zKoUttZx3QHwNP0csrG7GLkSdEOZ24BxAAcYDqoqUyZmJStKZm6b9aDI4b9+Ol5miJWgmOiM4J1tpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p6hxGPnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p6hxGPnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56BAC4CEDD;
	Sat, 22 Mar 2025 05:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619825;
	bh=A8l8pkSqZIrigd6HCgQ7rbPdmtjyi8UMtyrow/m42Mw=;
	h=Date:To:From:Subject:From;
	b=p6hxGPnm/YcEet3NHRNbqc1OBEiC2OkUHavqaqtMTUrUIRZzGm2CVTnUTkGuDCwR5
	 xiCuqRNyIs0Gth0WIhSYJBl2Sw/ni5wgigAGpEvJYaydyp0TfzFb+SLZBxgFs6VGDn
	 Y1tjdYI6dOP7LGYDzmCYkpj/E1Skjr0iD0CEzl/Y=
Date: Fri, 21 Mar 2025 22:03:44 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,muchun.song@linux.dev,fvdl@google.com,changyuanl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch removed from -mm tree
Message-Id: <20250322050344.E56BAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
has been removed from the -mm tree.  Its filename was
     mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/mm_init: rename init_reserved_page to init_deferred_page
Date: Tue, 25 Feb 2025 10:30:17 +0200

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, init_reserved_page()
function performs initialization of a struct page that would have been
deferred normally.

Rename it to init_deferred_page() to better reflect what the function does.

Link: https://lkml.kernel.org/r/20250225083017.567649-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-rename-init_reserved_page-to-init_deferred_page
+++ a/mm/mm_init.c
@@ -743,7 +743,7 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit init_reserved_page(unsigned long pfn, int nid)
+static void __meminit init_deferred_page(unsigned long pfn, int nid)
 {
 	if (early_page_initialised(pfn, nid))
 		return;
@@ -763,7 +763,7 @@ static inline bool defer_init(int nid, u
 	return false;
 }
 
-static inline void init_reserved_page(unsigned long pfn, int nid)
+static inline void init_deferred_page(unsigned long pfn, int nid)
 {
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
@@ -784,7 +784,7 @@ void __meminit reserve_bootmem_region(ph
 		if (pfn_valid(start_pfn)) {
 			struct page *page = pfn_to_page(start_pfn);
 
-			init_reserved_page(start_pfn, nid);
+			init_deferred_page(start_pfn, nid);
 
 			/*
 			 * no need for atomic set_bit because the struct
_

Patches currently in -mm which might be from rppt@kernel.org are


