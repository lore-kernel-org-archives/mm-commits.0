Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E9E230999
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836927; cv=none; b=KRnalR4YU91xrk6EDWYPiaQQv/CrRdiny7AxTdueQWO0zWNKbNgx+zmDYhtmtOCLp4VIGhfHD4BQn5jxQl4qW+fF7Rtw31VtDvLeUEayA1cjOp7ZLhZXQrZMI1hE8TONxrh6PNfcKGD6Y+aANUK2zVIvCjZU7pGGOb3CQx7txGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836927; c=relaxed/simple;
	bh=NJYUL6nvwW/nQljLjtGTx6/ZBFy005Cav9N87M9cffw=;
	h=Date:To:From:Subject:Message-Id; b=SJeVl7cAmsf8HWlm2Gatc1N3/qQNWPWAD2JaG60OoFO08l73jSSrXVZtXVvZzBK5qKRSm5Kv9C1iLI+PZxK3ibjVeExICcwS27FublQQWTedbnh/tbSOwwRpOnVbmqax5AA1eeMvR7OsrZXqOOF+RiWC6avs+MACR+RdnmMq95Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdA5SS6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdA5SS6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDE7C4CEDD;
	Tue, 14 Jan 2025 06:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836927;
	bh=NJYUL6nvwW/nQljLjtGTx6/ZBFy005Cav9N87M9cffw=;
	h=Date:To:From:Subject:From;
	b=HdA5SS6OqkHXUM6d22ESSTa9igmolJsDd64iEho2DQ5uF8hYYwKZaVSdBcSgiAORX
	 UZ8oHmjsDL+AUZOFGx/XIZ4hQTpjzF/EFaERov91Og1q7VIEPuGmbpH7VDnYrlOUwK
	 /zT5mD7xvb0u+DCkgp/B3PxIK2L4JibFg3fXUg5s=
Date: Mon, 13 Jan 2025 22:42:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch removed from -mm tree
Message-Id: <20250114064207.0EDE7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to end of __alloc_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to end of __alloc_pages()
Date: Mon, 25 Nov 2024 21:01:44 +0000

Remove some code duplication by calling set_page_refcounted() at the end
of __alloc_pages() instead of after each call that can allocate a page. 
That means that we free a frozen page if we've exceeded the allowed memcg
memory.

Link: https://lkml.kernel.org/r/20241125210149.2976098-13-willy@infradead.org
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

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages
+++ a/mm/page_alloc.c
@@ -4750,10 +4750,8 @@ struct page *__alloc_pages_noprof(gfp_t
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-	if (likely(page)) {
-		set_page_refcounted(page);
+	if (likely(page))
 		goto out;
-	}
 
 	alloc_gfp = gfp;
 	ac.spread_dirty_pages = false;
@@ -4765,15 +4763,15 @@ struct page *__alloc_pages_noprof(gfp_t
 	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
-	if (page)
-		set_page_refcounted(page);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		__free_pages(page, order);
+		free_frozen_pages(page, order);
 		page = NULL;
 	}
+	if (page)
+		set_page_refcounted(page);
 
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

