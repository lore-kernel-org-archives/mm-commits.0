Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DAF7DA6A
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976925; cv=none; b=Er8y53pm02yW8IpqclgHXFYwWbgve/fsTRkSVXvfuvbYRLUjBNbsHGwkiUABYVPKV4uDWDzo3WsTkSWj+wG+XCy+THotw2WR/KS4+d0yFOKLS93SVbmvnNnUS1BFpnmbYnRZ2NKXoEjIepAzq/NFhpje3rl4YW53TW6EK3+/0jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976925; c=relaxed/simple;
	bh=K+s8YVquCamTMWbC3GLg5jfPXxGWcz5hGg3jGENUIIo=;
	h=Date:To:From:Subject:Message-Id; b=rO3FouqUKPasSY/yX4uRUVV/ZGP72UsMIP7odPW0j/sBuTRgYY7uxuEB2s6RUjpVSoU4lJWqYtL9lUv9TZMyArMC7kD5GR+CkgzeC7yi4PtKi4VOb795ODda8WEbyHTydRd0kCmdSGGFjgSXWrK0eDEdcR4c0bhdZezSSPUfeZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o9gLfeMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o9gLfeMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC21CC4CEF5;
	Sun, 20 Jul 2025 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976924;
	bh=K+s8YVquCamTMWbC3GLg5jfPXxGWcz5hGg3jGENUIIo=;
	h=Date:To:From:Subject:From;
	b=o9gLfeMzXoSche67UoaxRKzoYG9aEdZp9uy9OKud2VOlm3thkH5Axf7rpZhAFSWYN
	 TQPwIJJTteBzY4XJGqDOBvt8xr4Hn3vid4I3t6n0xaX2lskDAmsfLXsNy219rVZI5a
	 N0gqoqgodxtbIRS8S/ItpFN7Bf3GaEyXl5Q9Xr3A=
Date: Sat, 19 Jul 2025 19:02:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-use-folio_nr_pages-instead-of-shift-operation.patch removed from -mm tree
Message-Id: <20250720020204.CC21CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: use folio_nr_pages() instead of shift operation
has been removed from the -mm tree.  Its filename was
     readahead-use-folio_nr_pages-instead-of-shift-operation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: readahead: use folio_nr_pages() instead of shift operation
Date: Thu, 10 Jul 2025 14:04:51 +0800

folio_nr_pages() is faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Link: https://lkml.kernel.org/r/20250710060451.3535957-1-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-use-folio_nr_pages-instead-of-shift-operation
+++ a/mm/readahead.c
@@ -649,7 +649,7 @@ void page_cache_async_ra(struct readahea
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
 	expected = round_down(ra->start + ra->size - ra->async_size,
-			1UL << folio_order(folio));
+			folio_nr_pages(folio));
 	if (index == expected) {
 		ra->start += ra->size;
 		/*
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are


