Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85015D5B9
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009561; cv=none; b=qGe7+qx3KAMrwGkkf9EeXAS8OgODgYsn6QbeaFAK7Etj3V3tEJbBRa3sOuQ7NrjSvzezzGcWmarEXsnrR32Gd9tuiGq7xIN9QkHxixLIC5W70jeLfgPz8pDyYCqG9wHc72M+Cj3pYxHSDBZmAlDGgLY0nLg3T+n9yvh8y/MYN50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009561; c=relaxed/simple;
	bh=8fSluYwjXWl03Of6zelX75/5Xmgro+WOIIb+KTF9O3c=;
	h=Date:To:From:Subject:Message-Id; b=Bs9rPfW3D9bQp7ctKBoT0yWuceOrXPdTmfq2WrSa7u2CjUDkLZniXmDFaxd5hOkk6F5TvhWnKXrk69HFpl+XanIzDhvX96TRiUpuHB6USL6rWdhposcvLmva/IWbUVP2dahj5P/bZ8kGPy1i0qHlvj++J5qE/1JFT6k00n3t8g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wwaP98MJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwaP98MJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485B0C113CC;
	Wed, 29 May 2024 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009560;
	bh=8fSluYwjXWl03Of6zelX75/5Xmgro+WOIIb+KTF9O3c=;
	h=Date:To:From:Subject:From;
	b=wwaP98MJMG9YYQT2rWrGI5m5/n0VNHdNvxpnqYK/X0EccaOq3HK7dgCseLoH5wR2c
	 USwOs8zwWpbM4sVtBs8QXSEc2ZqP/LaFdakWTjae8H+4q6V846ZCscYpmEwLsLmMPx
	 uNqOkyN5YB8+rp0ZUL/ymOzJCzNArnQS22BHSyMA=
Date: Wed, 29 May 2024 12:05:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-_mapcount-and-page_type-documentation.patch added to mm-unstable branch
Message-Id: <20240529190600.485B0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update _mapcount and page_type documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-_mapcount-and-page_type-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-_mapcount-and-page_type-documentation.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: update _mapcount and page_type documentation
Date: Wed, 29 May 2024 13:18:59 +0200

Patch series "mm: page_type, zsmalloc and page_mapcount_reset()", v2.

Wanting to remove the remaining abuser of _mapcount/page_type along with
page_mapcount_reset(), I stumbled over zsmalloc, which is yet to be
converted away from "struct page" [1].

Unfortunately, we cannot stop using the page_type field in zsmalloc code
completely for its own purposes.  All other fields in "struct page" are
used one way or the other.  Could we simply store a 2-byte offset value at
the beginning of each page?  Likely, but that will require a bit more
work; and once we have memdesc we might want to move the offset in there
(struct zsalloc?) again.

...  but we can limit the abuse to 16 bit, glue it to a page type that
must be set, and document it.  page_has_type() will always successfully
indicate such zsmalloc pages, and such zsmalloc pages only.

We lose zsmalloc support for PAGE_SIZE > 64KB, which should be tolerable. 
We could use more bits from the page type, but 16 bit sounds like a good
idea for now.

So clarify the _mapcount/page_type documentation, use a proper page_type
for zsmalloc, and remove page_mapcount_reset().

[1] https://lore.kernel.org/all/20231130101242.2590384-1-42.hyeyoo@gmail.com/


This patch (of 6):

Let's make it clearer that _mapcount must no longer be used for own
purposes, and how _mapcount and page_type behaves nowadays (also in the
context of hugetlb folios, which are typed folios that will be mapped to
user space).

Move the documentation regarding "-1" over from page_mapcount_reset(),
which we will remove next.  Move "page_type" before "mapcount", to make it
clearer what typed folios are.

Link: https://lkml.kernel.org/r/20240529111904.2069608-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240529111904.2069608-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    5 -----
 include/linux/mm_types.h |   28 +++++++++++++++++-----------
 2 files changed, 17 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-update-_mapcount-and-page_type-documentation
+++ a/include/linux/mm.h
@@ -1206,11 +1206,6 @@ static inline int folio_entire_mapcount(
 	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
-/*
- * The atomic page->_mapcount, starts from -1: so that transitions
- * both from it and to it can be tracked, using atomic_inc_and_test
- * and atomic_add_negative(-1).
- */
 static inline void page_mapcount_reset(struct page *page)
 {
 	atomic_set(&(page)->_mapcount, -1);
--- a/include/linux/mm_types.h~mm-update-_mapcount-and-page_type-documentation
+++ a/include/linux/mm_types.h
@@ -46,9 +46,7 @@ struct mem_cgroup;
  * which is guaranteed to be aligned.  If you use the same storage as
  * page->mapping, you must restore it to NULL before freeing the page.
  *
- * If your page will not be mapped to userspace, you can also use the four
- * bytes in the mapcount union, but you must call page_mapcount_reset()
- * before freeing it.
+ * The mapcount field must not be used for own purposes.
  *
  * If you want to use the refcount field, it must be used in such a way
  * that other CPUs temporarily incrementing and then decrementing the
@@ -152,18 +150,26 @@ struct page {
 
 	union {		/* This union is 4 bytes in size. */
 		/*
-		 * If the page can be mapped to userspace, encodes the number
-		 * of times this page is referenced by a page table.
+		 * For head pages of typed folios, the value stored here
+		 * allows for determining what this page is used for. The
+		 * tail pages of typed folios will not store a type
+		 * (page_type == _mapcount == -1).
+		 *
+		 * See page-flags.h for a list of page types which are currently
+		 * stored here.
 		 */
-		atomic_t _mapcount;
+		unsigned int page_type;
 
 		/*
-		 * If the page is neither PageSlab nor mappable to userspace,
-		 * the value stored here may help determine what this page
-		 * is used for.  See page-flags.h for a list of page types
-		 * which are currently stored here.
+		 * For pages that are part of non-typed folios for which mappings
+		 * are tracked via the RMAP, encodes the number of times this page
+		 * is directly referenced by a page table.
+		 *
+		 * Note that the mapcount is always initialized to -1, so that
+		 * transitions both from it and to it can be tracked, using
+		 * atomic_inc_and_test() and atomic_add_negative(-1).
 		 */
-		unsigned int page_type;
+		atomic_t _mapcount;
 	};
 
 	/* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

