Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F0391512
	for <mm-commits@vger.kernel.org>; Tue, 21 Apr 2026 07:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755992; cv=none; b=SLLDZ8+bIvmPUGvtGeAMAo5nHt+p0Yq/xk2rzYmYbNl1uu24Gk+Mx5O8qTUe7PDyWfHGa9+WLCbDG76/uEAHkktzHyaKvzJUIVIhg5oljjC9DNmPsKMQbtkUgRLgbO/4LhEXmTk+aT8h9EBQ4DDz4nmISvqRnMmPhWID8M6+X/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755992; c=relaxed/simple;
	bh=YSJjlUmCynCge3sBSYOA6fP2Yd/ACxkd7iL2FrCep+k=;
	h=Date:To:From:Subject:Message-Id; b=RcPhwm+n9nbS6nVCstcQUv7vlM3zR+5YiUFFq+HdCu+uIx63DUdKWb2Fc6nhy9ShlXSdzGOLFF8w5cEhFiTIr96IIYkRdQSE7vaOta3xHLmNLwjtqjzxTCnuYlIuoDRG80Jfuq9Y7p+7CvBa1sw2m+y0LML+kYtrEiq6RBo8xpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZiF76hb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZiF76hb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111ADC2BCB6;
	Tue, 21 Apr 2026 07:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776755992;
	bh=YSJjlUmCynCge3sBSYOA6fP2Yd/ACxkd7iL2FrCep+k=;
	h=Date:To:From:Subject:From;
	b=ZiF76hb+f2uyM/AJEyylIAQw7U+lpXiAOR7X2tGHStO2/g+57wxgTKHx3egfpBFV3
	 f5ppSahu0hIxWqJxI6K4wZ7F6ixbD1IYqBeHnm4gBBQjMzBM9G7ubQxUdkexeVzR5z
	 2qM36ZgfmND8rRez3KK/3klGSwezCXwHaXYGqQqw=
Date: Tue, 21 Apr 2026 00:19:49 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260421071952.111ADC2BCB6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit_iov_iter: fix test fail on powerpc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: fix test fail on powerpc
Date: Tue, 21 Apr 2026 09:07:07 +0200

Increase buffer size to accomodate machines with
64K PAGE_SIZE.

Link: https://lore.kernel.org/20260421070707.992873-1-lk@c--e.de
Fixes: 0913b7554726 ("lib: kunit_iov_iter: add tests for extract_iter_to_sg")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reported-by: David Gow <davidgow@google.com>
Closes: https://lore.kernel.org/34a81ec2-af84-465d-9b5e-7bb5bf01680f@davidgow.net
Tested-by: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-fix-test-fail-on-powerpc
+++ a/lib/tests/kunit_iov_iter.c
@@ -1128,7 +1128,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct kvec kvec;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	kvec.iov_base = data.buffer;
@@ -1146,7 +1146,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct bio_vec *bvec;
 	struct iov_iter iter;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	bvec = kunit_kmalloc_array(test, data.npages, sizeof(*bvec),
@@ -1173,7 +1173,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	folioq = iov_kunit_create_folioq(test);
@@ -1190,7 +1190,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	xarray = iov_kunit_create_xarray(test);
@@ -1206,7 +1206,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, true, &data);
 
 	iov_iter_ubuf(&iter, READ, data.ubuf, bufsize);
_

Patches currently in -mm which might be from lk@c--e.de are

lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch

