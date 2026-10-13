Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A293A3019C8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 02:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857933; cv=none; b=VB8KSmQXxcxWbfxRsv/dFvNJZDS3PYUmuIh69Hz6bGP+LZAKB091D1UJnJnq4JXdwPpNcdYCBip4PLNiNQxcHxzbcHKPB1OHGJJpuqKh7QpZvHgm6LO2zJSvEZaf4ycaPEe/FjhRijeROkc3YhLFzERSYKvLrYQ/yH2GKGlhYtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857933; c=relaxed/simple;
	bh=sOrdJQ0UfrEI13Jr2kMPrjRS1LhhLxC17GcJ+DeVQhc=;
	h=Date:To:From:Subject:Message-Id; b=iug5O3dR86oHgKXQxzCKi6/TiUYZzUAGQlLdBYmyVxa+/WA7PoUX3uGuwQs9JxE51GNRdXlh2BREsvO4YAxEusOuhfDAtOCq/U2Le71dQDLeqUDXJOXK+HkYB/2I7DOnSVdrgfTjoADhxzYGluBgxJPqcXxaG+kIJyrSSl4EcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ntReiAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ntReiAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12B1F000FF;
	Tue, 13 Oct 2026 02:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791857932;
	bh=/vC3Sq40uIZhZe8wo0uosDdQxE+8XdzDilCE3hrsTF8=;
	h=Date:To:From:Subject;
	b=0ntReiAlxn18pUagaRV9/Kz4YmP8ZcGVY4M1+7tuyFfwg8mDaSu3uxlXgGYGAGNWk
	 5FNkYustvrN5SDKAvanZ6OwrPP/QiEu07iQ7+iDExe4sGag0NCtj7KMKBTMBb5Ys0k
	 ta4xadOcY0FPSGZymAJsrPhbeixDc1rLk2Qwq3t4=
Date: Mon, 12 Oct 2026 19:18:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com,jack@suse.cz,axboe@kernel.dk,ngocthang2710.1999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-filemap-annotate-lockless-reads-of-mapping-nrpages.patch removed from -mm tree
Message-Id: <20261013021852.3F12B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: annotate lockless reads of mapping->nrpages
has been removed from the -mm tree.  Its filename was
     mm-filemap-annotate-lockless-reads-of-mapping-nrpages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: mm/filemap: annotate lockless reads of mapping->nrpages
Date: Mon, 12 Oct 2026 21:39:21 +0700

mapping->nrpages is updated under the i_pages lock but is read locklessly
as a cheap "anything cached?" hint, e.g.  in invalidate_bdev() and
filemap_write_and_wait_range().  KCSAN reports the race:

  BUG: KCSAN: data-race in __filemap_add_folio / invalidate_bdev

  read-write to 0xffff8881004c4178 of 8 bytes by task 3600 on cpu 0:
   __filemap_add_folio+0x6b7/0x910 mm/filemap.c:919
   filemap_add_folio+0x1cd/0x380
   page_cache_ra_unbounded+0x1a4/0x3a0
   ...
   blkdev_read_iter+0x21e/0x2d0
  read to 0xffff8881004c4178 of 8 bytes by task 3601 on cpu 1:
   invalidate_bdev+0x25/0x70 block/bdev.c:98
   ext4_fill_super+0x2ccb/0x37b0

The same counter also races with filemap_write_and_wait_range() through
mapping_needs_writeback().

The race is benign: a stale value only makes the caller do or skip a
harmless invalidate/flush pass.  Mark the lockless reads with data_race()
in invalidate_bdev() and in the two callers of mapping_needs_writeback(),
rather than inside the helper, so a future user needing a reliable answer
is not silently covered.

Link: https://lore.kernel.org/20261012143921.283806-1-ngocthang2710.1999@gmail.com
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
---

 block/bdev.c |    3 ++-
 mm/filemap.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/block/bdev.c~mm-filemap-annotate-lockless-reads-of-mapping-nrpages
+++ a/block/bdev.c
@@ -95,7 +95,8 @@ void invalidate_bdev(struct block_device
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
-	if (mapping->nrpages) {
+	/* Lockless hint; a stale value only costs or skips a harmless pass */
+	if (data_race(mapping->nrpages)) {
 		invalidate_bh_lrus();
 		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
--- a/mm/filemap.c~mm-filemap-annotate-lockless-reads-of-mapping-nrpages
+++ a/mm/filemap.c
@@ -680,7 +680,8 @@ int filemap_write_and_wait_range(struct
 	if (lend < lstart)
 		return 0;
 
-	if (mapping_needs_writeback(mapping)) {
+	/* Lockless hint; a stale value is harmless */
+	if (data_race(mapping_needs_writeback(mapping))) {
 		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/*
 		 * Even if the above returned error, the pages may be
@@ -782,7 +783,8 @@ int file_write_and_wait_range(struct fil
 	if (lend < lstart)
 		return 0;
 
-	if (mapping_needs_writeback(mapping)) {
+	/* Lockless hint; a stale value is harmless */
+	if (data_race(mapping_needs_writeback(mapping))) {
 		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO)
_

Patches currently in -mm which might be from ngocthang2710.1999@gmail.com are


