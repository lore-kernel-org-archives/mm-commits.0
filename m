Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2911802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307355; cv=none; b=nmW+Dmkc7l/OvmbChxZAWkSTkP2FXuqJ7SyNZT6g2Y48DaHTYYt4q8/uEXOSq7h3R+BEmT+79EF29i8fNuF14C70olY1bfYLBmnaMtUcU6A55uTKLXV0lqZaxqwRPv5IXG5BCfAJMYuVlHYndSnyOQhYDNZgoFf96AS5Pa6RaDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307355; c=relaxed/simple;
	bh=ddm3iErUYkROSFO4Zqmdq1/9IsCo7WneAopCr1LgSeo=;
	h=Date:To:From:Subject:Message-Id; b=JGW0zu5Il7qSkjkBmFYQ9BspSsm4bcRTT8m/+0/+km8xjI3SBEmfYNeEIi+AZsJ9+CthiuE231j4G7tP2YDEF5p6rVxEiSsXTRyre0hyZz5cbp0kjVeYqOfSp65EoLSC7NLIyzIS8jh4BvRhMGSmZEFR2KUw1ghUC4j7shAju3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FBr7hhOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FBr7hhOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926E6C4CED0;
	Wed,  8 Jan 2025 03:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307355;
	bh=ddm3iErUYkROSFO4Zqmdq1/9IsCo7WneAopCr1LgSeo=;
	h=Date:To:From:Subject:From;
	b=FBr7hhOteiA8iazNhJjbvBSvpa11dQCaus2tSY2SbZGquoxMnUagcFQXhfgwOH2pb
	 vwwtm6J2FfnVmgBTPTS5TS3ubhQNDbLS/7qRYP36pLt0dmlNs4h3xOh8Z7zC9AyE3p
	 wUzDOxb4zOE66T2keb+qeznSFcpSh+zZ/DRabMus=
Date: Tue, 07 Jan 2025 19:35:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pg_dropbehind-folio-flag.patch added to mm-unstable branch
Message-Id: <20250108033555.926E6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add PG_dropbehind folio flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pg_dropbehind-folio-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pg_dropbehind-folio-flag.patch

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

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch

