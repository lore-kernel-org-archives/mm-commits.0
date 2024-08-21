Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799E1531C9
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272232; cv=none; b=Jb7tPGzKbQB+lL9EwsQhacjDIByiz0hw2ri8b0ANDxvk5fAPVCv/YTSNoHxxfUSPr5lGMHRcUErPv0mKQBhMXmovbQJ94FSPAoYMb1NcybHSdHQs5i6mOGeZHHlRewUT04osbwfJwk6dWoaq52Eq/Ar6MNLSHVdDgXFHsIblNBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272232; c=relaxed/simple;
	bh=L3Yg03ExfkGEP5SBHfQof7k+XS5FI+hAapYQW1cYHcU=;
	h=Date:To:From:Subject:Message-Id; b=t5/6K+SZsyB/Md5BanOuP5mxoMVLGj/bvjDeJbrLfLT07dSiQJ6eTe7rE1pTCJK41TFI50m8XVEgUmFgH9aPGr36sRrJIkO53CfbwqaSbg6hSGNV2hHITFObZT5PPIBgTmDWfXYmG6z8KxH2964e52tekHTIzk8CHx0VXZaeEmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gaQpMXHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gaQpMXHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE6DC32781;
	Wed, 21 Aug 2024 20:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272231;
	bh=L3Yg03ExfkGEP5SBHfQof7k+XS5FI+hAapYQW1cYHcU=;
	h=Date:To:From:Subject:From;
	b=gaQpMXHjcKJQqhaMs5Xy0CNTSCXPZ0cdRb5CsBwNotIM1HVVcXmL7zImK48HUAnSj
	 N0xhlUqLVSOKEePBfA3trZcSP428DvF7W1Df0N9I+5WSo6boPsglYsBemTudeOQe9L
	 JU1DO0bK9RgNcWMWMzxmzL72qBRcHupmE2NLoxGA=
Date: Wed, 21 Aug 2024 13:30:30 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-page_mapcount_is_type.patch added to mm-unstable branch
Message-Id: <20240821203031.7EE6DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce page_mapcount_is_type()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-page_mapcount_is_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-page_mapcount_is_type.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce page_mapcount_is_type()
Date: Wed, 21 Aug 2024 18:39:10 +0100

Resolve the awkward "and add one to this opaque constant" test into a
self-documenting inline function.

Link: https://lkml.kernel.org/r/20240821173914.2270383-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
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

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch

