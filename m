Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDDB19D8AC
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307368; cv=none; b=Ew8HT3coK/1CyCzSnHdAms00MpuKdqUigj8LM/dtT4sH0NoW4ZXteBVbq8fHJ3+U6IUm4hJtSohVgC0msZNP4jBM9x8lg5t5ON9tA6JQjC+DI4IwYMaWI5QTldvIvrqz6b9sI9VljNqy0jaqIHZlIN0HO/Q9lfsN/EPf7v2Ustw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307368; c=relaxed/simple;
	bh=dmG9A2irqbeYs+cdrEmhpTFW6RiQoukyPtFPBzoMksA=;
	h=Date:To:From:Subject:Message-Id; b=aDI4PD4n7Wh/SGB8wJEa43u9p/8kza8aBtSI0MeRBpPfZY96j3u8yvTxCnNuWEq2Ib/LciMSkZfrNbvVctpYmm9XvqvlLK6otcHhoc46pM4a7RZ5iHO8ccHPvBMb7RE5TQ+S39i02zebq8MzybBNkwNzY2eNEKVvgbkSZm62Cvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I6LodCfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I6LodCfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93053C4CED0;
	Wed,  8 Jan 2025 03:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307367;
	bh=dmG9A2irqbeYs+cdrEmhpTFW6RiQoukyPtFPBzoMksA=;
	h=Date:To:From:Subject:From;
	b=I6LodCfXs1uMXKNj46GHvpoKV3lQBcIpnSucVI5T0UEUe+byvk2bs/UEfhlJGZ6He
	 cp43HQsrWbgtb5LYR9pVIXGVXrbjQHTz5qc+BczKxceQePic6qPng1v4p2GxXI1zkk
	 rrKy3BDjMMJnQyuxGBF3uJKph8VRu4SFqWHo4qZ4=
Date: Tue, 07 Jan 2025 19:36:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch added to mm-unstable branch
Message-Id: <20250108033607.93053C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: drop streaming/uncached pages when writeback completes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch

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
Subject: mm/filemap: drop streaming/uncached pages when writeback completes
Date: Fri, 20 Dec 2024 08:47:47 -0700

If the folio is marked as streaming, drop pages when writeback completes. 
Intended to be used with RWF_DONTCACHE, to avoid needing sync writes for
uncached IO.

Link: https://lkml.kernel.org/r/20241220154831.1086649-10-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/filemap.c~mm-filemap-drop-streaming-uncached-pages-when-writeback-completes
+++ a/mm/filemap.c
@@ -1571,6 +1571,27 @@ int folio_wait_private_2_killable(struct
 }
 EXPORT_SYMBOL(folio_wait_private_2_killable);
 
+/*
+ * If folio was marked as dropbehind, then pages should be dropped when writeback
+ * completes. Do that now. If we fail, it's likely because of a big folio -
+ * just reset dropbehind for that case and latter completions should invalidate.
+ */
+static void folio_end_dropbehind_write(struct folio *folio)
+{
+	/*
+	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
+	 * but can happen if normal writeback just happens to find dirty folios
+	 * that were created as part of uncached writeback, and that writeback
+	 * would otherwise not need non-IRQ handling. Just skip the
+	 * invalidation in that case.
+	 */
+	if (in_task() && folio_trylock(folio)) {
+		if (folio->mapping)
+			folio_unmap_invalidate(folio->mapping, folio, 0);
+		folio_unlock(folio);
+	}
+}
+
 /**
  * folio_end_writeback - End writeback against a folio.
  * @folio: The folio.
@@ -1581,6 +1602,8 @@ EXPORT_SYMBOL(folio_wait_private_2_killa
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool folio_dropbehind = false;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1602,9 +1625,14 @@ void folio_end_writeback(struct folio *f
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+	if (!folio_test_dirty(folio))
+		folio_dropbehind = folio_test_clear_dropbehind(folio);
 	if (__folio_end_writeback(folio))
 		folio_wake_bit(folio, PG_writeback);
 	acct_reclaim_writeback(folio);
+
+	if (folio_dropbehind)
+		folio_end_dropbehind_write(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
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

