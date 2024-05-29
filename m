Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88911181D09
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009562; cv=none; b=nBzl2I6DOPMRYIUC15SDyxzmRGbh6R5NLxeVW5CGVpzsfDXAb9Q7rfwrhUHw2hWxmy8G1yf32rWNpi0gVbFcNcD7bg7K5IOv+//TFL9SPxKM0XLKvKIzYKW8kJ/wsz0zx0j28zoSHaQMiKWz1S/sV0pov7xaaCYeONVNk7CZB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009562; c=relaxed/simple;
	bh=F3XWS3Mi0axXitqZFeFYZhm1T8N7Yj8/O3GUVldztS0=;
	h=Date:To:From:Subject:Message-Id; b=qSk67xxZ7XGMimLe3OTJbVBHTafs+3Oa29IXZoCW20Gz7QCigoyKaCN5aPSOS+NgRdwFl/nO7Ocduv0CzeFS5pZZc5dd6V5zHxODhxxrI8GQlLcLjncdQ8x1El93IW/sJGiX+gSkpoS1VFUo9t7qiTWWur+/z2VRk55vEqgd4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPgSF4/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPgSF4/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FDDC113CC;
	Wed, 29 May 2024 19:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009562;
	bh=F3XWS3Mi0axXitqZFeFYZhm1T8N7Yj8/O3GUVldztS0=;
	h=Date:To:From:Subject:From;
	b=CPgSF4/aDgohgx3Y5QLRN9d5MHFVgrkyh0rrE57Ymx4sGyW/2t5D0l6iYJhSLdXJt
	 KqTIJVmOhvqiXkpd0u1WB9WkEiBYu5pOKKOqonMKPVeozRyhvePPgplas7TlI8E9Gb
	 rtc5/hGkdBaoqTvs7YB2v/oP8ve56VlBX1qCE1go=
Date: Wed, 29 May 2024 12:06:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch added to mm-unstable branch
Message-Id: <20240529190602.06FDDC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow reuse of the lower 16 bit of the page type with an actual type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch

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
Subject: mm: allow reuse of the lower 16 bit of the page type with an actual type
Date: Wed, 29 May 2024 13:19:00 +0200

As long as the owner sets a page type first, we can allow reuse of the
lower 16 bit: sufficient to store an offset into a 64 KiB page, which is
the maximum base page size in *common* configurations (ignoring the 256
KiB variant).  Restrict it to the head page.

We'll use that for zsmalloc next, to set a proper type while still reusing
that field to store information (offset into a base page) that cannot go
elsewhere for now.

Let's reserve the lower 16 bit for that purpose and for catching mapcount
underflows, and let's reduce PAGE_TYPE_BASE to a single bit.

Note that we will still have to overflow the mapcount quite a lot until we
would actually indicate a valid page type.

Start handing out the type bits from highest to lowest, to make it clearer
how many bits for types we have left.  Out of 15 bit we can use for types,
we currently use 6.  If we run out of bits before we have better typing
(e.g., memdesc), we can always investigate storing a value instead [1].

[1] https://lore.kernel.org/all/00ba1dff-7c05-46e8-b0d9-a78ac1cfc198@redhat.com/

Link: https://lkml.kernel.org/r/20240529111904.2069608-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h   |    5 +++++
 include/linux/page-flags.h |   22 +++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type
+++ a/include/linux/mm_types.h
@@ -157,6 +157,11 @@ struct page {
 		 *
 		 * See page-flags.h for a list of page types which are currently
 		 * stored here.
+		 *
+		 * Owners of typed folios may reuse the lower 16 bit of the
+		 * head page page_type field after setting the page type,
+		 * but must reset these 16 bit to -1 before clearing the
+		 * page type.
 		 */
 		unsigned int page_type;
 
--- a/include/linux/page-flags.h~mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type
+++ a/include/linux/page-flags.h
@@ -945,15 +945,19 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
  * mistaken for a page type value.
  */
 
-#define PAGE_TYPE_BASE	0xf0000000
-/* Reserve		0x0000007f to catch underflows of _mapcount */
-#define PAGE_MAPCOUNT_RESERVE	-128
-#define PG_buddy	0x00000080
-#define PG_offline	0x00000100
-#define PG_table	0x00000200
-#define PG_guard	0x00000400
-#define PG_hugetlb	0x00000800
-#define PG_slab		0x00001000
+#define PAGE_TYPE_BASE	0x80000000
+/*
+ * Reserve 0xffff0000 - 0xfffffffe to catch _mapcount underflows and
+ * allow owners that set a type to reuse the lower 16 bit for their own
+ * purposes.
+ */
+#define PG_buddy	0x40000000
+#define PG_offline	0x20000000
+#define PG_table	0x10000000
+#define PG_guard	0x08000000
+#define PG_hugetlb	0x04008000
+#define PG_slab		0x02000000
+#define PAGE_MAPCOUNT_RESERVE	(~0x0000ffff)
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
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

