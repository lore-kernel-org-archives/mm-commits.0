Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75B263F5E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386830; cv=none; b=kZcPpONRXEPqS+oqSEftwf/Nw56Xtwo7eATaZm32CwCgrRx2PHal2LOxPK4F2x81jS8Y1Jf1WqzRx3W/LxmB7RWjMDBM2BxCrWGusp+24qUYsNXZVORNELaxnCpgNLYip3vMPss0IObzunnwMz86Zn6L7+Id2H7+QEfnIpy2HdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386830; c=relaxed/simple;
	bh=LY3NGLN/x8tyLyKrf5JWnGodVXnkO3iR3PSiGm6iq04=;
	h=Date:To:From:Subject:Message-Id; b=diojssMBL9IAgw+pyZP72CrVGSodNI4RsYkq6WdxBUysOyolaUV3/1oMH42sRv9uSnO8o4UMyBSVgRvnlv1SoBmsCO+gNe/UzPCjV8bkSL2nif/saEmoSk4+qO31bu9uk6r2w06FKHtolNGysSPHMtIUkKAxDzLCITFF9NJRQT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ou35lBGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ou35lBGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B94C19424;
	Tue, 24 Mar 2026 21:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386830;
	bh=LY3NGLN/x8tyLyKrf5JWnGodVXnkO3iR3PSiGm6iq04=;
	h=Date:To:From:Subject:From;
	b=ou35lBGc6t4TyTR54egwLfFNe6hQv9Dsyz0E9M+ACzFCgvg2K2ZjWYboDtEVUZuCD
	 prrvCc3tKnrbXJJb3pJVnaLztcuKD0zSVyzMNcQ+ey0RMmwt5J0YPUKITYCd3Vp7MM
	 ilXx0rDX8FBj1WSsry2bi5wbd7XA/ZtfdeTacSVU=
Date: Tue, 24 Mar 2026 14:13:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch removed from -mm tree
Message-Id: <20260324211350.03B94C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
has been removed from the -mm tree.  Its filename was
     mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch

This patch was dropped because it was folded into mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
Date: Mon Feb 23 12:09:18 PM PST 2026

update comment per Matthew and David

Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
+++ a/mm/internal.h
@@ -521,10 +521,10 @@ void pmd_install(struct mm_struct *mm, p
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
  *
- * When we stumble over a pmd_none() without holding the PTL while unmapping a
- * folio that could have been mapped at that PMD, it could be that concurrent
- * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
- * already, the folio might still appear to be mapped (folio_mapped()).
+ * When we find a pmd_none() while unmapping a folio without holding the PTL,
+ * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
+ * indicate that it's unmapped. Skipping the PMD without synchronization could
+ * make folio unmapping code assume that unmapping failed.
  *
  * Wait for concurrent zapping to complete by grabbing the PTL.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

