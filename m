Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022988BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337151; cv=none; b=hgfiYgHVQqQ9qu+vWs2WGKTD6nBDC1UJfPy1VSnnBYsQbnUaxo1OyMCnUSpTII5j1qr8q2AiDspWo8JWt9PVI6aX21vxFXhV0dF57eOU8RZ75NwSAH3zciHuhv3cBQi3zrlMhNz8kitLflHjenDWKTd7BSCGXQGhlfCPLFGauYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337151; c=relaxed/simple;
	bh=bf5O/LmdWyThBth6AJ23qkVZLkTSPslOp8CZ5LgQIvQ=;
	h=Date:To:From:Subject:Message-Id; b=KtOSUlmsUSaNwFkMTcSTHv73nmB6dAKJRJJD4yWjTuiIdTHvZbPDur8AuGuvIANLA9AiQTEUzRRKxHj9yO2eEwSXwAf1H94Ejj9VQLgf1S2SihGzS1th5zUYUF5sOetCC7E4JGE9x+0XzVuBAXxMa9KWMYFDWZDsZSOPnYBag38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W64gPzis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W64gPzis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B07DC4CEE0;
	Mon, 20 Jan 2025 01:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337150;
	bh=bf5O/LmdWyThBth6AJ23qkVZLkTSPslOp8CZ5LgQIvQ=;
	h=Date:To:From:Subject:From;
	b=W64gPziscab7opgEb4YKDEn7QaLKQ1MTcb35v+QIb1KEHcJNn2cN/2KaRG2jjBGT4
	 zBdkQQdu5lxATtAQ3I1TakAkZUoorfmN5HazTmwFmWCervFgTEfRcau0aUdmAMOgLI
	 AIwODH+pEfnPlyrnU3jIBG4ejiTN57wHESx5JTcE=
Date: Sun, 19 Jan 2025 17:39:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch removed from -mm tree
Message-Id: <20250120013910.6B07DC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: drop streaming/uncached pages when writeback completes
has been removed from the -mm tree.  Its filename was
     mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


