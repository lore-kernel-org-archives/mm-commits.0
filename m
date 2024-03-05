Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5158C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600523; cv=none; b=ceOKI+LcvNP4ECnB+EHQRiIjKCCZIPJbYImDP8k9QAt6Gfgx2270IMl+JMs6DHiE+N7QrT9hokwBvCSt6ipeZkj5665elkqt2LAIIAEKjeJQ5pl2E1Brp2oGepCsjBRudPbo0q5ojvYTbaEyUiYAIEUVitweKkbxsfo1BRPbbYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600523; c=relaxed/simple;
	bh=wvU7z6INzkc/lB6tq14A6/zE5fUXMpblKW08fBTH4IE=;
	h=Date:To:From:Subject:Message-Id; b=aWK2RSolZTKmdcAh0mke0mwPMsKUeXt5dwcw4/DuoVQBO3pOPP0Q74KSxS3MJPnIx4BZgJ4m7L31n0HUtk8bab/Bhf1tBihAL0MRWZqSmWfMsUO/PWhGjV27aqkckMIhKyBcuMW4YwC6Qjzryi5wSbhd49kFML0lW6UoVp9LBkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q187mMnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q187mMnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72496C43390;
	Tue,  5 Mar 2024 01:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600523;
	bh=wvU7z6INzkc/lB6tq14A6/zE5fUXMpblKW08fBTH4IE=;
	h=Date:To:From:Subject:From;
	b=Q187mMnMvdDvC5CN658cMxBE+jPxFEyz5ghhjxDoHTcB6c9al8eS1e/+JEYpyoC6Y
	 ETezIkTlZ8Vve0+K0WsvKs7aofjBsI0/OX/wJ+AXjRB9W74MZiHbAQTd3xQs2R6SJI
	 FCszwBv8juMNK7S2Sknrn3FagcZ35tvPx03SEVfo=
Date: Mon, 04 Mar 2024 17:02:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-check_new_page-return-bool.patch removed from -mm tree
Message-Id: <20240305010203.72496C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make check_new_page() return bool
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-check_new_page-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page_alloc: make check_new_page() return bool
Date: Thu, 22 Feb 2024 17:19:32 +0800

Make check_new_page() return bool like check_new_pages()

Link: https://lkml.kernel.org/r/20240222091932.54799-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-check_new_page-return-bool
+++ a/mm/page_alloc.c
@@ -1422,14 +1422,14 @@ static void check_new_page_bad(struct pa
 /*
  * This page is about to be returned from the page allocator
  */
-static int check_new_page(struct page *page)
+static bool check_new_page(struct page *page)
 {
 	if (likely(page_expected_state(page,
 				PAGE_FLAGS_CHECK_AT_PREP|__PG_HWPOISON)))
-		return 0;
+		return false;
 
 	check_new_page_bad(page);
-	return 1;
+	return true;
 }
 
 static inline bool check_new_pages(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from gehao@kylinos.cn are


