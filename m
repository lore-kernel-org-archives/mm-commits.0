Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780DD79F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739455; cv=none; b=V5P7bFWg/ThDmUtosO9Nmf5SZzC+PyJCTvjpc86cTQvpS5JNHOpLrEBHzBIegJ3fDVneb7F4CaeKW3VoONsEpEvUF2idsxKRpJNOfxaQeiuBZVz4U0vOyU6kADjR6FtvkZCZ8/+acac9KHT1Xv78eLnGRTiKRhpT1Qv6WUZ9BrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739455; c=relaxed/simple;
	bh=CMalCyKx7q9OnE84qwmMg9xNTCcaPMW389zuRXS9cuc=;
	h=Date:To:From:Subject:Message-Id; b=TyiTb+sLNCb5NZIeVbmRdIBGFLBt1Nx0ZpXYDgExxe64ozuEYLM9U/Ck1gd3g4Q/vmhRmk4AnG8fhBNwcYiDQy71tBiX8Dy9IZOtBGlxbsEFNgA0llXMhtVRMpXaVsVL6EScrg0owPpq152K/X9M+ou9kPCrklQLlBBl9IC6jak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKohhM7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKohhM7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC77C43390;
	Sat, 24 Feb 2024 01:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739455;
	bh=CMalCyKx7q9OnE84qwmMg9xNTCcaPMW389zuRXS9cuc=;
	h=Date:To:From:Subject:From;
	b=AKohhM7wjysQtOoWHUBgPZvf0KLJV1SmreLWeTsvhcdbO2drxKjo4w1u/qVpMWlVj
	 hvaEm2x3Lx+FRqymC04x4LpzD3yijmXLAn9aKUWBeQILUvmqcUNiIgJiq/SDMemvfz
	 g/gBMKrstcXVMxXw7bksLFbg8LswC7tf71ezCXXI=
Date: Fri, 23 Feb 2024 17:50:54 -0800
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-bad_range-return-bool.patch removed from -mm tree
Message-Id: <20240224015055.4BC77C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make bad_range() return bool
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-bad_range-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-make-check_new_page-return-bool.patch

