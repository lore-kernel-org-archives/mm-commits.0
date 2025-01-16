Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22018A6C1
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006307; cv=none; b=qAPkYhSEz994KGdckK5unCYLCGYCnmc6yhpjuggB2ni3Q1I5qYOKx0cXNVlIcZD374+c3trwvSnD1l8U67KL1TC/gyec6+F6HkFQ2lcp85XvXWG00XqoXE9BjOhF4Dq+3qxzUpVoThlto3CHkX5z5/JS1qR+oVbitZuJ4vRbyTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006307; c=relaxed/simple;
	bh=z6mBpaRjYiUN1/lP0iDjEQSR3B9V2xC5BO6Dwkx7Y4Q=;
	h=Date:To:From:Subject:Message-Id; b=PByUJhx03DLMr6h1mBaGz4IjD2wDZl5HlbBEKl3nZJekuduvEGdz/P4GtC/aZyr2xkgUkC1kbhwBc+2mYGB3Rq1MhAoqXQITTfiy3sA0Trw5nsIUk80VGJxGZlik028QDc0BS2hM1ejBpogf9Xn9Wmd2O1LCoFyOJviX3LvSxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgsClIkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgsClIkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A6FC4CED6;
	Thu, 16 Jan 2025 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006306;
	bh=z6mBpaRjYiUN1/lP0iDjEQSR3B9V2xC5BO6Dwkx7Y4Q=;
	h=Date:To:From:Subject:From;
	b=wgsClIkCsBOp9ZbW9I4X545YVmRgzojIZb7hqZJzBVyRS8OM5fN3G/NOkIWEdlNn3
	 iHr/SfxofF2GQTTJs0ybL45RGtFewu0grRONx323ZdbQ6wgN2vN/bCGhJlgkqSFL50
	 Gs4Qi+PfG8hiWChlXF46+0YnJ3Tz3qJ77egVNC6k=
Date: Wed, 15 Jan 2025 21:45:06 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch removed from -mm tree
Message-Id: <20250116054506.C0A6FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: increment pa_stat damon address range by folio size
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-increment-pa_stat-damon-address-range-by-folio-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


