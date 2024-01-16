Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AA1DA36
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435753; cv=none; b=dOGpUv7RN9eQhaAnp/o5q5NIX3NUNwlP7y0UhYd292uGBCJ32Vd35B/lErV8FpI3nxD1EJsQ0s7rN+Krd32EDCLB9Fr2+f2Y0t633t7aa1E150kfQnGofFmzURjXf/Im1CIfRj2uN5hua5RfBjZgKuxZYA70Oc6jB7RW8owHy0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435753; c=relaxed/simple;
	bh=EONF7vocfNLFi22SHmMV2j/fUxVH/5sbrVJp63/947Y=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=GlMU93SM76yyBxGUU0wz60fkkh0yVUJdjhZWNUlyr1IKB7SVIn5HYSq9Sh9u76d/pP6v9rGZB2SfcEmYlH9wSh4lqT0gdTa7Ly3mVVohyY4DdbH4mbWOgg22QI/jNYsxXRQtAdBBeRbzGAKvUILUsBuPfSzOZivX/kQ9zviIEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BaFa3j1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BaFa3j1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A52C433C7;
	Tue, 16 Jan 2024 20:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435752;
	bh=EONF7vocfNLFi22SHmMV2j/fUxVH/5sbrVJp63/947Y=;
	h=Date:To:From:Subject:From;
	b=BaFa3j1Ep6czH5bIg6EG4Gu9tc1blInUBWDUwceZOvYMOHtliJdOKGznBo2/WLGVV
	 /I47TRoNEL3Iq1WaL0fO+vgvf4zJJRh2IQKZoWLLh2iz3iePPOWThXEmgbt68t5WUj
	 Q56qXwLtgoPAd/1t05fP8GfnJfUGWuPztaizJGXA=
Date: Tue, 16 Jan 2024 12:09:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch added to mm-unstable branch
Message-Id: <20240116200912.92A52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: use ilog2 instead of a while loop in page_cache_ra_order()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch

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

readahead-use-ilog2-instead-of-a-while-loop-in-page_cache_ra_order.patch

