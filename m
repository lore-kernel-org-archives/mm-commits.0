Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6777E19CCFA
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307358; cv=none; b=bAN5Pa66nWXAkFIuTl4y+JS6tMklGmrRphlcGSWRr3ehv3dSh5a8SCZVMpQNPXshF7sYEwNJ87tHyAhrukUuMkbAnpjjJIPZd5Atcyjitpa+oFxkdomrtTyBoXlJ6f94Mu3i4AF0ZpbMul9lJjGkayzmy3FIdh1SLj+ljd4QMw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307358; c=relaxed/simple;
	bh=JhzqlSZHqAZy+t+USutknoOtvC+mxIeAA37kzAKqYIg=;
	h=Date:To:From:Subject:Message-Id; b=KoIvDJ+3oZClcZwBEwopJ+yYB/OG18fWHqDCDr7wq70fui+6i6CtnSlgcrh8BMQ63G8gTfV4O+E7JgLv9QgWsFK4dBsWQPtn7lUt/jHVc00zayTLWd9BX2lIBve1I9uSp1PVCbiOS0pUsCFjprdbOHzNsqPC7cdEYhlj0+Ibf+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C5UCGzpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C5UCGzpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3956C4CED0;
	Wed,  8 Jan 2025 03:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307357;
	bh=JhzqlSZHqAZy+t+USutknoOtvC+mxIeAA37kzAKqYIg=;
	h=Date:To:From:Subject:From;
	b=C5UCGzpyqNKtm5elOoDY1EH4AVgIBGs9RyfKEZkeBu7pdiMG7GOCM5D46Xk9d+yEP
	 Ac03Pnq9lmIg1oPf+Wr/Sl/SZIU/6AtthRMtAS5I4jwIsIjU7WuMsbkaVe2mxjKPI+
	 /+WrQIZcHS0Ow1v65C9AvoGI0UnddTAwVDu0Od8w=
Date: Tue, 07 Jan 2025 19:35:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-add-readahead_control-dropbehind-member.patch added to mm-unstable branch
Message-Id: <20250108033557.D3956C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: add readahead_control->dropbehind member
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-add-readahead_control-dropbehind-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-add-readahead_control-dropbehind-member.patch

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
Subject: mm/readahead: add readahead_control->dropbehind member
Date: Fri, 20 Dec 2024 08:47:43 -0700

If ractl->dropbehind is set to true, then folios created are marked as
dropbehind as well.

Link: https://lkml.kernel.org/r/20241220154831.1086649-6-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 mm/readahead.c          |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-readahead-add-readahead_control-dropbehind-member
+++ a/include/linux/pagemap.h
@@ -1369,6 +1369,7 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
 };
--- a/mm/readahead.c~mm-readahead-add-readahead_control-dropbehind-member
+++ a/mm/readahead.c
@@ -181,7 +181,13 @@ static void read_pages(struct readahead_
 static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 				       gfp_t gfp_mask, unsigned int order)
 {
-	return filemap_alloc_folio(gfp_mask, order);
+	struct folio *folio;
+
+	folio = filemap_alloc_folio(gfp_mask, order);
+	if (folio && ractl->dropbehind)
+		__folio_set_dropbehind(folio);
+
+	return folio;
 }
 
 /**
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

