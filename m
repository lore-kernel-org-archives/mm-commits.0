Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197F75CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957027; cv=none; b=PSxh/FPXGpbtOw8AIh2BGmXH/Z4se4+nXrbO14Tz/kh8zVNo78pAtFdU45E4VM0fxspwaDpPA8OS1U7cDIwnykFP4ewaLRbv8pC5usKb15bmK2IYzJ/Kw0urAQGY6i1GVuJiKPURZn4wavqGk1DzYDNKsv2YhWUrUstYWXYQAyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957027; c=relaxed/simple;
	bh=PYXzvi1hKYeUoedQ2h0eVb4s1NBxcUeXFJgeQtw9BnM=;
	h=Date:To:From:Subject:Message-Id; b=AzWRerm/oCEX9CjKMfMh1+z0rwn3jqa1l1Yjti7X88Wz6mStUuRzEHRMVoLGbmryIslt8J5EDxpTuMB8ux8lamxqhfZy6XQkPcHITLHJbwmty+lTkxrR+r2x+Kokqr4yBZFj0S18xdQxaIPOdEf/ShXakalY/jmqmVnIw36MKgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DeTflj6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DeTflj6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A1C113CC;
	Mon,  6 May 2024 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957027;
	bh=PYXzvi1hKYeUoedQ2h0eVb4s1NBxcUeXFJgeQtw9BnM=;
	h=Date:To:From:Subject:From;
	b=DeTflj6CWb2BG8KK/yfe/FaRiiOMPBjSEFRIGGGVPbpCNgC3yEDOsX7s5KZv/pPRx
	 uGpw8CXqn7zH9zzC5G3s1AvSvvALPDIHaBSVpBvheJqzMUZFOqbthI+ndK/Izx2uMw
	 gxB+QYcKggXJ/5Wjd4hMM2Rj1gnXjmbdgCqxx96g=
Date: Sun, 05 May 2024 17:57:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch removed from -mm tree
Message-Id: <20240506005706.E66A1C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use ksm_get_folio in scan_get_next_rmap_item
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use ksm_get_folio in scan_get_next_rmap_item
Date: Thu, 11 Apr 2024 14:17:07 +0800

Save a compound_head call.

Link: https://lkml.kernel.org/r/20240411061713.1847574-7-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item
+++ a/mm/ksm.c
@@ -2611,14 +2611,14 @@ static struct ksm_rmap_item *scan_get_ne
 		 */
 		if (!ksm_merge_across_nodes) {
 			struct ksm_stable_node *stable_node, *next;
-			struct page *page;
+			struct folio *folio;
 
 			list_for_each_entry_safe(stable_node, next,
 						 &migrate_nodes, list) {
-				page = get_ksm_page(stable_node,
-						    GET_KSM_PAGE_NOLOCK);
-				if (page)
-					put_page(page);
+				folio = ksm_get_folio(stable_node,
+						      GET_KSM_PAGE_NOLOCK);
+				if (folio)
+					folio_put(folio);
 				cond_resched();
 			}
 		}
_

Patches currently in -mm which might be from alexs@kernel.org are


