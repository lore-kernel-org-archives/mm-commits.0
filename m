Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752C1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836925; cv=none; b=YA4nG0VcSMA7N6JqPGE3/RRAN3hN+qWzo6AgIJ126wjB0YTxkytEj1fnpRSwzs3mVcoSPSMvaIrIQ5pL/yYXtHvF3QS0X/m42yA8VXQF3Oggwt9kYLOp9BbXEh2GxjnebNsR7PS3sVqItRDsAWXMlI4DtuIcEfnFbD1DBlvv3Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836925; c=relaxed/simple;
	bh=U/+Ayrt/b63Zs5ZOY/qyGfX5ydfgG+BZEl0Y9UV2VLs=;
	h=Date:To:From:Subject:Message-Id; b=RmPKkRpPwgpeDW6eJ4ESnAkIGjHU4ZT3xrSbldNzprh7j5I/ypRUoEHfeHPIGJg4CAc64px+6E6pE/9rPQlsO3Yc7+EOZ+cbSGqcSLJMryNNicSUnyTOCK1e0w0M/+1D+uDfOU2JwU2bh1PJ5CwolcZvLXMwFoXHZch3PTomm4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lZ6ebbxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lZ6ebbxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A95C4CEDD;
	Tue, 14 Jan 2025 06:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836924;
	bh=U/+Ayrt/b63Zs5ZOY/qyGfX5ydfgG+BZEl0Y9UV2VLs=;
	h=Date:To:From:Subject:From;
	b=lZ6ebbxWIOzJRXM24AQ3I3De4icYZV+No7wGKtMhjyLcqfH+uxGtvLYQ0pWuxOdj1
	 mOI5y4482qxZDyJ2/lEwvUsSrjsp9u5cxIjT9WJnttgyzAR7M4H5elbPxCRJ8e13hd
	 uQ+QF8XzYjcyHF9+BY1N/I4+h7vO0jwdfEqkejMg=
Date: Mon, 13 Jan 2025 22:42:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch removed from -mm tree
Message-Id: <20250114064204.C5A95C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_reclaim()
Date: Mon, 25 Nov 2024 21:01:42 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_direct_reclaim().

Link: https://lkml.kernel.org/r/20241125210149.2976098-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim
+++ a/mm/page_alloc.c
@@ -3964,7 +3964,6 @@ retry:
 		drained = true;
 		goto retry;
 	}
-	set_page_refcounted(page);
 out:
 	psi_memstall_leave(&pflags);
 
@@ -4386,8 +4385,10 @@ retry:
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
 							&did_some_progress);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

