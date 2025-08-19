Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D6221B196
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755644759; cv=none; b=hogqFfklPDz3doaQzf5XerWUWg1QCeJhpnbUcX/EvVzSKTiQOPQ0qdAdqLhB6U4HgcQe5yHgCehy/0E7wFJA1iUXXxExjyZx1AhpEGNAEBC37ZsPCvKApM5EjNVMXCDdh1xLbdHcOBaPPXh4fdPd9hANLgmxyqBe4t9AKaCSXoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755644759; c=relaxed/simple;
	bh=G9Kbny3+oSw/dmM9Q9mNIadCUSG4/zTtcrgXp/sp7RM=;
	h=Date:To:From:Subject:Message-Id; b=jHxajt+hd9vyu0gspciva9iTQ63cseCj8+RJo8d7C8sl1mjpVW7JHm+FLGxCDlyMMdapeebXO/G7jagnEbgoEtcMeX9lz1lxGbIwmqP7L1Kx7rkWCzXnk5Qwnh8bOSVHayaeCKBQyUtWZaKQr5mBatxSFVt8lyGfkNVJ+m+9Kt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eVW795B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eVW795B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A62C4CEF1;
	Tue, 19 Aug 2025 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755644758;
	bh=G9Kbny3+oSw/dmM9Q9mNIadCUSG4/zTtcrgXp/sp7RM=;
	h=Date:To:From:Subject:From;
	b=eVW795B5XGT61luwv3tpT00a4ZaKlvaocoGY5UWMUGvkH5D6/A7bP05JNfne1oOfS
	 LNpovUvZKyqXM1IOj0GWDPVmxhpqnk8gGXFQdfkBtyT153GXv0kgjiUZx+EmUWksax
	 UwQ0FwSxwS1qoDEDbafBCgDyq2gUdtxKVyBqV20s=
Date: Tue, 19 Aug 2025 16:05:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,david@redhat.com,almaz.alexandrovich@paragon-software.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-stop-using-write_cache_pages.patch added to mm-new branch
Message-Id: <20250819230558.74A62C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs: stop using write_cache_pages
has been added to the -mm mm-new branch.  Its filename is
     bcachefs-stop-using-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-stop-using-write_cache_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Christoph Hellwig <hch@lst.de>
Subject: bcachefs: stop using write_cache_pages
Date: Mon, 18 Aug 2025 08:10:09 +0200

Stop using the obsolete write_cache_pages and use writeback_iter directly.
This basically just open codes write_cache_pages without the indirect
call, but there's probably ways to structure the code even nicer as a
follow on.

Link: https://lkml.kernel.org/r/20250818061017.1526853-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/fs-io-buffered.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/fs-io-buffered.c~bcachefs-stop-using-write_cache_pages
+++ a/fs/bcachefs/fs-io-buffered.c
@@ -655,6 +655,17 @@ do_io:
 	return 0;
 }
 
+static int bch2_write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, void *data)
+{
+	struct folio *folio = NULL;
+	int error;
+
+	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+		error = __bch2_writepage(folio, wbc, data);
+	return error;
+}
+
 int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct bch_fs *c = mapping->host->i_sb->s_fs_info;
@@ -663,7 +674,7 @@ int bch2_writepages(struct address_space
 	bch2_inode_opts_get(&w->opts, c, &to_bch_ei(mapping->host)->ei_inode);
 
 	blk_start_plug(&w->plug);
-	int ret = write_cache_pages(mapping, wbc, __bch2_writepage, w);
+	int ret = bch2_write_cache_pages(mapping, wbc, w);
 	if (w->io)
 		bch2_writepage_do_io(w);
 	blk_finish_plug(&w->plug);
_

Patches currently in -mm which might be from hch@lst.de are

mempool-rename-struct-mempool_s-to-struct-mempool.patch
ntfs3-stop-using-write_cache_pages.patch
bcachefs-stop-using-write_cache_pages.patch
mm-remove-write_cache_pages.patch

