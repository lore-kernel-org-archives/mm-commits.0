Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82502DDA9
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337144; cv=none; b=UHMiABQpmvZOwmMvQaTsbVmezA5RbLQNUewVOiwVrL01xvJSYQyouYhj488HcYjLiYhL7W5w3X+DQIThmsD3UqB9sQo1en3j2UoOdPTQlnYaOVMXLTGUfArL80xEfv05cFygOfFqY26khWkl5p4bcvtfrnKoDqHYbViRj55a3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337144; c=relaxed/simple;
	bh=bOSj/anNqw7ImXp+/LstvVbwMz7XDjaVLaOosRkWORw=;
	h=Date:To:From:Subject:Message-Id; b=A3gNhsNQhBe1sRu0p/1L/DJlloD4vpZTgsvAITGJvL/PSKq/OkeJ+0Vapnfj0DdMomMTcy/wlKI1yUoOny+TtG0ED5kII23sVZbw9sZJK8BtfVZp9fg6fBsibTK0t013NA6xBsTQMn4MOAudNr/eLqck0U8fxdw5JWzXBAMTv10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=syV1Li7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="syV1Li7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFE7C4CED6;
	Mon, 20 Jan 2025 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337144;
	bh=bOSj/anNqw7ImXp+/LstvVbwMz7XDjaVLaOosRkWORw=;
	h=Date:To:From:Subject:From;
	b=syV1Li7dHHmp3aMutJCKBkRPHl1oRwWedhwr4Vy/01x5jlHbUxPyMAfaBhZ+UFyP9
	 YAee/6K0tfpO9wqNwzT1Vn42vVuzIYT6SVR7YPgPShZmv7rdiX1c7cJt5rDK3OFgW8
	 jbMFNORp0SOkf830hIZ+6Og1Qdtt0MF28cwkVKlU=
Date: Sun, 19 Jan 2025 17:39:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pg_dropbehind-folio-flag.patch removed from -mm tree
Message-Id: <20250120013903.EAFE7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add PG_dropbehind folio flag
has been removed from the -mm tree.  Its filename was
     mm-add-pg_dropbehind-folio-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: add PG_dropbehind folio flag
Date: Fri, 20 Dec 2024 08:47:42 -0700

Add a folio flag that file IO can use to indicate that the cached IO being
done should be dropped from the page cache upon completion.

Link: https://lkml.kernel.org/r/20241220154831.1086649-5-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h     |    5 +++++
 include/trace/events/mmflags.h |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-add-pg_dropbehind-folio-flag
+++ a/include/linux/page-flags.h
@@ -110,6 +110,7 @@ enum pageflags {
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
+	PG_dropbehind,		/* drop pages on IO completion */
 #ifdef CONFIG_MMU
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
@@ -562,6 +563,10 @@ PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
+FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(dropbehind, FOLIO_HEAD_PAGE)
+	__FOLIO_SET_FLAG(dropbehind, FOLIO_HEAD_PAGE)
+
 #ifdef CONFIG_HIGHMEM
 /*
  * Must use a macro here due to header dependency issues. page_zone() is not
--- a/include/trace/events/mmflags.h~mm-add-pg_dropbehind-folio-flag
+++ a/include/trace/events/mmflags.h
@@ -116,7 +116,8 @@
 	DEF_PAGEFLAG_NAME(head),					\
 	DEF_PAGEFLAG_NAME(reclaim),					\
 	DEF_PAGEFLAG_NAME(swapbacked),					\
-	DEF_PAGEFLAG_NAME(unevictable)					\
+	DEF_PAGEFLAG_NAME(unevictable),					\
+	DEF_PAGEFLAG_NAME(dropbehind)					\
 IF_HAVE_PG_MLOCK(mlocked)						\
 IF_HAVE_PG_HWPOISON(hwpoison)						\
 IF_HAVE_PG_IDLE(idle)							\
_

Patches currently in -mm which might be from axboe@kernel.dk are


