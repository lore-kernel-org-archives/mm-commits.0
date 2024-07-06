Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBF013C80F
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292060; cv=none; b=VIPUBUBC5UIpueVFfnUdZr3+bztYE5W3puq6J3ukF2EsvpTMMf0O/cauwEqsuSK/PeSXPaA4AzNoEOpzenhCzovMiG5fBelSr6/HExSmc2sE1sL8UML6N19XUg9TS0juui8ISvd91NpQ5i4BQaoXPhgl2eZ3y/qI99h1cFk9X+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292060; c=relaxed/simple;
	bh=JySNHfLJyYx0Oj0GLj6zWj0K4WpXsHuNNwNoQBc153M=;
	h=Date:To:From:Subject:Message-Id; b=fb3J76E8BeIZa3SAW6CYTW1E3WheJ3RbYXZyTezHqqZKexTVnpe4KhJkpN7fC0wkGT5OAxd9h4fhhSK10WMpiPz2KnpTKbaCJ4zLeYFODodVj9mv9lRe7+pg+s30Lzg+t9vJU2o513xUtPn9rzuQt0QeuZ5QBUabfhOzAPHa8Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PNaZ0Z0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PNaZ0Z0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D7AC2BD10;
	Sat,  6 Jul 2024 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292060;
	bh=JySNHfLJyYx0Oj0GLj6zWj0K4WpXsHuNNwNoQBc153M=;
	h=Date:To:From:Subject:From;
	b=PNaZ0Z0gN3kIkm7Pre3l7dquMxbs7uoNkM6D9STcx3v1hf8N/ntMF1UCANS9UwXGi
	 ZaMTphNQeJDb/Yk5Depdxi8Y5VjnL7PwM7DOkhwa9dcBc98LAH2sSDMiIm5OnKpQPJ
	 8g4XPhrsubi8TxpBpjicEMjGjhKbz177oh/DjFx4=
Date: Sat, 06 Jul 2024 11:54:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch removed from -mm tree
Message-Id: <20240706185420.12D7AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove prefetchw() on freeing page to buddy system
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
most basic idea is freeing higher order pages.  And as Matthew says,
"Itanium CPUs of this era had no prefetchers."

I did 10 round bootup tests before and after this change, the data doesn't
prove prefetchw() help speeding up bootmem freeing.  The sum of the 10
round bootmem freeing time after prefetchw() removal even 5.2% faster than
before.

[1]: https://lore.kernel.org/linux-ia64/40F46962.4090604@sgi.com/

Link: https://lkml.kernel.org/r/20240702020931.7061-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch
mm-use-zonelist_zone-to-get-zone.patch

