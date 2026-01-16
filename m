Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E334026B;
	Fri, 16 Jan 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585710; cv=none; b=L2Yw5WgRHVm66qACGQ0xeql+hZZ3d7rH0htgRXnNNmZeUz/PuuZb0nA14pnRAJ0+o7noojw4AxA7f1URGMnJRdOkproR4FXHXu1y/tQphu1wrixjVuw7JG2QK89wWsgTGcV86kwYcM4MeJEOA6Fvn4vkrtvS1JpSxguacRZVYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585710; c=relaxed/simple;
	bh=mZwJPl5VQFqlNa5iiOuI2qG74d5RfCNxPwmtvkK98oY=;
	h=Date:To:From:Subject:Message-Id; b=f0+OjTAKq+RXrvntxBgWGQZxTiQSgLm4PomzHjca4J8XVqeRgC1JNBtazdb9AEqgqnm0v/Put4ryo0z7TCYspVUoGbyuJSuE5a6rdf/bcPUgkDHaEZLRle9lxaGrJ/vZckrhZzp4US7GJdhMwkYLBFmUfFKMcUPnHGr7x3DOt7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HKGxuR9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HKGxuR9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FE8C116C6;
	Fri, 16 Jan 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768585708;
	bh=mZwJPl5VQFqlNa5iiOuI2qG74d5RfCNxPwmtvkK98oY=;
	h=Date:To:From:Subject:From;
	b=HKGxuR9tmGWLwCvWLsA0yRG8SmK73X8V5PsZmzab1N0rram4HGMN8sahzXmvhItmb
	 Co8gMCB9uweW/Gy7AUidRoR2J9FVgcq3vfBUx1NAptPPLAO/IUm9z3q68LYF8SWTWK
	 CnsVK2SQko+GbJKH6FU7JCtJKCFyip6iaXn/vjU8=
Date: Fri, 16 Jan 2026 09:48:27 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jcmvbkbc@gmail.com,chris@zankel.net,williamt@cadence.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-fix-__kmap_to_page-build-error.patch added to mm-new branch
Message-Id: <20260116174828.48FE8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/highmem: fix __kmap_to_page() build error
has been added to the -mm mm-new branch.  Its filename is
     mm-highmem-fix-__kmap_to_page-build-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-fix-__kmap_to_page-build-error.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: William Tambe <williamt@cadence.com>
Subject: mm/highmem: fix __kmap_to_page() build error
Date: Thu, 11 Dec 2025 12:38:19 -0800

This changes fixes following build error which is a miss from ef6e06b2ef87
("highmem: fix kmap_to_page() for kmap_local_page() addresses").

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx =3D arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

(akpm: affects xtensa only)

Link: https://lkml.kernel.org/r/SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com
Fixes: ef6e06b2ef87 ("highmem: fix kmap_to_page() for kmap_local_page() addresses")
Signed-off-by: William Tambe <williamt@cadence.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/highmem.c~mm-highmem-fix-__kmap_to_page-build-error
+++ a/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i = 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval = kctrl->pteval[i];
 
 			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 			if (base_addr == base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
 
_

Patches currently in -mm which might be from williamt@cadence.com are

mm-highmem-fix-__kmap_to_page-build-error.patch

