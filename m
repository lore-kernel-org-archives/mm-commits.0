Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DF264A9D
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 20:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768595548; cv=none; b=swc1JCCMwHPbP1/jjEMYycIXq0iN1pEmfNdaEl3y8/ZmbswKJG/SYCRe3K3DO6UPuLScuK+jCNQ9oPaUxbvgMBh5zFGP4Un/ptV8R+v1XggUjFEhFkBW8LeCvGvUV0N+5eHnKj/LsrxYxeJ7ZRfuXU8ul7ZIeimBTMfgxH1HooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768595548; c=relaxed/simple;
	bh=pQWXaEVVlGj8qvH77SKmAUNvhuViL2Jeuo8jSgfI7ZI=;
	h=Date:To:From:Subject:Message-Id; b=L7iztd2+d9xKib3utabkgVwVajPY1CFbGcDiwXGfmnnlh3jkbP+LrzMcwQ/K/o4b/J1IdZ3cDIHwSg2KLOZQKV+jB7urOU+juixKtLDuXNVLXWjAZHIB5f6vChjEnCUmIaFC5Ispp/E1FgTSaMtRdWASX8ix3MecPrHEyHSsI1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0IWmXX8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0IWmXX8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8B6C19422;
	Fri, 16 Jan 2026 20:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768595548;
	bh=pQWXaEVVlGj8qvH77SKmAUNvhuViL2Jeuo8jSgfI7ZI=;
	h=Date:To:From:Subject:From;
	b=0IWmXX8GpDv2LmKY7GGfEPDvcVoT5urtCT84xBmAQ0zHQdW1V4rhrTnM84DrdKrHy
	 R2eJ2n1l40yVNbBQTVe23YGgn4pu9QSZGyaTyKep6x0KDbrP1g7ex0dcw1EnaiJnPy
	 x8cyaaxStZ7GyP5tfanw4on2Zg4inJO5T5faZWnM=
Date: Fri, 16 Jan 2026 12:32:27 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-unnecessary-if-condition.patch added to mm-new branch
Message-Id: <20260116203228.2D8B6C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove unnecessary if condition
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-unnecessary-if-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-unnecessary-if-condition.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/hugetlb: remove unnecessary if condition
Date: Fri, 16 Jan 2026 14:27:15 -0500

if (map_chg) is always true, since it is nested in another if statement
which checks for map_chg == MAP_CHG_NEEDED, which is equal to 1.

if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
	...

	if (map_chg) {
		...
	}
}

Remove the check, un-indent, and collapse the function call for
readability.

No functional change intended.

Link: https://lkml.kernel.org/r/20260116192717.1600049-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-if-condition
+++ a/mm/hugetlb.c
@@ -3028,13 +3028,10 @@ struct folio *alloc_hugetlb_folio(struct
 
 			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 			hugetlb_acct_memory(h, -rsv_adjust);
-			if (map_chg) {
-				spin_lock_irq(&hugetlb_lock);
-				hugetlb_cgroup_uncharge_folio_rsvd(
-				    hstate_index(h), pages_per_huge_page(h),
-				    folio);
-				spin_unlock_irq(&hugetlb_lock);
-			}
+			spin_lock_irq(&hugetlb_lock);
+			hugetlb_cgroup_uncharge_folio_rsvd(
+			    hstate_index(h), pages_per_huge_page(h), folio);
+			spin_unlock_irq(&hugetlb_lock);
 		}
 	}
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-hugetlb-restore-failed-global-reservations-to-subpool.patch
mm-hugetlb-remove-unnecessary-if-condition.patch
mm-hugetlb-enforce-brace-style.patch

