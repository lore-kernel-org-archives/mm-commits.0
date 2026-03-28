Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E71A9FA8;
	Sat, 28 Mar 2026 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658236; cv=none; b=JX6tAPxM5fN6jMGFZjDBghW/4H+4mcVDptt64uYk3w4uCjPt4TRXVz2tJnWIGDH1bjN30iTNQGAx5v+a/YwvHk5MlH2nhD/PRFMoY/5n3RlsPtI0VR3L4A5jPcBmLSqljif9uAnWZlTTPqSoI9DEUbRYEDGTYPxa6ZzV4c+nl/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658236; c=relaxed/simple;
	bh=d+fC6TZhmj5ntJ0OfLfQ6DDWj1nr2woJRFP2+wRzb7c=;
	h=Date:To:From:Subject:Message-Id; b=glLNKEThK1meZYxrHTGbsY7fCyt61hTonNcG2vQsMANHWjEr0ScOV6RGGlSxfaFCLrwiS77hh9XrUJ3FY1tYHqNr4u5gGEfiqJPdTqRIRPVQRXvbguetptIAwOIrbHbt3uhJ/oBm+uMXrI7PGbvG8dz7ugyCNWbv5+R76ugLODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ATAo8S4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATAo8S4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72853C19423;
	Sat, 28 Mar 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658235;
	bh=d+fC6TZhmj5ntJ0OfLfQ6DDWj1nr2woJRFP2+wRzb7c=;
	h=Date:To:From:Subject:From;
	b=ATAo8S4PVypczWjltZGhiNPgaTiG0ptUScJJjOrG8LuBZ6m+vam/L3K9emsEBmlgS
	 okEW3xHomX+WbWDs8nD8vTU6HT9URChJpYtXeMLjJFUkS68JLrbu35Epnaqr8ULDrA
	 vCxjtaghpaP6O3covFCm8Jsy49LLtJpVE3kG+kW4=
Date: Fri, 27 Mar 2026 17:37:14 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baohua@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch removed from -mm tree
Message-Id: <20260328003715.72853C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch

This patch was dropped because it was folded into mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
Date: Sat, 21 Mar 2026 15:52:14 +0800

update function name and comments

Link: https://lkml.kernel.org/r/20260321075214.3305564-1-tujinjiang@huawei.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/leafops.h~mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
+++ a/include/linux/leafops.h
@@ -363,10 +363,14 @@ static inline unsigned long softleaf_to_
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
-static inline void softleaf_migration_entry_check(softleaf_t entry,
-			struct folio *folio)
+static inline void softleaf_migration_sync(softleaf_t entry,
+		struct folio *folio)
 {
-	/* See __split_folio_to_order() comment */
+	/*
+	 * Ensure we do not race with split, which might alter tail pages into new
+	 * folios and thus result in observing an unlocked folio.
+	 * This matches the write barrier in __split_folio_to_order().
+	 */
 	smp_rmb();
 
 	/*
@@ -388,7 +392,7 @@ static inline struct page *softleaf_to_p
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
 	if (softleaf_is_migration(entry))
-		softleaf_migration_entry_check(entry, page_folio(page));
+		softleaf_migration_sync(entry, page_folio(page));
 
 	return page;
 }
@@ -405,7 +409,7 @@ static inline struct folio *softleaf_to_
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
 	if (softleaf_is_migration(entry))
-		softleaf_migration_entry_check(entry, folio);
+		softleaf_migration_sync(entry, folio);
 
 	return folio;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch
mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

