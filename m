Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B3628C2CE
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755840008; cv=none; b=KY+GWj4JueBGc2ALruSDKPDjVwEhAshFMSrqHEWvPcGMTi1ZXu3duY49fGwmr+d1uAB81AS7YaYokF9J0xnvGcYOxvcysXpERg5N3Px5tL+8pxVkpBdvAcC6DskHiqZ1V7qX3iVQQkDuhkaAI/G3KobAHE2RlB0EQl88GcSPhyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755840008; c=relaxed/simple;
	bh=CbPi79XV0UiW+cX5AuCgJlxwNor5Bod3sTEv4iK7DS4=;
	h=Date:To:From:Subject:Message-Id; b=DBSgKkrGIDigKFcvJGfQRPIY13HG+r1WVThk4a2rk3skqv3YN7DqZ2oSVH1t3LSaVC5PCXPe2wvQG7rQDfOnyf2b35u1n1YDwgoEQfLbn8RcAOoeEfqtGOOysXO/j/7/UmG1tWrjVOLKR6q3HmgMe+3OVJuCw/QRVQ3eMyW376Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YiPv0DIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YiPv0DIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A7DC113CF;
	Fri, 22 Aug 2025 05:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755840008;
	bh=CbPi79XV0UiW+cX5AuCgJlxwNor5Bod3sTEv4iK7DS4=;
	h=Date:To:From:Subject:From;
	b=YiPv0DILJrGtigTdfFi3Myd/XOYz2WOF+izZYemcpf9Q3U/0fUt9mJ0RplBjHM/es
	 pIdO6k3hbtM/uMI61pLM77nieiozLgERkgZCB0N5OROQUKlYUuniX2xl/SU4/2D2yi
	 zHb9PaAzsbBteUqDNCFOXIi/U2GA44Z4WI7190LQ=
Date: Thu, 21 Aug 2025 22:20:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,david@redhat.com,almaz.alexandrovich@paragon-software.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bcachefs-stop-using-write_cache_pages.patch removed from -mm tree
Message-Id: <20250822052007.E0A7DC113CF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: stop using write_cache_pages
has been removed from the -mm tree.  Its filename was
     bcachefs-stop-using-write_cache_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-remove-write_cache_pages.patch

