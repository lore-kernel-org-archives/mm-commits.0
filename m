Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B837494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628194; cv=none; b=ch85hJT6wd1wyOsR9UZYgAC192iewoq/x3ydKrazNb3iIQGswhpn0Q+hqH9xs4yvtUXA2cGJ+ZhPK5DhkvP6nGHlhSDvCrsaJKe1H1Ww7GFZiScAS2mNASD8pBsh35/Z19l86JwI/Whm5Ol2oZWI6h3mEsyogvZ2TcYgVeaEpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628194; c=relaxed/simple;
	bh=gJRmssRt7jQcKuqRH/DSTONBT6wbFSIfgL53Jxu7h0o=;
	h=Date:To:From:Subject:Message-Id; b=Ljm6Sn9HuHwpGksXDzWhaPU/mYy44osol00El/8Yj5NBU3UReq4Xcx0j1es6S8T32qsRGF45jZXJSEgb9oqDhEZz+tXyp4WdSA9bYU96vPbniLlvUFssTqshv541/Fw9X5e31eYDEyfM2MuaxhU0NyHH4OD0/aqy2Em741iznM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEhnCH3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEhnCH3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FE5C32781;
	Sat, 29 Jun 2024 02:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628194;
	bh=gJRmssRt7jQcKuqRH/DSTONBT6wbFSIfgL53Jxu7h0o=;
	h=Date:To:From:Subject:From;
	b=xEhnCH3WRdZEfLKLJm3stW5YGXiuUQGmYwWamr/HGYvjcBivqGDvdd9MSiWxOSjIk
	 34nz2e+pMmINrOHhFHEKqaGqtBiwS/8QIg6K/6QhRXLxF9w3AKsVpo3pCsNNPhKYz1
	 XGMzrp2rY6wOSIRJIPB82iN1sHw6nONHDv+R6Z/o=
Date: Fri, 28 Jun 2024 19:29:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch removed from -mm tree
Message-Id: <20240629022954.51FE5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow reuse of the lower 16 bit of the page type with an actual type
has been removed from the -mm tree.  Its filename was
     mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix PG_hugetlb typo, per David]
Link: https://lkml.kernel.org/r/20240529111904.2069608-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>	[zram/zsmalloc workloads]
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h   |    5 +++++
 include/linux/page-flags.h |   23 ++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

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
@@ -941,16 +941,21 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
  */
 
 enum pagetype {
-	PG_buddy	= 0x00000080,
-	PG_offline	= 0x00000100,
-	PG_table	= 0x00000200,
-	PG_guard	= 0x00000400,
-	PG_hugetlb	= 0x00000800,
-	PG_slab		= 0x00001000,
+	PG_buddy	= 0x40000000,
+	PG_offline	= 0x20000000,
+	PG_table	= 0x10000000,
+	PG_guard	= 0x08000000,
+	PG_hugetlb	= 0x04000000,
+	PG_slab		= 0x02000000,
 
-	PAGE_TYPE_BASE	= 0xf0000000,
-	/* Reserve 0x0000007f to catch underflows of _mapcount */
-	PAGE_MAPCOUNT_RESERVE	= -128,
+	PAGE_TYPE_BASE	= 0x80000000,
+
+	/*
+	 * Reserve 0xffff0000 - 0xfffffffe to catch _mapcount underflows and
+	 * allow owners that set a type to reuse the lower 16 bit for their own
+	 * purposes.
+	 */
+	PAGE_MAPCOUNT_RESERVE	= ~0x0000ffff,
 };
 
 #define PageType(page, flag)						\
_

Patches currently in -mm which might be from david@redhat.com are


