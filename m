Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29922FCBF0
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 19:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505099; cv=none; b=IcV51KLc7bSFA8ipwmSAJl6PJAyOpaFHhwyLCd6h+SuSrnOepZ8wIdqLn3L8e7hQezbiKpUzZjOgQ+LIBiT6xg+10lHa51xvhjek0AYOIL/o9voRjgeIr7xGp6s/MqFWEEABqOASvjeggSF2nd5Ca5BDBVNaFRTqT7c2hkJq8u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505099; c=relaxed/simple;
	bh=DMYCXH8LR2C1LOQgJw3oIL82ZDnccWjscSzHtNaqpdQ=;
	h=Date:To:From:Subject:Message-Id; b=TYsj6GCgylda7gUGfQyN3PyGrKdz2F9qIvhR5kMPR3CBrWz6Z0qbwEtBszUDrlc0HLW1yMw9GycDnVcvXaDAPL0jwx6Fc52S2iaztpeCTdbL0mDrAn+1HoBgGIi56ZSrT8B66ZKL+d7XUFsX6/yk2+V0smCzfwLp4c0/7/mbmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqoUjR3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqoUjR3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39098C116D0;
	Thu, 15 Jan 2026 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768505098;
	bh=DMYCXH8LR2C1LOQgJw3oIL82ZDnccWjscSzHtNaqpdQ=;
	h=Date:To:From:Subject:From;
	b=pqoUjR3f+XkJFuOzXxbF9ATuHTCWohAC9MCzN74AqjkFPg7ry3yhAvue6dtZIig6v
	 IvPspvwzo7WyLlKIupQ+GGv/5MTIuVsQi+8aowB6W2aBSixVKbPHz2y6UTcOm9ygR+
	 7a510BI2IxwJMUKnzp8hscRGd7YX/NFjZf22zBMU=
Date: Thu, 15 Jan 2026 11:24:57 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,akpm@linux-foundation.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-unnecessary-if-condition.patch added to mm-new branch
Message-Id: <20260115192458.39098C116D0@smtp.kernel.org>
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
Date: Thu, 15 Jan 2026 13:14:36 -0500

if (map_chg) is always true, since it is nested in another if statement
which checks for it already.  Remove the check and un-indent for
readability.

if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
	...

	if (map_chg) {
		...
	}
}

No functional change intended.

Link: https://lkml.kernel.org/r/20260115181438.223620-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-if-condition
+++ a/mm/hugetlb.c
@@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct
 
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
+			    hstate_index(h), pages_per_huge_page(h),
+			    folio);
+			spin_unlock_irq(&hugetlb_lock);
 		}
 	}
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-hugetlb-restore-failed-global-reservations-to-subpool.patch
mm-hugetlb-remove-unnecessary-if-condition.patch
mm-hugetlb-enforce-brace-style.patch

