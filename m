Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E29C38D40D
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297506; cv=none; b=tsaWuDQhiF9H3BSRuwh8GYbz/DyKfqcDnuSgY5groKfMiUdv7g0J6moInaUte5ZIJFn12KeuHQUnngswkdYKbL9cxwY7PPcQxdKaGOqR40S6L3/8aKcIpdC9O38dTKleJU6mkop9kNY9xuN3xUmzqm9bWR1lbujw08xnc1h2uHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297506; c=relaxed/simple;
	bh=7/896Mn/KF50QMsmirNiacNad+VVEkueoQH1hbxOE3M=;
	h=Date:To:From:Subject:Message-Id; b=ieNoT6CRmvoM9aIlCWgRsnw5NnhNWpW6sQtJ/bxKIAnLrLHmcK7DDWx2gC0QsbpwnDzAbcsfoMpIRYcQxDQARRagjnYVkhQNou7m0iVulbFzQt1s3HLtUWgPLpfEHNEXP/LwETObsaJQeMQO0jV49BkbDZqQDqFx2CFgal2C1wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v22fvpdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v22fvpdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097ED1F000E9;
	Wed, 29 Jul 2026 03:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297503;
	bh=YUcoh01Mgp33ujrvbvGqD7EtONqnE1bZKuIZN/nN2mQ=;
	h=Date:To:From:Subject;
	b=v22fvpdmP6oP9IMPUUBjDNRKmjvAvDQTIrmLA/PgsSOof8/Af0WOGzKbYot3pAExo
	 UbhAghr9fwIlybqD26o0pVuh0y+8xPyy9Ag2PVPYI147QMc8ieLedU2H3y5H9EeeQ8
	 XN2h7tcPFGoHFXNgcS9wpskppDnF2ZidUHDtGOSE=
Date: Tue, 28 Jul 2026 20:58:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,rcampbell@nvidia.com,rakie.kim@sk.com,pfalcato@suse.de,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jpoimboe@kernel.org,joshua.hahnjy@gmail.com,j-nomura@ce.jp.nec.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,anshuman.khandual@arm.com,ak@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch removed from -mm tree
Message-Id: <20260729035823.097ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mprotect-use-huge_ptep_get-for-hugetlb-fix
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch

This patch was dropped because it was folded into mm-mprotect-use-huge_ptep_get-for-hugetlb.patch

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

csky-implement-flush_cache_vmap-in-c.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

