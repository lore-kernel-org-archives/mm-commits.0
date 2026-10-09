Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AB83AE189;
	Fri,  9 Oct 2026 05:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525486; cv=none; b=p+Rl51hB1r6c22udruWvpPWN64aESqJiQ/UkkDoyH/1419Laq2TwwbLXwVZ0Nw35T+t6iJSV6WwSD0PlYB1Wds6cdRCQGSqbKXoyUMNrA4sSP8zcK04beVPy2Cinaj8oP4gSeu9LcsRLRHM4teuvUi28dDOBJYuMmEkR0dcyqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525486; c=relaxed/simple;
	bh=RiDw7cbx6Iyk3iEq+AoKlyMw1V+Ol7CPNJID+STDhcY=;
	h=Date:To:From:Subject:Message-Id; b=fdRfVe6RJ//rms9+eGQPiRST7fLA0xJKX2L4ozMria7OgqpMD2iGgn1aQ+LAYbgogcLzhr4M/YJtD3i0opG4hd/CntSQcL031i73o3h/vvY/Nf341ZTBYcDexGRKquu46YkhnDJ8OtFNWgskDOfU3Joau1NfzNgAVG7E7setBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l3qcwmDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l3qcwmDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50A1F00893;
	Fri,  9 Oct 2026 05:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525485;
	bh=eu0lXved5jcyWNz/du7wCwliZmYKXQEU28NH+sk8pJ8=;
	h=Date:To:From:Subject;
	b=l3qcwmDywASaf6CLswuEl/Hkwy0+fnT9/jK9kr0nWKT0LiB9FAY82GPqtnZ9Smd+7
	 HxJMLMWZif0vvCjWpvAVvFYc8T68CQ8htECfpDWapfuWPNDebLdQf2GjaQXxkAiV/o
	 BIW/ji2GBORTHD966NEHVVC5Rxao2t7wWiG+BDh4=
Date: Thu, 08 Oct 2026 22:58:04 -0700
To: mm-commits@vger.kernel.org,zhoujinmeng@bytedance.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mawupeng1@huawei.com,david@kernel.org,ackerleytng@google.com,jinmengzhou22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch removed from -mm tree
Message-Id: <20261009055805.1E50A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix subpool minimum reservation rollback
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-subpool-minimum-reservation-rollback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-subpool-minimum-reservation-rollback
+++ a/mm/hugetlb.c
@@ -6854,15 +6854,6 @@ long hugetlb_reserve_pages(struct inode
 
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
@@ -6872,6 +6863,15 @@ out_put_pages:
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


