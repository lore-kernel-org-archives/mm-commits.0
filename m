Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F2E2141D1
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902535; cv=none; b=q5zb/+38hPp1M6h+ol3K9vRf+Njvvn6GWSBCKuyLgwDz3Q3hqWpwgGVJSMM/7vG6Fqwr1dqBe99k2k9QTc3AKgmJJ87M3wF1VjrSqcLskgSW9SPaWIFMQ8XdQU+jGoLYO9dqgtVLiSflWK5km47WiOUsJChDDcQOMgayEGVhMAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902535; c=relaxed/simple;
	bh=jdU4G7XM5gcYefEqkiuUcPgfpSzZilY3h2/QWLBP6CA=;
	h=Date:To:From:Subject:Message-Id; b=Z0sTjt/vL+HNBnjzq/8Y4bR+eSMZIoDXUZ5Ml44eQob00LsYj3WDXlaGkK/dSfcAQBqlNgKPrstfTMw1CGm/ymVak1YNmO8Op+1yGtz/z3ely+euhSTnFcG+OZfNz0L5b6Qho1aUK/fDssLAbhMyTo6QTfwYeo2GH5iUmrGyTws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szyOsfqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szyOsfqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D6FC4CEC2;
	Wed,  2 Oct 2024 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902534;
	bh=jdU4G7XM5gcYefEqkiuUcPgfpSzZilY3h2/QWLBP6CA=;
	h=Date:To:From:Subject:From;
	b=szyOsfqTG6WQRd3o3UBDIGWAxyriVTPXJfhExrUvqaYM9C/dOGZEasgw2bvirsIXB
	 K3WigD1ZBmTbuiYihmN6Ssdl4JLppPeRbLN7eEZHBO7F/dTQ1UbKX7mrWX64SB2rXp
	 P6LE6xdww1DgN2LEFtCtkoKSBa1bin13vT5E1BAg=
Date: Wed, 02 Oct 2024 13:55:33 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-convert-should_skip_rmap_item-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20241002205534.78D6FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: convert should_skip_rmap_item() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-convert-should_skip_rmap_item-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-convert-should_skip_rmap_item-to-take-a-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ksm: convert should_skip_rmap_item() to take a folio
Date: Wed, 2 Oct 2024 16:25:29 +0100

Remove a call to PageKSM() by passing the folio containing tmp_page to
should_skip_rmap_item.  Removes a hidden call to compound_head().

Link: https://lkml.kernel.org/r/20241002152533.1350629-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~ksm-convert-should_skip_rmap_item-to-take-a-folio
+++ a/mm/ksm.c
@@ -2401,10 +2401,10 @@ static unsigned int skip_age(rmap_age_t
 /*
  * Determines if a page should be skipped for the current scan.
  *
- * @page: page to check
+ * @folio: folio containing the page to check
  * @rmap_item: associated rmap_item of page
  */
-static bool should_skip_rmap_item(struct page *page,
+static bool should_skip_rmap_item(struct folio *folio,
 				  struct ksm_rmap_item *rmap_item)
 {
 	rmap_age_t age;
@@ -2417,7 +2417,7 @@ static bool should_skip_rmap_item(struct
 	 * will essentially ignore them, but we still have to process them
 	 * properly.
 	 */
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		return false;
 
 	age = rmap_item->age;
@@ -2560,7 +2560,7 @@ next_mm:
 					ksm_scan.rmap_list =
 							&rmap_item->rmap_list;
 
-					if (should_skip_rmap_item(tmp_page, rmap_item)) {
+					if (should_skip_rmap_item(folio, rmap_item)) {
 						folio_put(folio);
 						goto next_page;
 					}
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch

