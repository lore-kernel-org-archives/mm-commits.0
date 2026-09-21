Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2014B345EB5
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963812; cv=none; b=a1x+TIr2iO7FBYLNYAal4rcYuwO8/5Ei69Vo2ilresl8bYcbI0de/8rK+ArwbGybXb1cLq5q4tGhy3gRnPAzDJWQiu+HHIUn+YLXdLmW6I1fLmbj/+RkmttJ9bQ+19bn+r+OaJ2QJGEjkMs+17rb5S9GQrxkQm2NueKDM6nG9hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963812; c=relaxed/simple;
	bh=C4ofC2vR/5EV+nHditDesWedzTlMgSSbRzdXiiI/N44=;
	h=Date:To:From:Subject:Message-Id; b=JsMdnI1LnB5GAmBK5K/PbUlY/EBsqTe5pEwG3HWtzKfkXUcFvFO7pnFXl/Dm43W6On4G9Sgf7dZqj75a8JlcqRh6NmrHRWWBG9NtNglfpMhNUreiqVkuY3NMejDbNDauqVxdK9ayo5HR5vzt0ezyLm4foqhBPuuyIRUsrzyiEIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2PQSfVge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2PQSfVge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C6F1F000FF;
	Mon, 21 Sep 2026 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963811;
	bh=HRVTPJGdE2VWWBmvZBjJ22kMPaWTT+PMe1K5j5fePsg=;
	h=Date:To:From:Subject;
	b=2PQSfVges4oLp+s9KcDjXKaK+B5QHGZJ69fLagtzB+8ERE6lW0Xe8YCGx4yguur0u
	 kYPQnoRDeTZlGyZLNG2jSK3iw+x76jFBGwkz63stTpcK7ztdgVFysEdLUOzxr/mTRz
	 oL1yx+DHX8bpqn3Tu5Fgq0yNF99xRtLRO2TqS6dI=
Date: Sun, 20 Sep 2026 21:10:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + md-use-folio-apis-in-free_page.patch added to mm-unstable branch
Message-Id: <20260921041010.E6C6F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: md: use folio APIs in free_page()
has been added to the -mm mm-unstable branch.  Its filename is
     md-use-folio-apis-in-free_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/md-use-folio-apis-in-free_page.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: md: use folio APIs in free_page()
Date: Sun, 20 Sep 2026 22:28:10 -0400

Convert the page to a folio.  This removes some of the last uses of a few
page APIs (detach_page_private(), page_buffers()).  Replaces two calls to
compound_head() with one.

Remove the early return in free_buffers() to avoid memory leak and
uninitialized file bitmap pages.[1][2]

[ziy@nvidia.com: drop early return]
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-14-bb68b6a21869@nvidia.com
Link: https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e%40nvidia.com?part=2 [1]
Link: https://lore.kernel.org/all/aqgfA0QFi98gXYG2@casper.infradead.org/ [2]
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---

 drivers/md/md-bitmap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/md/md-bitmap.c~md-use-folio-apis-in-free_page
+++ a/drivers/md/md-bitmap.c
@@ -533,19 +533,15 @@ static void write_file_page(struct bitma
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_detach_private(folio);
 
-	if (!PagePrivate(page))
-		return;
-
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
 		bh = next;
 	}
-	detach_page_private(page);
-	put_page(page);
+	folio_put(folio);
 }
 
 /* read a page from a file.
_

Patches currently in -mm which might be from willy@infradead.org are

md-use-folio_alloc_buffers.patch
md-use-folio-apis-in-free_page.patch
md-remove-the-last-use-of-page_buffers.patch

