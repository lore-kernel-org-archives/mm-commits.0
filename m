Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4802ECE93;
	Thu, 15 Jan 2026 19:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504942; cv=none; b=uY8eZH7AJEutMOXHsK/z3LqhKi3AcNWj8rE5IBSFXZPNmePpKMkvyJC4x2tO+/cFVlwy32duM+bZMkkl9bFhh9OpynnGgT2xi3UtMH3WGeqTywLku0pD95dGrunSWtD1nexF4SaphPUhJev7m0URgNUpGYdXRZL/N6IgcNZRoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504942; c=relaxed/simple;
	bh=aJikC/0ww8tf8m7qj3lPJ3wWIuefGfDFZKETSibuLfw=;
	h=Date:To:From:Subject:Message-Id; b=RNh25xTt1aOldsSeju3028O2MkY1vjE5LPE0puFf2IwpE2UBKXcw66V9ih3aqCVaISBs6042vEJTCDxgJKS9tYotsSWKbmE5ihMg39yblFqAtcVPbkOf7zh4ZNUXnDuzUA6wOC0BesqQiRq7/9vmhcDrNscFPI5ojSg7WK7Ud2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZdR89LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZdR89LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B688C116D0;
	Thu, 15 Jan 2026 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768504941;
	bh=aJikC/0ww8tf8m7qj3lPJ3wWIuefGfDFZKETSibuLfw=;
	h=Date:To:From:Subject:From;
	b=eZdR89LZkcic2wXPcITSEj4VslMc05QXqKccV9jbOfNRbQEzrAIefBChj0GwEmQW2
	 KyHAlvL55af8S7BgvqXK6sD5Ug454/9CigC3WfA8DgeZVzb6UbRi2yEmsMQI/EbzG8
	 sxNHwRl5s0mBU5lwUt42t6BQEAYPUiGDtcMHyZjQ=
Date: Thu, 15 Jan 2026 11:22:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mawupeng1@huawei.com,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-restore-failed-global-reservations-to-subpool.patch added to mm-hotfixes-unstable branch
Message-Id: <20260115192221.7B688C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: restore failed global reservations to subpool
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-restore-failed-global-reservations-to-subpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-restore-failed-global-reservations-to-subpool.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/hugetlb: restore failed global reservations to subpool
Date: Thu, 15 Jan 2026 13:14:35 -0500

Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
fixed an underflow error for hstate->resv_huge_pages caused by incorrectly
attributing globally requested pages to the subpool's reservation.

Unfortunately, this fix also introduced the opposite problem, which would
leave spool->used_hpages elevated if the globally requested pages could
not be acquired.  This is because while a subpool's reserve pages only
accounts for what is requested and allocated from the subpool, its "used"
counter keeps track of what is consumed in total, both from the subpool
and globally.  Thus, we need to adjust spool->used_hpages in the other
direction, and make sure that globally requested pages are uncharged from
the subpool's used counter.

Each failed allocation attempt increments the used_hpages counter by how
many pages were requested from the global pool.  Ultimately, this renders
the subpool unusable, as used_hpages approaches the max limit.

The issue can be reproduced as follows:
1. Allocate 4 hugetlb pages
2. Create a hugetlb mount with max=4, min=2
3. Consume 2 pages globally
4. Request 3 pages from the subpool (2 from subpool + 1 from global)
	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
		used_hpages += 3
	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
		used_hpages -= 2
5. Subpool now has used_hpages = 1, despite not being able to
   successfully allocate any hugepages. It believes it can now only
   allocate 3 more hugepages, not 4.

Repeating this process will ultimately render the subpool unable to
allocate any hugepages, since it believes that it is using the maximum
number of hugepages that the subpool has been allotted.

The underflow issue that commit a833a693a490 fixes still remains fixed as
well.

Link: https://lkml.kernel.org/r/20260115181438.223620-2-joshua.hahnjy@gmail.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-failed-global-reservations-to-subpool
+++ a/mm/hugetlb.c
@@ -6573,6 +6573,7 @@ long hugetlb_reserve_pages(struct inode
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	unsigned long flags;
 	int err;
 
 	/* This should never happen */
@@ -6717,6 +6718,13 @@ out_put_pages:
 		 */
 		hugetlb_acct_memory(h, -gbl_resv);
 	}
+	/* Restore used_hpages for pages that failed global reservation */
+	if (gbl_reserve && spool) {
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_reserve;
+		unlock_or_release_subpool(spool, flags);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-hugetlb-restore-failed-global-reservations-to-subpool.patch
mm-hugetlb-remove-unnecessary-if-condition.patch
mm-hugetlb-enforce-brace-style.patch

