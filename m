Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC35381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247771; cv=none; b=NudMlixZZ/klKUv8FH2cGyB6htah4J7tvGbNZlhoA2nRERAiNLoSUHlL/hHe9k2dZRWlkMlEOceY6S8EDtOYOy4M/vWwlDN1rKGb3y2wp2Vsy9Y4MTHdD3788PMfoXZ1Bku5tsFtpoxgEAUvx76SI+inChwj6USVyZco14JSnkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247771; c=relaxed/simple;
	bh=njlmr5ThqjnvtVmUGOdkb8+EEzSKLo2XD4xKcG0z9qc=;
	h=Date:To:From:Subject:Message-Id; b=lPoSEneBveiVD7XmLClAmBXy0ISHDgDGDGpaEOewVZ31SBVI5mLMd0k4N4Ot462/V+1OWxJKjj1QnAuTI3xO+XHAyNEVrLVTDP6HJSeVxUC6/2rcZUvaSOO+Kwox/PyjllpoWd5jm+J9Q7xnPNw+2J3iAUi7HN08zYGypTPATeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r62RmPBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r62RmPBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082DBC4CEC2;
	Mon,  2 Sep 2024 03:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247771;
	bh=njlmr5ThqjnvtVmUGOdkb8+EEzSKLo2XD4xKcG0z9qc=;
	h=Date:To:From:Subject:From;
	b=r62RmPBplRbCKWF0kAUjkYf7IxrHCm8PCkdGIrZGq5edgqj/s/7vGwdGRJI3IO+nR
	 OvKNDJWyLo/4UOI0yb0zPzobcoMPenwS8I6dMQM5RLiHWu79UBB/LNmpam36TXcMTS
	 i0Rr3XAktI0G86LVyeXDgzmgZhOvg8vF6zdO1mB0=
Date: Sun, 01 Sep 2024 20:29:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pg_error.patch removed from -mm tree
Message-Id: <20240902032931.082DBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PG_error
has been removed from the -mm tree.  Its filename was
     mm-remove-pg_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PG_error
Date: Wed, 7 Aug 2024 20:35:26 +0100

The PG_error bit is now unused; delete it and free up a bit in
page->flags.

Link: https://lkml.kernel.org/r/20240807193528.1865100-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                         |    1 -
 include/linux/page-flags.h             |    6 +-----
 include/trace/events/mmflags.h         |    1 -
 include/uapi/linux/kernel-page-flags.h |    2 +-
 4 files changed, 2 insertions(+), 8 deletions(-)

--- a/fs/proc/page.c~mm-remove-pg_error
+++ a/fs/proc/page.c
@@ -182,7 +182,6 @@ u64 stable_page_flags(const struct page
 #endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
-	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
 	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
--- a/include/linux/page-flags.h~mm-remove-pg_error
+++ a/include/linux/page-flags.h
@@ -66,8 +66,6 @@
  * PG_referenced, PG_reclaim are used for page reclaim for anonymous and
  * file-backed pagecache (see mm/vmscan.c).
  *
- * PG_error is set to indicate that an I/O error occurred on this page.
- *
  * PG_arch_1 is an architecture specific page state bit.  The generic code
  * guarantees that this bit is cleared for a page when it first is entered into
  * the page cache.
@@ -103,7 +101,6 @@ enum pageflags {
 	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_active,
 	PG_workingset,
-	PG_error,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
 	PG_arch_1,
 	PG_reserved,
@@ -183,7 +180,7 @@ enum pageflags {
 	 */
 
 	/* At least one page in this folio has the hwpoison flag set */
-	PG_has_hwpoisoned = PG_error,
+	PG_has_hwpoisoned = PG_active,
 	PG_large_rmappable = PG_workingset, /* anon or file-backed */
 };
 
@@ -506,7 +503,6 @@ static inline int TestClearPage##uname(s
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
-PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 FOLIO_FLAG(referenced, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(referenced, FOLIO_HEAD_PAGE)
 	__FOLIO_SET_FLAG(referenced, FOLIO_HEAD_PAGE)
--- a/include/trace/events/mmflags.h~mm-remove-pg_error
+++ a/include/trace/events/mmflags.h
@@ -100,7 +100,6 @@
 #define __def_pageflag_names						\
 	DEF_PAGEFLAG_NAME(locked),					\
 	DEF_PAGEFLAG_NAME(waiters),					\
-	DEF_PAGEFLAG_NAME(error),					\
 	DEF_PAGEFLAG_NAME(referenced),					\
 	DEF_PAGEFLAG_NAME(uptodate),					\
 	DEF_PAGEFLAG_NAME(dirty),					\
--- a/include/uapi/linux/kernel-page-flags.h~mm-remove-pg_error
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -7,7 +7,7 @@
  */
 
 #define KPF_LOCKED		0
-#define KPF_ERROR		1
+#define KPF_ERROR		1	/* Now unused */
 #define KPF_REFERENCED		2
 #define KPF_UPTODATE		3
 #define KPF_DIRTY		4
_

Patches currently in -mm which might be from willy@infradead.org are

printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch
swap-convert-swapon-to-use-a-folio.patch

