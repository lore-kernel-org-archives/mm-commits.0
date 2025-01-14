Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA472397A4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836921; cv=none; b=BH6ixaBWTEbE16uDOlV47WdSwDOyFV4TIf/XjiiSl6jduHkTQD4GsIUsAja3TqcKuDIiD6q/CGB1ToO9biJ+y6uIsoYSEW4y9CBR+AEZk+MRR8B5ftMuZj5xqNlrJ3z7F+9R+XxKMQeMWS3b4ND1C8QLwvucz1vxUq26Zo63wMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836921; c=relaxed/simple;
	bh=igwsRxTnz35GoNnr9hYL2PU8TlNYJ8kxz+use4f05+Q=;
	h=Date:To:From:Subject:Message-Id; b=TQ6eVJqT3wPEvqhnKBOpkkJ5858CqjPHidqzTeis4e4nr3rblXeSKHBeC38yfv/pYB6/gKLXLjnvga0WcKYHjQfxqI4Hu+BC6vr5IbqTBoY0hDOv/Q4uPJ7QH6oO0IoK0ZLtMBHLzsUc9R1KSzq1zKV1nLhxBs14TXSk5Lv9VJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OlngwfS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OlngwfS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EBEC4CEDD;
	Tue, 14 Jan 2025 06:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836921;
	bh=igwsRxTnz35GoNnr9hYL2PU8TlNYJ8kxz+use4f05+Q=;
	h=Date:To:From:Subject:From;
	b=OlngwfS7Qmk5QfccNES5loIyU2pw78XcL+jqDnpNm96uzlri78vyVZ/hjUZQqcMJD
	 xwfxpAPPsO7UB+EgLbiE0/s4qx9kwSazoy0QE31YcXLwDj+K4u6wQ1glk36xvZSwSl
	 Z+kye4CLA21MZ1t1ZTiQSoVaWGG6eRIdVagcHsUU=
Date: Mon, 13 Jan 2025 22:42:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch removed from -mm tree
Message-Id: <20250114064201.61EBEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_cpuset_fallback()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_cpuset_fallback()
Date: Mon, 25 Nov 2024 21:01:39 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_cpuset_fallback().

Link: https://lkml.kernel.org/r/20241125210149.2976098-8-willy@infradead.org
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

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback
+++ a/mm/page_alloc.c
@@ -3566,9 +3566,6 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_
 	if (!page)
 		page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags, ac);
-
-	if (page)
-		set_page_refcounted(page);
 	return page;
 }
 
@@ -3655,6 +3652,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (gfp_mask & __GFP_NOFAIL)
 			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
 					ALLOC_NO_WATERMARKS, ac);
+		if (page)
+			set_page_refcounted(page);
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -4483,8 +4482,10 @@ nopage:
 		 * the situation worse.
 		 */
 		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
-		if (page)
+		if (page) {
+			set_page_refcounted(page);
 			goto got_pg;
+		}
 
 		cond_resched();
 		goto retry;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

