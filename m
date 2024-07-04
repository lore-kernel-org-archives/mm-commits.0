Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A61DA32D
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720064233; cv=none; b=urwS5/9ZOufoxCkM+ySwJVoo9sM+hpUGQC5+CZG+1WPiILSSdVZtIRhqFuW8ghow897PQs6yD9k2TuLk1RNEXwTk4+i3N+FZ9eOMzq/fTSIJ1SJ9k4Sx+A61ogfd2scugbgh/TEhq8dC0zrcAReM0iusS2M97wAFCWb0L09BSd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720064233; c=relaxed/simple;
	bh=EQiQTPFANT9/Ne+rsPTYswbpVZQniVbxCKXpjjqmU9M=;
	h=Date:To:From:Subject:Message-Id; b=hATXAkYPp92sr9HiwrWScv9uiwmUCmYEm8JR7zFLgrvryVQ9O8c7u37Phd0yx35LzqT3DACQ4UzrtE54Iz4STYgejbpiKv7T4/h4Ba7OB6fWE0rJYc6JEswF0IQiLK4iojny+d7DxHchgNHXwuqxs9swk6lVEUMTWeK+EyZjo6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuF3OjZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuF3OjZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50FEC3277B;
	Thu,  4 Jul 2024 03:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720064232;
	bh=EQiQTPFANT9/Ne+rsPTYswbpVZQniVbxCKXpjjqmU9M=;
	h=Date:To:From:Subject:From;
	b=HuF3OjZOM5s1jClWEMF9u8lqnpBEr/wlBR6l09SvneC5uiJ0CCgtGXPuWCNEq7ohi
	 ESgJsR4DtkGF6OplQvNkR8PtaKtSaBAd1hLkNwCr9KMJ3ORFqUdX7uRLyg+RbTJO12
	 I8oLNpJF2irPQtY9OnBNjQ+nS83unRQ9ZYd52hnE=
Date: Wed, 03 Jul 2024 20:37:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch removed from -mm tree
Message-Id: <20240704033712.A50FEC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
Date: Thu, 4 Jul 2024 01:59:06 +0000

slightly adjust the loop based on David's comment

Link: https://lkml.kernel.org/r/20240704015906.18437-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
+++ a/mm/page_alloc.c
@@ -1224,7 +1224,7 @@ void __free_pages_core(struct page *page
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
-	unsigned int loop;
+	unsigned int loop = 0;
 
 	/*
 	 * When initializing the memmap, __init_single_page() sets the refcount
@@ -1236,10 +1236,13 @@ void __free_pages_core(struct page *page
 	 */
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) &&
 	    unlikely(context == MEMINIT_HOTPLUG)) {
-		for (loop = 0; loop < nr_pages; loop++, p++) {
+		for (;;) {
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
 			set_page_count(p, 0);
+			if (++loop >= nr_pages)
+				break;
+			p++;
 		}
 
 		/*
@@ -1250,9 +1253,12 @@ void __free_pages_core(struct page *page
 		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
-		for (loop = 0; loop < nr_pages; loop++, p++) {
+		for (;;) {
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
+			if (++loop >= nr_pages)
+				break;
+			p++;
 		}
 
 		/* memblock adjusts totalram_pages() manually. */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

