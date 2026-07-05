Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8188A3603D8
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 08:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240436; cv=none; b=JnWrkl4dkMaOqAvxpyVZXGC6L75k5APRoq+oMBb0ySEZfrN89QTQfJADGjHEZVrxS5mt3fRseZc65DuGR1TOg9dB7WKlnZF6AWUR/2KXxRm+KlHNLDbfv6WIkjtb8xOqYW7Z88Xg2gh6zqDi/Hv0TrNIVhxcpGlEq1OsuBEjUq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240436; c=relaxed/simple;
	bh=Et/s0A4fGQSoZDG6T0zgSBYe2BwkjCPi4fOBzJXN1iE=;
	h=Date:To:From:Subject:Message-Id; b=i77YMkl+HD38OdBT5cfZ9RDwxHrhWCUWg44fJleT0rhLWU1gR/SP/F1PfOdbsKF5kFNhVJSIxFYhFhqyNsmhK4JkRPBGdSyrlhHiuc/0R+ybz/LLI+SbRhNzEq+8xNMqWTWqdBfa6Vy4EULnOVXoDAWkvIvWlkBuUmVLAV7yZEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GV3wvPB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GV3wvPB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CDE1F000E9;
	Sun,  5 Jul 2026 08:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783240432;
	bh=11lWWHSMeLljimTAiwK1Hsushm7+REjpcpkJjxHFpQc=;
	h=Date:To:From:Subject;
	b=GV3wvPB47O/oksTfOKCOY5wJSeTQ8gJUdq+59ALgOEmmZdZx1jrUfJKgonohvYULZ
	 6PQ2ZjPj9frjFpbNugaxLPWEA5cYEG35c/Z7toqZXmk3UMRmAmWnBExRZCLuIpz3FS
	 n9AjUEE5y4HulMyZRtLkeRPXrRVas6um8ySL2WgA=
Date: Sun, 05 Jul 2026 01:33:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,rcampbell@nvidia.com,rakie.kim@sk.com,pfalcato@suse.de,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jpoimboe@kernel.org,joshua.hahnjy@gmail.com,j-nomura@ce.jp.nec.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,anshuman.khandual@arm.com,ak@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch added to mm-new branch
Message-Id: <20260705083351.E8CDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mprotect-use-huge_ptep_get-for-hugetlb-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mprotect-use-huge_ptep_get-for-hugetlb-fix
Date: Sun Jul  5 01:31:08 AM PDT 2026

s/EACCESS/EACCES/

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-use-huge_ptep_get-for-hugetlb-fix
+++ a/mm/mprotect.c
@@ -708,7 +708,7 @@ static int prot_none_hugetlb_entry(pte_t
 
 	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
 		return 0;
-	return -EACCESS;
+	return -EACCES;
 }
 #else
 #define prot_none_hugetlb_entry	NULL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

