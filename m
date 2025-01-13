Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F121C1FA8F4
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736812352; cv=none; b=IZ3hmMsxoV560lMnmfydOet3IczoiEsKv8eMfJqB9b9WPJpNROC4zy0YvfWnPLC4IscVGNCMaKMfja9o09wgTDQwwC257SrINt4WJpmz7MYjfq7q8oCcmEIJFI8NBz+tTCSzPdazSpvzoJGAuM4GCOhMutdMDnjlkXO4ywDkP/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736812352; c=relaxed/simple;
	bh=I820TvaWBI5h9KO7XvJLcgWC6sVU7tBeBHKkxIV1J/o=;
	h=Date:To:From:Subject:Message-Id; b=LatPRLmO/1558Q9FBI9J5kTS+ESee5E15n7kFUD6GPnYqpSxNs6AmswlawvLLwBvQJnflnFzLl9S3LnawaEyiSdwOphWHn4WphC0D/87wX471X0OHH7rOgxic0ZUWjRTS9ogoip6oBFQwM445Od2reAdb4chKHEovD4U1SQFhVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhG0gvBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhG0gvBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F9C4CEE5;
	Mon, 13 Jan 2025 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736812351;
	bh=I820TvaWBI5h9KO7XvJLcgWC6sVU7tBeBHKkxIV1J/o=;
	h=Date:To:From:Subject:From;
	b=PhG0gvBPFQimUIJwNfTPqTwBqR2aPtky6mDiMZ/SqJEQztSVM2fSPWD4YEEe3rkeT
	 VV8ScwfkFMEwuFoG2Pv07EfUItxHo3pEoVpHgZHjQUVm+I9U8F0W79dwJ88+/6Pr/L
	 bMkY7EfuE8WEteo8DlfDFrgEp6JBsHNg0OR/BexM=
Date: Mon, 13 Jan 2025 15:52:30 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch added to mm-unstable branch
Message-Id: <20250113235231.445F9C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: increment pa_stat damon address range by folio size
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/damon/paddr: increment pa_stat damon address range by folio size
Date: Mon, 13 Jan 2025 19:07:38 +0000

This is to avoid going through all the pages in a folio.  For folio_size >
PAGE_SIZE, damon_get_folio will return NULL for tail pages, so the for
loop in those instances will be a nop.  Have a more efficient loop by just
incrementing the address by folio_size.

Link: https://lkml.kernel.org/r/20250113190738.1156381-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size
+++ a/mm/damon/paddr.c
@@ -504,17 +504,21 @@ static unsigned long damon_pa_stat(struc
 	if (!damon_pa_scheme_has_filter(s))
 		return 0;
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
 			*sz_filter_passed += folio_size(folio);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	return 0;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch

