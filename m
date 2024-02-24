Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015CFD52F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739469; cv=none; b=h1ZnjZUX9QwWbxBeq95bY0LmilNqNw3EQJXRoPIhvTlEoQQwnmMinHT5PQuilxr2D+Cx+OFUsdxHWxSqMrTSEBMLaWjEpc/yXE8mf4uV8HG/o+8CQbM1jVNatuq1mYOIamHDC2twfNUAhb18KNeDoHtCUdAY2A8ectk42bgy5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739469; c=relaxed/simple;
	bh=tRtZTS34abEfkdBjvqjExO273eIjPIzP+7XK3zPD96o=;
	h=Date:To:From:Subject:Message-Id; b=FBbTElvaUBwJa4eNuSZac/+o0JdUFdCYAAFGfeteVnZ1xgpuEejQcv4BLin0pW1AJfipfY390boX85nAYU/vR6wuCruxHnBnrwOoxr90u1wRE/LkGQrcWR8j8QX29JHnAcFPznLCWlM6cFzrAcyOwbjXngycbdqvdv+7eM/AQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XmBQvGWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XmBQvGWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EA5C43390;
	Sat, 24 Feb 2024 01:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739468;
	bh=tRtZTS34abEfkdBjvqjExO273eIjPIzP+7XK3zPD96o=;
	h=Date:To:From:Subject:From;
	b=XmBQvGWx2c3bTUGtCv74CIv13fT9yiXnfYCkNarn+E0bhlRmOBM08rZaj7UEjbIS1
	 bvCiGFyr3gz6/uESsMGDaJ9Cvi/l1xWxxHNNsC4ShaP9I+NhZylbllWAheCmqeVNdo
	 7y2LR/5YKbqIiwZq+VbAYszGJzJFuO0/5MhJFlgY=
Date: Fri, 23 Feb 2024 17:51:08 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch removed from -mm tree
Message-Id: <20240224015108.C1EA5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: move the folio_prepare_writeback loop out of write_cache_pages()
has been removed from the -mm tree.  Its filename was
     writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: move the folio_prepare_writeback loop out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:47 +0100

Move the loop for should-we-write-this-folio to writeback_get_folio.

[hch@lst.de: fold loop into existing helper instead of a separate one per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-13-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/page-writeback.c~writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2411,6 +2411,7 @@ static struct folio *writeback_get_folio
 {
 	struct folio *folio;
 
+retry:
 	folio = folio_batch_next(&wbc->fbatch);
 	if (!folio) {
 		folio_batch_release(&wbc->fbatch);
@@ -2418,8 +2419,17 @@ static struct folio *writeback_get_folio
 		filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
 				wbc_to_tag(wbc), &wbc->fbatch);
 		folio = folio_batch_next(&wbc->fbatch);
+		if (!folio)
+			return NULL;
+	}
+
+	folio_lock(folio);
+	if (unlikely(!folio_prepare_writeback(mapping, wbc, folio))) {
+		folio_unlock(folio);
+		goto retry;
 	}
 
+	trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 	return folio;
 }
 
@@ -2480,14 +2490,6 @@ int write_cache_pages(struct address_spa
 		if (!folio)
 			break;
 
-		folio_lock(folio);
-		if (!folio_prepare_writeback(mapping, wbc, folio)) {
-			folio_unlock(folio);
-			continue;
-		}
-
-		trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-
 		error = writepage(folio, wbc, data);
 		wbc->nr_to_write -= folio_nr_pages(folio);
 
_

Patches currently in -mm which might be from willy@infradead.org are


