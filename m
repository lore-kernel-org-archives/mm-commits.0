Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9DA1C11
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759104; cv=none; b=nkSQHybEyuabHzNhvDCWZLkxnOb+rahkXM+BFk4NqdKXIooyJ+QZbpah3jymrO6QrlayxQbyE1VfLJN7TsRhS9X9900z991enM/CVX/PyJICJgHG+AUyGXMQT47ctzhbCmbk9l3mGmsXkEhh9BtelF3gpZvBIz3rWRSYGZv/L4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759104; c=relaxed/simple;
	bh=0q3CpvZdxGjb0I1DRaURNBi6mhk42V7DAowDMJY3eqQ=;
	h=Date:To:From:Subject:Message-Id; b=D+gk1I+v3bebmSEfFAE8zcn3V5IRWU9zT6J0ZPcqkRwjTjuzk/C/ty5dRoCR9F9A6P60+PQVKn4QoN2yxuRwf2YS32iP9cKdAyOISuV4ILJs6u0dIr2GviHVJ71Mi1012tYzBuCH4MAR/xD/JzuAm+swsaNIEBUMMtwTH3bR3VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BzywaeRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BzywaeRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19155C433C7;
	Wed,  6 Mar 2024 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759104;
	bh=0q3CpvZdxGjb0I1DRaURNBi6mhk42V7DAowDMJY3eqQ=;
	h=Date:To:From:Subject:From;
	b=BzywaeRp58Yrh+7fdLPo1cSvcy7RSdc4QYGy8Sbj6lrMtYYeQPBlJdRokm/WPoajf
	 CUbqOjBSzfOVZGIbaezcvO+2OQcahX4HnZJTJ+lv+vHaW869KJ1M5ww4/WHUaz61VS
	 vDtOitgc8uJ2Vaf1vrEg4g0gQAlcmjbZVYvFScVc=
Date: Wed, 06 Mar 2024 13:05:03 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageyoung-and-pageidle-definitions.patch removed from -mm tree
Message-Id: <20240306210504.19155C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageYoung and PageIdle definitions
has been removed from the -mm tree.  Its filename was
     mm-remove-pageyoung-and-pageidle-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageYoung and PageIdle definitions
Date: Tue, 27 Feb 2024 19:23:30 +0000

All callers have been converted to use folios, so remove the various
set/clear/test functions defined on pages.

Link: https://lkml.kernel.org/r/20240227192337.757313-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageyoung-and-pageidle-definitions
+++ a/include/linux/page-flags.h
@@ -599,10 +599,10 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
 #endif
 
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young, PF_ANY)
-SETPAGEFLAG(Young, young, PF_ANY)
-TESTCLEARFLAG(Young, young, PF_ANY)
-PAGEFLAG(Idle, idle, PF_ANY)
+FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_SET_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_TEST_CLEAR_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_FLAG(idle, FOLIO_HEAD_PAGE)
 #endif
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


