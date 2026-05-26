Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F992868A7
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779827329; cv=none; b=fgWSfbVCLeSirXu5stQ1+o9I+XjK/rBsOUHVFK8sHdISmZVta5tQ1/gId1BGrnsIJk/uqk8zobph/AELIxnhUsZkQ90JJOrjYj3Z2lcCpXO4CIKJTjiqJZqT8Niz1G2//CHZrCtuDF3+CDHDDPDtKNWMNEDrIPy9Dgjxucr/sEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779827329; c=relaxed/simple;
	bh=4tJ5nWmJmx6AqQ1bTTAsHcYa5J+ycqXsePw4w0SIAc4=;
	h=Date:To:From:Subject:Message-Id; b=EKBOXW9CZffZuUcCTbHmMnVOHulyGY5RcdrREAoHE0mJlJFDQ4nWNt3xjKf758rIKlNUNNKl29LKx9ApombnRDCakqoKAyeg1gHJpgK5uozjIBem0ME3mWIs4DIMzdGvZxR31ys994EUPInubjIDbegAoR2M+vi/PG6ij8lrvpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z/CqqsOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z/CqqsOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B29C1F000E9;
	Tue, 26 May 2026 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779827328;
	bh=bfTWpKI+nLXgC06NripCIRWrOnIuSC59a3dB9WWVhKA=;
	h=Date:To:From:Subject;
	b=z/CqqsOAwqKQoYMB/V58vzxo2zij12+gamt6exDHNOuPuYlB+c62CvtBjhQbr9sQ3
	 bvEdR2qyVekRYafOeFMPhJkTaLDZCOmjxoGyCXR9rUslKeEwplT2kXkStHIhBox/u1
	 +yU/en3Xbp4FzWGPk6FNUC8XWitDIpZi+uE59S7M=
Date: Tue, 26 May 2026 13:28:48 -0700
To: mm-commits@vger.kernel.org,lk@c--e.de,akpm@linux-foundation.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch added to mm-nonmm-unstable branch
Message-Id: <20260526202848.7B29C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

lib-kunit_iov_iter-repeatedly-call-alloc_pages_bulk.patch

