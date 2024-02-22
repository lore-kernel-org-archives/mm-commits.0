Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40FE125CB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560085; cv=none; b=mePXcNCiIy6L5j2SmTOLCs7LWD3Al9Jdm1VMsIKJFOYeuCU4Qro9leWpk6vK4ME6QL+QzUK1HXkC9IXPtssT4OsoNUoQ4VOQaBF1tTnvLBN1oTq9s0bnG/HyS1ybVuzTwGeMD8Pi35E3j6LtDbiHWzYQiuPeTMD8OFpV/N0BdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560085; c=relaxed/simple;
	bh=0eqs0Auguu4RO/+L94IRW9gef3r6kBa4TTFrtkuNGs4=;
	h=Date:To:From:Subject:Message-Id; b=jcMx1QPe2dr6vwhZ5hJMZVkcy6OjrvSwwQcnuF5JuefeLLYrC1hn8C0r511boZpbET5LncCjm8TL9Gqhaguv7xcKityOwO4w8PbtIHSvd5gmZj3nnEJXyoul3948JXOK+/HM7WpWX0RGX5icmD4MG4eX5CvmAPs4JAURd+MVPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pO/9RBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pO/9RBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D926C433C7;
	Thu, 22 Feb 2024 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560084;
	bh=0eqs0Auguu4RO/+L94IRW9gef3r6kBa4TTFrtkuNGs4=;
	h=Date:To:From:Subject:From;
	b=0pO/9RBvjckV2UPHLyYe5fxMFXHBypTeUfPfecP44lYkzveCsqsjYdExKbzBFMfwc
	 eM6F3S3kWAPTOZ2nY5+YJ6v/kDsu+bmvE6lfnY8GYTZg9MGZF6r0GuoFsCyaFq39QH
	 Wcb7GCgTNMwKNKWOrz7GjRepvf/8e5B7paNnTqis=
Date: Wed, 21 Feb 2024 16:01:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch removed from -mm tree
Message-Id: <20240222000124.6D926C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: use ilog2 instead of a while loop in page_cache_ra_order()
has been removed from the -mm tree.  Its filename was
     readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: readahead: use ilog2 instead of a while loop in page_cache_ra_order()
Date: Mon, 15 Jan 2024 11:25:22 +0100

A while loop is used to adjust the new_order to be lower than the
ra->size.  ilog2 could be used to do the same instead of using a loop.

ilog2 typically resolves to a bit scan reverse instruction.  This is
particularly useful when ra->size is smaller than the 2^new_order as it
resolves in one instruction instead of looping to find the new_order.

No functional changes.

Link: https://lkml.kernel.org/r/20240115102523.2336742-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/readahead.c~readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -500,10 +500,8 @@ void page_cache_ra_order(struct readahea
 
 	if (new_order < MAX_PAGECACHE_ORDER) {
 		new_order += 2;
-		if (new_order > MAX_PAGECACHE_ORDER)
-			new_order = MAX_PAGECACHE_ORDER;
-		while ((1 << new_order) > ra->size)
-			new_order--;
+		new_order = min_t(unsigned int, MAX_PAGECACHE_ORDER, new_order);
+		new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 	}
 
 	filemap_invalidate_lock_shared(mapping);
_

Patches currently in -mm which might be from p.raghav@samsung.com are


