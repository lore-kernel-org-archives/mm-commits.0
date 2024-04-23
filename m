Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293C3339A8
	for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2024 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713895812; cv=none; b=E9BmhrQw88qKh2GOdOX8q6cScTvfBA9JKeVyfU0QOpyco3DMJZELYpR6qiY0kR6cyqCKRADsDGceNVPVl0xAjYKv5mHYMfNt7hmkob2Mxqa6dlyWt7LbA/1hXW2NHEuVZV2Ibs2wMllhMnx8TpoEho3rOtQQCLKSxR+BDWdwqXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713895812; c=relaxed/simple;
	bh=LQ0yMukNoYzLdd+2C7GUQQ2tIDUUEBCqg5VL/2fUE4Q=;
	h=Date:To:From:Subject:Message-Id; b=E7A/9K0pHAvJP/04ctqdrcbne8ezhbIQsh1IdQ97SjgO+BqrxVrmzsxeoucHmvuUBDtqyYBHQ075m31dpwgfzBLWN/xjMzjFIOZRcgMdEmQk5BU6gz/QwWEvhCyGZ0vB96nQmFCdzWS98GmiE237p4XUWkaBC1SwxrQ8inwTgIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AgY/ReC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AgY/ReC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C1CC116B1;
	Tue, 23 Apr 2024 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713895811;
	bh=LQ0yMukNoYzLdd+2C7GUQQ2tIDUUEBCqg5VL/2fUE4Q=;
	h=Date:To:From:Subject:From;
	b=AgY/ReC+ZBcJrbGnTTM1qLHqL/YE1tuomkr1yjjt+qcv8UNqFtIWUFNSDwXri+Oi8
	 HjjqcnF+NFG3HiWK4bJQl/mVsRIbnAufCkuHNgfbtk4B4nQ+Zi+xZTbqbA1Huy3Cub
	 1yFe/K/KDSxba8OnyzF7MAHnJjHHz+dTlO+2tsIc=
Date: Tue, 23 Apr 2024 11:10:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,linux@rasmusvillemoes.dk,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-consolidate-free-page-accounting-fix-4.patch added to mm-unstable branch
Message-Id: <20240423181011.A9C1CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: avoid defining unused function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-consolidate-free-page-accounting-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-consolidate-free-page-accounting-fix-4.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: page_alloc: avoid defining unused function
Date: Tue, 23 Apr 2024 19:14:43 +0300

In some configurations I got mm/page_alloc.c:656:20: warning: unused
function 'add_to_free_list' [-Wunused-function] Because the only user is
guarded with a certain ifdeffery, do the same for add_to_free_list().

Link: https://lkml.kernel.org/r/20240423161506.2637177-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-consolidate-free-page-accounting-fix-4
+++ a/mm/page_alloc.c
@@ -673,14 +673,6 @@ static inline void __add_to_free_list(st
 	area->nr_free++;
 }
 
-static inline void add_to_free_list(struct page *page, struct zone *zone,
-				    unsigned int order, int migratetype,
-				    bool tail)
-{
-	__add_to_free_list(page, zone, order, migratetype, tail);
-	account_freepages(zone, 1 << order, migratetype);
-}
-
 /*
  * Used for pages which are on another list. Move the pages to the tail
  * of the list - so the moved pages won't immediately be considered for
@@ -6770,6 +6762,14 @@ bool is_free_buddy_page(struct page *pag
 EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
+static inline void add_to_free_list(struct page *page, struct zone *zone,
+				    unsigned int order, int migratetype,
+				    bool tail)
+{
+	__add_to_free_list(page, zone, order, migratetype, tail);
+	account_freepages(zone, 1 << order, migratetype);
+}
+
 /*
  * Break down a higher-order page in sub-pages, and keep our target out of
  * buddy allocator.
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-page_alloc-consolidate-free-page-accounting-fix-4.patch
devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch

