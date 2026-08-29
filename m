Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B01437E5C8
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035924; cv=none; b=n43MS+eH9ujTt2U1APJQyKXZIkamGiUvX8dWHRPm5NKlMb0l170oyfgDIW8H6kTNThBtvNmUjHfqCizkw9JFsmMlWWnIfJdT7V8RMIw1pICBBWx2VeT4EJXK4AxGkdm6IHHvrkbgejZpdtSItuZq/dP8ofJhvV2wuGVLj1AW62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035924; c=relaxed/simple;
	bh=fHLbffr3NnZ6rGLfMsFCnzc6NAXPSoDvIlMgfuzZJ+I=;
	h=Date:To:From:Subject:Message-Id; b=J0RuUDkcxW/k87mE+GKjjsmr6wSngLlJzDle3LMpeBVfuEo6e4H1VeA0LWfNiyDLnZqoSmv+5XhhLtC7wWsCHexa0Hw1L4UzYYrJxxAYZ09I1EIyVDbU0nI2ff7IvK0cJlzTHqGYoW8i6dTCeh0yRk1XUV/Q/QGse6M60qhl5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2xwVSex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2xwVSex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844ED1F00A3D;
	Sat, 29 Aug 2026 20:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035922;
	bh=i792Mpujuco9CkY8mvKGulN/aQnqBbaI6cxOkW/kDQs=;
	h=Date:To:From:Subject;
	b=K2xwVSex6KQCy4rMowjSBGjyAx00MQcBCDh5eoK3Tkd4veHaJMXM0UKY99g56pyJl
	 z3XB091wZUp5CjRkZ7AlZn1Pp8Lgr+dA30vM0yuv66dT0L9F7Jlp1i5pYgvHekeYlj
	 qJkbS2IcHMLNOKSeC6Gyb5qyfdO7npwLOm+YeM/k=
Date: Sat, 29 Aug 2026 13:38:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagereclaim.patch added to mm-new branch
Message-Id: <20260829203842.844ED1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageReclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pagereclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagereclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove PageReclaim
Date: Sat, 29 Aug 2026 15:09:01 -0400

This flag is now only used on folios, so we can remove all the page
accessors.  folio_test_clear_reclaim() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-2-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagereclaim
+++ a/include/linux/page-flags.h
@@ -593,8 +593,7 @@ TESTPAGEFLAG(Writeback, writeback, PF_NO
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
+FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

