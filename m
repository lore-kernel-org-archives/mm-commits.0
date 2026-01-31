Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4420CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898293; cv=none; b=cEEueA91ve7JJO/bsaQtbd3h1W4hMwv9x7wFgNkARFTTv4dcxxjcb5Tn8Pwn77B2sDDz0smV3gR6koWUeMrafcSk1SZtgwky7MUN7MvZbVIAqk79oipWG609bQKdabS2Ymr4267TbHdT/6CwTfdUzcbKhVhwPAHZzVJCUg2l81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898293; c=relaxed/simple;
	bh=CoFlG9h14DzoaR9+OcKvCUvc3FJXEsKDjmLorECXCEw=;
	h=Date:To:From:Subject:Message-Id; b=AMl0bBTo4GziqR90ZDsFaq1VgBT5mlTAiki1XGzgDjbQl2IgF/JiTWLwr/ZuhAYKuYu3AJsmlofvyt8ITKasL7UjbgkH2ZkSj68AaTxWtqU/kbyWc6qA4cXjGpgem4tHu8Kxb9sci/4SjeEsNQu0JwpL7tURkz9Z2qr9D12Oxm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2rLLbvWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2rLLbvWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F2C4CEF1;
	Sat, 31 Jan 2026 22:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898292;
	bh=CoFlG9h14DzoaR9+OcKvCUvc3FJXEsKDjmLorECXCEw=;
	h=Date:To:From:Subject:From;
	b=2rLLbvWfWPNdEtyfUFddekkrSiQHq0R4faA/HD+/i2NtvTtBy19QHgJzuxrx4payb
	 K1W907LHSG2cPI3GRxVFNzqzpIyEjO58/gOep5XItPNJmxz/RVykJdqUss7sMmRw68
	 Lw65Z+290We3UugbAhuMf22cxmtN1oBd+aH54jlw=
Date: Sat, 31 Jan 2026 14:24:52 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-unnecessary-if-condition.patch removed from -mm tree
Message-Id: <20260131222452.D72F2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove unnecessary if condition
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unnecessary-if-condition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2989,13 +2989,10 @@ struct folio *alloc_hugetlb_folio(struct
 
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

