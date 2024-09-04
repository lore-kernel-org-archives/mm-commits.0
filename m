Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E9770E4
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423519; cv=none; b=mu59fOs4YhLxFZVkGbgFByd5d4fl+tf2tKxhQm2M8HwTXXUGbP/2sbMF1cmnUq1PDeLp+7d+tJneI7Wma3llowRZEhff4LK3JM57yHT+MHLMDmjj+1AZz9hnnTWFvAOaNo6wEX1MUtM016JuWPQuigNSB3ZvJmhMMu5iV3nKwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423519; c=relaxed/simple;
	bh=k1u2ixXoI0jv7WXer5AqHeH27OJtfsrReKpD8UlooYA=;
	h=Date:To:From:Subject:Message-Id; b=uS5H0a2mM7NBMi13IyechZ/viNVTAfI96dWvdD7bpfKneO0/behI52+aUzOQfLUZ/s2mqihOpqdUNf6zhyO+MFkVsQhyjbbqOxMz31GKNAbFzJYCpAbq1/QyPZJN2lw58fl95zvevm5m8fIguiX9LpUyYUTHVEjtazH9fLJEGRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ro74R78A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ro74R78A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6888BC4CEC2;
	Wed,  4 Sep 2024 04:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423519;
	bh=k1u2ixXoI0jv7WXer5AqHeH27OJtfsrReKpD8UlooYA=;
	h=Date:To:From:Subject:From;
	b=Ro74R78A63v1+3rN9Jw1jJZHb+r4bF7M9hBp+vjuwbUVEQq/fyKcIukieC4qFaoH0
	 1NlXHAG0lQJ4bam1pobsAXq7OAOnG2zutYhy0hO7w3D5vppiKKQFahYA5ZsQKGZP9m
	 3cp/9PDQc5MT+L5jDWIAwKn8WF3HO1NZX6KcmKFQ=
Date: Tue, 03 Sep 2024 21:18:38 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-page_mapcount_is_type.patch removed from -mm tree
Message-Id: <20240904041839.6888BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce page_mapcount_is_type()
has been removed from the -mm tree.  Its filename was
     mm-introduce-page_mapcount_is_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce page_mapcount_is_type()
Date: Wed, 21 Aug 2024 18:39:10 +0100

Resolve the awkward "and add one to this opaque constant" test into a
self-documenting inline function.

Link: https://lkml.kernel.org/r/20240821173914.2270383-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h         |    3 +--
 include/linux/mm.h         |    3 +--
 include/linux/page-flags.h |   12 +++++++++---
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/fs/proc/internal.h~mm-introduce-page_mapcount_is_type
+++ a/fs/proc/internal.h
@@ -166,8 +166,7 @@ static inline int folio_precise_page_map
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
-	/* Handle page_has_type() pages */
-	if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+	if (page_mapcount_is_type(mapcount))
 		mapcount = 0;
 	if (folio_test_large(folio))
 		mapcount += folio_entire_mapcount(folio);
--- a/include/linux/mm.h~mm-introduce-page_mapcount_is_type
+++ a/include/linux/mm.h
@@ -1228,8 +1228,7 @@ static inline int folio_mapcount(const s
 
 	if (likely(!folio_test_large(folio))) {
 		mapcount = atomic_read(&folio->_mapcount) + 1;
-		/* Handle page_has_type() pages */
-		if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+		if (page_mapcount_is_type(mapcount))
 			mapcount = 0;
 		return mapcount;
 	}
--- a/include/linux/page-flags.h~mm-introduce-page_mapcount_is_type
+++ a/include/linux/page-flags.h
@@ -956,12 +956,18 @@ enum pagetype {
 #define folio_test_type(folio, flag)					\
 	((READ_ONCE(folio->page.page_type) & (PAGE_TYPE_BASE | flag))  == PAGE_TYPE_BASE)
 
-static inline int page_type_has_type(unsigned int page_type)
+static inline bool page_type_has_type(int page_type)
 {
-	return (int)page_type < PAGE_MAPCOUNT_RESERVE;
+	return page_type < PAGE_MAPCOUNT_RESERVE;
 }
 
-static inline int page_has_type(const struct page *page)
+/* This takes a mapcount which is one more than page->_mapcount */
+static inline bool page_mapcount_is_type(unsigned int mapcount)
+{
+	return page_type_has_type(mapcount - 1);
+}
+
+static inline bool page_has_type(const struct page *page)
 {
 	return page_type_has_type(READ_ONCE(page->page_type));
 }
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

