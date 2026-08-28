Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF55286A4;
	Fri, 28 Aug 2026 05:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894656; cv=none; b=dBVwZ8NaLGlxd4DyOnxaPiMIaWCAoUgYyExyjMhu1rrHmCmZEXSpaEGYCo6wz6P/odazxrt/UWlpOyRcHdBMBg6AGo7ySyeu5LDegH9aN69HSEo0NLur2Qv1gqEbZEnrPImhfrx0ksYFGkj00RY1YXksjhsIT17CrznmfMNNm+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894656; c=relaxed/simple;
	bh=B/0U0CjwUI5gW/n0hYA+NDtnk5ISAgC9k1Fu3V9HeDQ=;
	h=Date:To:From:Subject:Message-Id; b=JjnS3zZ3QPCOa8x6i5wIn2exI7CfMyaUYu7zJ+W52DwfvaLwsERLBCXDyJ+99X5SK9bR+Rtq3u0aANbJFHMmVLxWIp7VDv6clGYzPa7dU2cfio5rIBoof8cd22fQiV0pwJxyMbGV/0M9xUxx+UtOADj/ejJCFptXwJRY7TjjR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNeXgVH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNeXgVH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCC31F000E9;
	Fri, 28 Aug 2026 05:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787894654;
	bh=co+YF3VyHrGd4vvw0Sx5GoXaZsf/v6LgaFcueNjRi/Q=;
	h=Date:To:From:Subject;
	b=wNeXgVH7mP+zsKYyUrgpUbaKkAxJ2YdANbwcu75pwcs1Nvi/98Y3Z4e+xKIh0qT9y
	 JhhYGGayhnp3Lcenn+kyqKZeMpxFEQInnFWtYMVAmtU+Yf077K7vtXcc4WJbLld0vE
	 XY83CHhqndGk7MZDl2nk9c034r+0/abFdJYlIF4w=
Date: Thu, 27 Aug 2026 22:24:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,linmiaohe@huawei.com,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch added to mm-hotfixes-unstable branch
Message-Id: <20260828052414.6DCC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: do not dissolve gigantic pages without runtime support
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:51 +0800

dissolve_free_hugetlb_folio() doesn't check
hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
update_and_free_hugetlb_folio() silently bail for such folios, so it frees
a still-listed folio and, on vmemmap restore failure, the
add_hugetlb_folio() rollback corrupts the free list.

Link: https://lore.kernel.org/20260823044118.1097121-2-xialonglong2025@163.com
Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support
+++ a/mm/hugetlb.c
@@ -1967,6 +1967,15 @@ retry:
 		struct hstate *h = folio_hstate(folio);
 		bool adjust_surplus = false;
 
+		/*
+		 * remove_hugetlb_folio()/update_and_free_hugetlb_folio() bail
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_folio() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic_no_runtime(h))
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch

