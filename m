Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142F45D90F;
	Fri, 18 Sep 2026 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710226; cv=none; b=oT+D73IlBMdgsgxwcDMV6oDGLljB6zDg0Io/zmmhILbla47thJPIVfa4tznG9URd385VxT4EFIQZOzTjHuFfKyrhlEX3yAB/kn3l134tFl/Mp9nAXQXg5qLBbRFHTAsQgYOrvwAJDsTirmDkYru9xA3mgyvO024TqTfpQe8Hkkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710226; c=relaxed/simple;
	bh=CxTsqGLX86JLRsmK3PVTEroNROceTL2SOTREFofHegg=;
	h=Date:To:From:Subject:Message-Id; b=ClIQFQcKpE/H3RFLgWKA6gmhdsLemADor0S8VQa30N3UGJVO4rjwcxA5ASUy1iJAnZj1SevixDptCvCBD/+u+FIGstXTY+bFw9APr3ea1DGgubgZvrHUQxKRuiLIlDS7rLWGBXwGi70xUNNy9OkSac6TWpBxBNhBD4ydmozLBgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdh0Hd+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdh0Hd+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB661F000FF;
	Fri, 18 Sep 2026 05:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710224;
	bh=HyUDbwb97c9Nl7fyLsqXZ19YOBQM3yhT8AONr3SRJmA=;
	h=Date:To:From:Subject;
	b=xdh0Hd+CLerzsHWf3cfFiDyOG16Xwt/bNDqTWYW8U02uSG610+YtG+FqnMO8G1XlR
	 u1SreN5Q+kFzLqB5aQ2flUXPQ/UUavo3Jn7pgYB51AoklHnQZkPEc1hs4bvTiDRWhB
	 qmNJ0uHeq4jOvpCGDUqvSZ8y7A2xch22bayJ2Ymk=
Date: Thu, 17 Sep 2026 22:43:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,linmiaohe@huawei.com,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch removed from -mm tree
Message-Id: <20260918054344.9BB661F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: do not dissolve gigantic pages without runtime support
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Codex:gpt-5.6-sol
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
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

mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch
mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

