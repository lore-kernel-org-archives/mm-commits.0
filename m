Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8BA3BBFAF
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609805; cv=none; b=GB+S52Z5BjcEtAPPypLZghuUUnCTL57G/fJAd9fqivmR0lC4sxMjucUl4PZhz/JnPgtCfrdkgad6fB1lWg5dx891FoT4hKtK7rpDQPq7DV2cmJJlDm4PW8X3ZgaG05tiOciOM6Gn66npGuqTz1dWu2DfFaM6Iu18uxFP18tRMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609805; c=relaxed/simple;
	bh=EBYLxNy8ISw/IWg+IswUI0uA7tonuN0HeTW4wEZfHrQ=;
	h=Date:To:From:Subject:Message-Id; b=dLaKQfkkjbmJHR5rnO5SSyXK9Gbyk/uBD4gv9vIlV6IipCpR1/LYGPSlx6xJHisBpWEFaalrTWw/LW8TwZ/E86YweC15Sv6w5YPaxGzl7WQJAioImkyw7ZI+P4MfwtNxTsB5lgac1iPFUWAibzDtPLKOpmwIvCngAZppjsSzOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIHZCwCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIHZCwCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134E61F00898;
	Thu,  4 Jun 2026 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609804;
	bh=opzTCeb9TrPgKkMx/0vQgW1v644cCU0yZ5xkZa+409A=;
	h=Date:To:From:Subject;
	b=eIHZCwCUyb5Ci7LyMRf7ZuQdIMZlmk322MTq1NSvQmobmcxCMDUVAGDUy+6laGGtt
	 L/RDpSEDwbO++uM5Aphh6kqzHCnH4ZBdclcjbox0ECJZZYmCoElCfpbsjrWFGSdiH+
	 aUcoxeKgyjqvVC//isCA841WF5SSgww+xxjz62PU=
Date: Thu, 04 Jun 2026 14:50:03 -0700
To: mm-commits@vger.kernel.org,lk@c--e.de,akpm@linux-foundation.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch removed from -mm tree
Message-Id: <20260604215004.134E61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()
has been removed from the -mm tree.  Its filename was
     lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()
Date: Tue, 26 May 2026 18:43:40 +0200

alloc_pages_bulk() is not guaranteed to return all requested pages in a
single call.

Call it repeatedly until all pages have been allocated or no more progress
is being made.

Link: https://lore.kernel.org/20260526-kunit_iov_iter-alloc_bulk-v2-1-24fbcd995c61@weissschuh.net
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk
+++ a/lib/tests/kunit_iov_iter.c
@@ -53,7 +53,7 @@ static void *__init iov_kunit_create_buf
 					    size_t npages)
 {
 	struct page **pages;
-	unsigned long got;
+	unsigned long got, last;
 	void *buffer;
 	unsigned int i;
 
@@ -61,7 +61,15 @@ static void *__init iov_kunit_create_buf
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
 	*ppages = pages;
 
-	got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
+	got = 0;
+	while (true) {
+		last = got;
+		got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
+
+		if (last == got || got == npages)
+			break;
+	}
+
 	if (got != npages) {
 		release_pages(pages, got);
 		kvfree(pages);
_

Patches currently in -mm which might be from linux@weissschuh.net are


