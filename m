Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2720318026
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628304; cv=none; b=ibBYcIkPQBBTtoTSvGHS1l56Tjg3DpMcJ1R0lgF2300nyvOsOJGbOFOY3Iv8Vq5lVwL54KCITiKiAPLoneU6qQTFEEea5G2alP4MuM2ZS5TkhP38soIPWyqPLCt24th38kuJXVNONaVFmGiV1WxxC1nNHwPMp46CX9vuFSDD+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628304; c=relaxed/simple;
	bh=rwWG0ipKwUH/SIE4cwStVP5W1dE9bKaEg8kj3+hfmNo=;
	h=Date:To:From:Subject:Message-Id; b=pCj3SM4JIYP/iYFZSxvnsJYpb/mmcUkpL/xrBI0ynu0Ynd8h0amTUKWcNjC3eJ0EVrLxIP0lmOYQYM/QKNYqr5eUNK+Ov8v1T8GAbG8Z2q/hBQPjoWAR+aWLLYjRHUL41GQNageOzApjgikoEzbrM4b5kHKFMSxYCu3/lBwW1QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+A+PG1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+A+PG1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E1DC116B1;
	Sat, 29 Jun 2024 02:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628304;
	bh=rwWG0ipKwUH/SIE4cwStVP5W1dE9bKaEg8kj3+hfmNo=;
	h=Date:To:From:Subject:From;
	b=e+A+PG1rEg3L/D423I8FytpCDHS4UNIb5hVBUdeEGFC5zDEUv5jEp6UqDO+mT0V/Y
	 aoSrT34bIneYKLWaMo05c7Vj2sMLY5ar+jc4ADgvudRRM2HBIvVJ3skOQbeblWGSnA
	 w3kI0YDKBWLVbTlhiBw48h5YUka7BVAcwwihte8Y=
Date: Fri, 28 Jun 2024 19:31:43 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-simplify-gotos-in-page_cache_sync_ra.patch removed from -mm tree
Message-Id: <20240629023143.F2E1DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: simplify gotos in page_cache_sync_ra()
has been removed from the -mm tree.  Its filename was
     readahead-simplify-gotos-in-page_cache_sync_ra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: simplify gotos in page_cache_sync_ra()
Date: Tue, 25 Jun 2024 12:19:00 +0200

Unify all conditions for initial readahead to simplify goto logic in
page_cache_sync_ra().  No functional changes.

Link: https://lkml.kernel.org/r/20240625101909.12234-10-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/mm/readahead.c~readahead-simplify-gotos-in-page_cache_sync_ra
+++ a/mm/readahead.c
@@ -532,20 +532,19 @@ void page_cache_sync_ra(struct readahead
 	}
 
 	max_pages = ractl_max_pages(ractl, req_count);
+	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
 	/*
-	 * start of file or oversized read
-	 */
-	if (!index || req_count > max_pages)
-		goto initial_readahead;
-
-	/*
-	 * sequential cache miss
+	 * A start of file, oversized read, or sequential cache miss:
 	 * trivial case: (index - prev_index) == 1
 	 * unaligned reads: (index - prev_index) == 0
 	 */
-	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
-	if (index - prev_index <= 1UL)
-		goto initial_readahead;
+	if (!index || req_count > max_pages || index - prev_index <= 1UL) {
+		ra->start = index;
+		ra->size = get_init_ra_size(req_count, max_pages);
+		ra->async_size = ra->size > req_count ? ra->size - req_count :
+							ra->size >> 1;
+		goto readit;
+	}
 
 	/*
 	 * Query the page cache and look for the traces(cached history pages)
@@ -572,13 +571,6 @@ void page_cache_sync_ra(struct readahead
 	ra->start = index;
 	ra->size = min(contig_count + req_count, max_pages);
 	ra->async_size = 1;
-	goto readit;
-
-initial_readahead:
-	ra->start = index;
-	ra->size = get_init_ra_size(req_count, max_pages);
-	ra->async_size = ra->size > req_count ? ra->size - req_count :
-						ra->size >> 1;
 readit:
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra, 0);
_

Patches currently in -mm which might be from jack@suse.cz are


