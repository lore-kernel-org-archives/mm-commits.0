Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C9635285
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iHF9/4QX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B413AC433C9;
	Fri,  5 Jan 2024 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478721;
	bh=X3F3nCJUIbIzMMwgN2DFHnUn0DOYG8K22PQ0NRreUVY=;
	h=Date:To:From:Subject:From;
	b=iHF9/4QXYnbLtzFJUEYslHFf5zxQnDf7wk8oyCf9LQIDpmvHOZ42MqNjRxqfy1mOd
	 u5ENm4i2BjAchuyrr2pjbQKWz+l9SRSfG3gAuk+mkMrtnSclbR/tTcGIs+iF8vSCOD
	 mYubjEG6xMvUmLRONMbgZSXRyzFffq859CHlH0Kk=
Date: Fri, 05 Jan 2024 10:18:41 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-inc-dec-lruvec-page-state-functions.patch removed from -mm tree
Message-Id: <20240105181841.B413AC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove inc/dec lruvec page state functions
has been removed from the -mm tree.  Its filename was
     mm-remove-inc-dec-lruvec-page-state-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove inc/dec lruvec page state functions
Date: Thu, 28 Dec 2023 08:57:43 +0000

Patch series "Remove some lruvec page accounting functions", v2.

Some functions are now unused; remove them.  Make
__mod_lruvec_page_state() unused and then remove it.


This patch (of 6):

All callers of these have been converted to their folio equivalents.

Link: https://lkml.kernel.org/r/20231228085748.1083901-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231228085748.1083901-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/include/linux/vmstat.h~mm-remove-inc-dec-lruvec-page-state-functions
+++ a/include/linux/vmstat.h
@@ -597,18 +597,6 @@ static inline void mod_lruvec_page_state
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __inc_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void __dec_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void __lruvec_stat_mod_folio(struct folio *folio,
 					   enum node_stat_item idx, int val)
 {
@@ -627,18 +615,6 @@ static inline void __lruvec_stat_sub_fol
 	__lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-static inline void inc_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void dec_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


