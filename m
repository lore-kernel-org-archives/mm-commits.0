Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5FD17B41E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340181; cv=none; b=CtgBza6GA02xYya0vDkhc96taZVTYDcTBPJKvvu3epJElEa7Gq16ty//m8t1o5LZPap07XMz+2FfJZT40NtQMPtCxuVc4p2UZ7Mkt/s3OpkfoHs+CbfcmPHFFWHbeQk5SVC8ZOhM+9KTULoEqLShDrv6259suVcAlDixg9VSA+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340181; c=relaxed/simple;
	bh=2TYqVhXAvY/WwlpJW2HuE3JnLSNynIgv7vdkG4xElsw=;
	h=Date:To:From:Subject:Message-Id; b=nQIKtNEwG/e7YJtw0ixgy8zyaUD33yV31J1Wz/o5gncxQLBdWfoRtuBJY7EVd9TVuJ136BY/Z7NZAIH4SvOmZx2rQ6YuvAokMWf3IbgeDAY5llBCds9IICdpLWBhda4W5ZkdE53zTkz96wRQdtAlusb3gapFTc4v/kHll/fTejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ui2La3ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ui2La3ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48840C32781;
	Tue, 25 Jun 2024 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340181;
	bh=2TYqVhXAvY/WwlpJW2HuE3JnLSNynIgv7vdkG4xElsw=;
	h=Date:To:From:Subject:From;
	b=Ui2La3ZWqxKwFR5HIX9xhys6W71IHCQI4tIbZFdexedplxOWiX2tvwvo22MykjV8Q
	 4kp/FUb3gG4ZfnZamvFnZ7lAJv6eAy90ZxrMdNbRHtgHwO+ZtsUkNGvPZApm7Hx+EI
	 hDz64IcmUr1jPonuUMspVEIO5ldVRSh8af3AcAFk=
Date: Tue, 25 Jun 2024 11:29:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-drop-index-argument-of-page_cache_async_readahead.patch added to mm-unstable branch
Message-Id: <20240625182941.48840C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: drop index argument of page_cache_async_readahead()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-drop-index-argument-of-page_cache_async_readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-drop-index-argument-of-page_cache_async_readahead.patch

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
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop index argument of page_cache_async_readahead()
Date: Tue, 25 Jun 2024 12:18:55 +0200

The index argument of page_cache_async_readahead() is just folio->index so
there's no point in passing is separately.  Drop it.

Link: https://lkml.kernel.org/r/20240625101909.12234-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/relocation.c   |    3 +--
 fs/btrfs/send.c         |    2 +-
 include/linux/pagemap.h |    7 +++----
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/relocation.c~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/fs/btrfs/relocation.c
@@ -2975,8 +2975,7 @@ static int relocate_one_folio(struct ino
 
 	if (folio_test_readahead(folio))
 		page_cache_async_readahead(inode->i_mapping, ra, NULL,
-					   folio, index,
-					   last_index + 1 - index);
+					   folio, last_index + 1 - index);
 
 	if (!folio_test_uptodate(folio)) {
 		btrfs_read_folio(NULL, folio);
--- a/fs/btrfs/send.c~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/fs/btrfs/send.c
@@ -5307,7 +5307,7 @@ static int put_file_data(struct send_ctx
 
 		if (folio_test_readahead(folio))
 			page_cache_async_readahead(mapping, &sctx->ra, NULL, folio,
-						   index, last_index + 1 - index);
+						   last_index + 1 - index);
 
 		if (!folio_test_uptodate(folio)) {
 			btrfs_read_folio(NULL, folio);
--- a/include/linux/pagemap.h~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/include/linux/pagemap.h
@@ -1293,8 +1293,7 @@ void page_cache_sync_readahead(struct ad
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @file: Used by the filesystem for authentication.
- * @folio: The folio at @index which triggered the readahead call.
- * @index: Index of first page to be read.
+ * @folio: The folio which triggered the readahead call.
  * @req_count: Total number of pages being read by the caller.
  *
  * page_cache_async_readahead() should be called when a page is used which
@@ -1305,9 +1304,9 @@ void page_cache_sync_readahead(struct ad
 static inline
 void page_cache_async_readahead(struct address_space *mapping,
 		struct file_ra_state *ra, struct file *file,
-		struct folio *folio, pgoff_t index, unsigned long req_count)
+		struct folio *folio, unsigned long req_count)
 {
-	DEFINE_READAHEAD(ractl, file, ra, mapping, index);
+	DEFINE_READAHEAD(ractl, file, ra, mapping, folio->index);
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch
readahead-make-sure-sync-readahead-reads-needed-page.patch
filemap-fix-page_cache_next_miss-when-no-hole-found.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-drop-pointless-index-from-force_page_cache_ra.patch
readahead-drop-index-argument-of-page_cache_async_readahead.patch
readahead-drop-dead-code-in-page_cache_ra_order.patch
readahead-drop-dead-code-in-ondemand_readahead.patch
readahead-disentangle-async-and-sync-readahead.patch
readahead-fold-try_context_readahead-into-its-single-caller.patch
readahead-simplify-gotos-in-page_cache_sync_ra.patch

