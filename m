Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290EB37E5E5;
	Thu, 10 Sep 2026 03:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012293; cv=none; b=a474L6mJSOfu1ungtS8V+2pDgqqI32V9t/pgtJSfh2bnsQzJo/2HUk1mTLepidBWYPapGF4ZrONp0WaSW/4MDKYHR8aLyL8HDnkk/9NisiR4onF+vZmOPEgVK6J7bG8bxCG1rWW/l0MHm7lXZlDlf3A4z88Ja+ufahvdEGJtEz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012293; c=relaxed/simple;
	bh=3Wc2nInaI4Xp/xFX/kaCEehrA7eAOqv1txhz+IgOR5I=;
	h=Date:To:From:Subject:Message-Id; b=Y1DuRRS+CCKUbdqnsKsRRhntr1adci4Puy3eV8QdSETKVKQ7l6skaLI2BixbksLh+Vd8i4YrU4WAz09/BylAGl6d/R17XBUo3mJgfZCFgNVVDGiGcWjdPZ2v8XE6NLWDduFZ49IjjzipgeYsjty6G2SsPh0GL0zfcmK+0cPNuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCRv6fdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCRv6fdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECCB1F000FF;
	Thu, 10 Sep 2026 03:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789012285;
	bh=D4PhI0qKLxy9d3P9jPF2OPh8a94xJkf9+ADABoEAFVc=;
	h=Date:To:From:Subject;
	b=rCRv6fdLSIB68Uys4aqvN6vQn1A4OXneW+yhgS47+oIXpOQwhcCMHul0BU9TDqokR
	 oDX3EZ4dewtJpKBpjs0bHF+kOV5ubLE06mEaexmypzu35H4bZV/ozsSymq0Z8rn5tx
	 ZihHw2QKWnnioYNie3AijedBux1O/Au89V+ddSls=
Date: Wed, 09 Sep 2026 20:51:25 -0700
To: mm-commits@vger.kernel.org,zhoujinmeng@bytedance.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mawupeng1@huawei.com,david@kernel.org,jinmengzhou22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch added to mm-new branch
Message-Id: <20260910035125.6ECCB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix subpool minimum reservation rollback
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch

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
From: Jinmeng Zhou <jinmengzhou22@gmail.com>
Subject: mm/hugetlb: fix subpool minimum reservation rollback
Date: Mon, 7 Sep 2026 21:20:55 +0800

When a reservation request is partially covered by a subpool minimum and
the remaining global reservation fails, the error path first calls
hugepage_subpool_put_pages() for the subpool-backed portion.  It removes
the failed global portion from used_hpages only afterwards.

hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
should be restored.  Since used_hpages still includes the global portion,
it can remain at or above min_hpages and prevent that restoration.  It
then reports the subpool reservation as releasable, causing
hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.

This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
size=10M,min_size=8M.  After a successful three-page reservation, a
two-page reservation which needed one subpool page and one global page
failed with -ENOMEM.  HugePages_Rsvd incorrectly dropped from four to
three even though the subpool minimum was still four pages.

Roll back the failed global portion from used_hpages first, so that
hugepage_subpool_put_pages() evaluates the minimum reservation against the
current usage and returns the correct global adjustment.

Link: https://lore.kernel.org/20260907132055.26696-1-zhoujinmeng@bytedance.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-subpool-minimum-reservation-rollback
+++ a/mm/hugetlb.c
@@ -6861,15 +6861,6 @@ long hugetlb_reserve_pages(struct inode
 
 out_put_pages:
 	spool_resv = chg - gbl_reserve;
-	if (spool_resv) {
-		/* put sub pool's reservation back, chg - gbl_reserve */
-		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
-		/*
-		 * subpool's reserved pages can not be put back due to race,
-		 * return to hstate.
-		 */
-		hugetlb_acct_memory(h, -gbl_resv);
-	}
 	/* Restore used_hpages for pages that failed global reservation */
 	if (gbl_reserve && spool) {
 		unsigned long flags;
@@ -6879,6 +6870,15 @@ out_put_pages:
 			spool->used_hpages -= gbl_reserve;
 		unlock_or_release_subpool(spool, flags);
 	}
+	if (spool_resv) {
+		/* put sub pool's reservation back, chg - gbl_reserve */
+		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
+		/*
+		 * subpool's reserved pages can not be put back due to race,
+		 * return to hstate.
+		 */
+		hugetlb_acct_memory(h, -gbl_resv);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
_

Patches currently in -mm which might be from jinmengzhou22@gmail.com are

mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch
mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch

