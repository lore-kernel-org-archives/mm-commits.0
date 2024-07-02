Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36662B9D8
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 06:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901372; cv=none; b=hr/xPG5qxA+oPL9xC2zl8RMO9Sw21tkd2kjWaa9LLJPx5lQp1M8eBDF4K6OnlwbhkQ/cLGlC02gnzKcynvnhU/vWT3mIYX5ADKq1mEEskvgp44sk+51pTaSbE4r3Ag2QGznBCSVJD9LOgzX2+FA9Pw6yc6ZH8VLLbhr1as/ygjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901372; c=relaxed/simple;
	bh=dohr6SKyH8oSrMndotxsH9prpA5h5IrW6ovQ30GJmQM=;
	h=Date:To:From:Subject:Message-Id; b=MY2MMEFrDZJHRVNMsRzAXLl2gsJFoO+BhyEZniGPmafDv+4GQc61bpAwWc1HsCbgQ7Llu69c8AB5Of9BVKoPG7RkYOQFDK92uvla1qTVwIBEV8J5kgSP7IamJOj85XUB5oJY80malzNW9D+AYA5cWa1ZiFBpcOoOGTMIIjLdXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vmvKUF40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vmvKUF40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F60C116B1;
	Tue,  2 Jul 2024 06:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719901371;
	bh=dohr6SKyH8oSrMndotxsH9prpA5h5IrW6ovQ30GJmQM=;
	h=Date:To:From:Subject:From;
	b=vmvKUF40mG8M5DbNG5fGnvjyh5Xl5hrn/uh4GnVwcc7E9iB2Qm/fOkGxY9CZhx7Yc
	 LfUkMCC+cgA8DWr7ZnnvuIDPOdtFmWE3O+FSUR/WE7GBF3ACt5/BWLNCQVEWKE806Q
	 4nCarsE+DfVFCEA3zLyNymLNctQln1dyyOlgxUHc=
Date: Mon, 01 Jul 2024 23:22:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch added to mm-unstable branch
Message-Id: <20240702062251.78F60C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove prefetchw() on freeing page to buddy system
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: remove prefetchw() on freeing page to buddy system
Date: Tue, 2 Jul 2024 02:09:31 +0000

The prefetchw() is introduced from an ancient patch[1].

The change log says:

    The basic idea is to free higher order pages instead of going
    through every single one.  Also, some unnecessary atomic operations
    are done away with and replaced with non-atomic equivalents, and
    prefetching is done where it helps the most.  For a more in-depth
    discusion of this patch, please see the linux-ia64 archives (topic
    is "free bootmem feedback patch").

So there are several changes improve the bootmem freeing, in which the
most basic idea is freeing higher order pages. And as Matthew says,
"Itanium CPUs of this era had no prefetchers."

I did 10 round bootup tests before and after this change, the data
doesn't prove prefetchw() help speeding up bootmem freeing. The sum of
the 10 round bootmem freeing time after prefetchw() removal even 5.2%
faster than before.

[1]: https://lore.kernel.org/linux-ia64/40F46962.4090604@sgi.com/

Link: https://lkml.kernel.org/r/20240702020931.7061-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system
+++ a/mm/page_alloc.c
@@ -1236,16 +1236,11 @@ void __free_pages_core(struct page *page
 	 */
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) &&
 	    unlikely(context == MEMINIT_HOTPLUG)) {
-		prefetchw(p);
-		for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
-			prefetchw(p + 1);
+		for (loop = 0; loop < nr_pages; loop++, p++) {
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
 			set_page_count(p, 0);
 		}
-		VM_WARN_ON_ONCE(PageReserved(p));
-		__ClearPageOffline(p);
-		set_page_count(p, 0);
 
 		/*
 		 * Freeing the page with debug_pagealloc enabled will try to
@@ -1255,14 +1250,10 @@ void __free_pages_core(struct page *page
 		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
-		prefetchw(p);
-		for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
-			prefetchw(p + 1);
+		for (loop = 0; loop < nr_pages; loop++, p++) {
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
 		}
-		__ClearPageReserved(p);
-		set_page_count(p, 0);
 
 		/* memblock adjusts totalram_pages() manually. */
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

