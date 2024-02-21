Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F293A1DB
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548179; cv=none; b=OCSv/sqv9uSuSUVZTwzAz4NGXMLX8yYg2pQswFTqDAldfkB1POwQX0nmc1G8kVBcMurjFDwu+SaJQJjmNu9CH5jzipaohtLOb0hzkVGwBgwKliBB9DHCsk1vW6qljZV+dsIOyPnsWqH0Emo2T9DXP1D6Xn9ZLKDBXpXvlQ5mQuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548179; c=relaxed/simple;
	bh=XJg8bTpyjuzxwQjtjVgRIwKs09fhNejLcnSaXjL9tAE=;
	h=Date:To:From:Subject:Message-Id; b=LB6r2gdCmCxfYhQhzFhHL932ymOPCHMxucqtTNS7kd5Q6QXQtHIXJ0J9uE37/uPqzo7rAGvzevX7zf83iGjCZohomXr3waYatTbaeEpv1k9PeLarz2d7ixoEdqM0F+UD0s+pzC9GLPwQ6xrzzO/P3GmV1fSdNaK9n6ZObvxkjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIWuQIx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIWuQIx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6178EC433C7;
	Wed, 21 Feb 2024 20:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548178;
	bh=XJg8bTpyjuzxwQjtjVgRIwKs09fhNejLcnSaXjL9tAE=;
	h=Date:To:From:Subject:From;
	b=yIWuQIx11yVFyNaTrg9+lTWR6QDBpzFva7NkQgkseNoPpYNvz9ILW3W/EahcGgAiS
	 KBJ7wZxsROjNVcMXYncHfsQRiMV9+gdAv6+MWQxUJ7DxHM5TdS1l1Xu5V+oMYun0gU
	 Q+tO1j5wiywljk/0AR0xZBmhW88BEgHUDtf+32Ls=
Date: Wed, 21 Feb 2024 12:42:57 -0800
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-bad_range-return-bool.patch added to mm-unstable branch
Message-Id: <20240221204258.6178EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make bad_range() return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-bad_range-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-bad_range-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page_alloc: make bad_range() return bool
Date: Wed, 21 Feb 2024 15:32:27 +0800

bad_range() can return bool, so let us change it.

Link: https://lkml.kernel.org/r/20240221073227.276234-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-bad_range-return-bool
+++ a/mm/page_alloc.c
@@ -464,19 +464,19 @@ static int page_outside_zone_boundaries(
 /*
  * Temporary debugging check for pages not lying within a given zone.
  */
-static int __maybe_unused bad_range(struct zone *zone, struct page *page)
+static bool __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
 	if (page_outside_zone_boundaries(zone, page))
-		return 1;
+		return true;
 	if (zone != page_zone(page))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 #else
-static inline int __maybe_unused bad_range(struct zone *zone, struct page *page)
+static inline bool __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
-	return 0;
+	return false;
 }
 #endif
 
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-vmscan-change-the-type-of-file-from-int-to-bool.patch
mm-vmscan-make-too_many_isolated-return-bool.patch
mm-page_alloc-make-bad_range-return-bool.patch

