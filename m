Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9723A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836992; cv=none; b=PpAQvzNVHSR8v1aEId4qzyh/qTeawEPAe0PNVKjVjj7h480D++QVTS+f+cp8xTM6EEUKuqBuIYQBeSLQ5Y36JKDGJ4ntD5JMk/ry8L6AC8sOJH+kMIgxXXk54yEUy9j30osJ+MIFALz9+GhN9bP82f4D8c17Lmp81zPwVi2PrFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836992; c=relaxed/simple;
	bh=UsT5Bk9MVyX30R2ET88ltOW6JN8qCBH02WQsl2yMcS0=;
	h=Date:To:From:Subject:Message-Id; b=Til8thIYlisJwvACo0SKE4sNwQa7yrDZb4StESBA3qlKoEncTIJv40M8T5YOlOh2JQtmz2WjmGdgbdOHO5rCYE8Ik274VhJi97d4wYvrIK9uCsJgF1RWi4K8+BBmUXg3BbE2eFMnltE4qBMDJRJCuOd8IISkqOzDyFQxnLFcZrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HvcUo+oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HvcUo+oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55402C4CEDD;
	Tue, 14 Jan 2025 06:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836992;
	bh=UsT5Bk9MVyX30R2ET88ltOW6JN8qCBH02WQsl2yMcS0=;
	h=Date:To:From:Subject:From;
	b=HvcUo+oySUtRlyD/njM/RH1fyTpOhMRJgsuc4/rZWKSeMZ71roxCYJEuMvwjQruQD
	 m0s2S2DmxOdjQ2vUDhH8cN+clRA/jn4D+HPDN2I6lzm/uE2EqRdxKAKIyKuuzWPbJI
	 RnWt26dVuFFmeOOCLin/4okqCzqs6ygAya0B4ZUo=
Date: Mon, 13 Jan 2025 22:43:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch removed from -mm tree
Message-Id: <20250114064312.55402C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
has been removed from the -mm tree.  Its filename was
     readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
Date: Wed, 4 Dec 2024 19:10:16 +0100

When we succeed in creating some folios in page_cache_ra_order() but then
need to fallback to single page folios, we don't shorten the amount to
read passed to do_page_cache_ra() by the amount we've already read.  This
then results in reading more and also in placing another readahead mark in
the middle of the readahead window which confuses readahead code.  Fix the
problem by properly reducing number of pages to read.  Unlike previous
attempt at this fix (commit 7c877586da31) which had to be reverted, we are
now careful to check there is indeed something to read so that we don't
submit negative-sized readahead.

Link: https://lkml.kernel.org/r/20241204181016.15273-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -448,7 +448,8 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t index = readahead_index(ractl);
+	pgoff_t start = readahead_index(ractl);
+	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
@@ -506,12 +507,18 @@ void page_cache_ra_order(struct readahea
 	/*
 	 * If there were already pages in the page cache, then we may have
 	 * left some gaps.  Let the regular readahead code take care of this
-	 * situation.
+	 * situation below.
 	 */
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size, ra->async_size);
+	/*
+	 * ->readahead() may have updated readahead window size so we have to
+	 * check there's still something to read.
+	 */
+	if (ra->size > index - start)
+		do_page_cache_ra(ractl, ra->size - (index - start),
+				 ra->async_size);
 }
 
 static unsigned long ractl_max_pages(struct readahead_control *ractl,
_

Patches currently in -mm which might be from jack@suse.cz are


