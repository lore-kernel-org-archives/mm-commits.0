Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6704B2837A
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741808; cv=none; b=KvSaR5XMLi8ywfA3FYMuDFnfB1+pHJAMbjDy23xsNX90dbcivD9sI98uu/yDFQXKt2rwz9eIpnricW7cs1w1aIjuq2J3GJz+iPvMY2lKDUTgq70wJkemVSkaE3MecEV62gs/VC4blvD9tQ5UCTFEkCK727xuWmiBNqQtajWnpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741808; c=relaxed/simple;
	bh=4ZieAixBjowXeGWBx0wC+4+8uoi/lkPqCc1DVunpSAg=;
	h=Date:To:From:Subject:Message-Id; b=nVMto/pXVmG6DC1wX1fiyhoYX+vwEabCLusGERTtNsEmywwN4DQvNT75LWTO+P7UBM9m2WaxPnyNiM6LUjOaJdUMfGAwcnFDEaTsp22g+JgoutsWmwuRnFGSHLA6YwPhysAecLeZCMfLWt3W9P+9OaHQKmcIjtUxkhVOpOXnE+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DqWpJDLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DqWpJDLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D340C4CED6;
	Mon, 13 Jan 2025 04:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741808;
	bh=4ZieAixBjowXeGWBx0wC+4+8uoi/lkPqCc1DVunpSAg=;
	h=Date:To:From:Subject:From;
	b=DqWpJDLoPsBp3RRdSi/BuxQSeauXhJysDZ/yGt9D4xBNeW2ts4r5NnXxKZRHiVamo
	 Pau220tklVz1w+TUO4vA+O+syeAakux86sNQP6qpUJj5LVQQHwktwkj18xy2p+2VBP
	 43McRtKgjqXhoeZx9Gwd+sinHoes5+Bn+E7Q5SQo=
Date: Sun, 12 Jan 2025 20:16:47 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-convert-squashfs_fill_page-to-take-a-folio-fix.patch removed from -mm tree
Message-Id: <20250113041648.2D340C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix "convert squashfs_fill_page() to take a folio"
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_fill_page-to-take-a-folio-fix.patch

This patch was dropped because it was folded into squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: fix "convert squashfs_fill_page() to take a folio"
Date: Fri, 10 Jan 2025 16:32:58 +0000

I got the polarity of "uptodate" wrong.  Rename it.  Thanks to Ryan for
testing; please fold into above named patch, and he'd like you to add

Link: https://lkml.kernel.org/r/20250110163300.3346321-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_fill_page-to-take-a-folio-fix
+++ a/fs/squashfs/file.c
@@ -400,7 +400,7 @@ void squashfs_copy_cache(struct folio *f
 			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
 		struct folio *push_folio;
 		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
-		bool uptodate = true;
+		bool updated = false;
 
 		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
 
@@ -415,9 +415,9 @@ void squashfs_copy_cache(struct folio *f
 		if (folio_test_uptodate(push_folio))
 			goto skip_folio;
 
-		uptodate = squashfs_fill_page(push_folio, buffer, offset, avail);
+		updated = squashfs_fill_page(push_folio, buffer, offset, avail);
 skip_folio:
-		folio_end_read(push_folio, uptodate);
+		folio_end_read(push_folio, updated);
 		if (i != folio->index)
 			folio_put(push_folio);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
mm-remove-pagetranstail.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch
iov_iter-remove-setting-of-page-index.patch
squashfs-use-a-folio-throughout-squashfs_read_folio.patch
squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch
squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch
squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch
squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

