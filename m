Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B052525761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742223; cv=none; b=AaL3APvWuEu29HoIEpXSy/42jQ7XmBrBO4L8DR9BLn8/Ns21alfU75jx2yUthsmpkBB3idYpgC8xx9OeeJTfn8JOKDyGkYegLLF6n0RxLAWaYblwhC2rbxblIys3ots0CqQJoyad70WxLSqUDhsluIhB/svH6wLC88gkzhIlpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742223; c=relaxed/simple;
	bh=W+jQXLJ2HBOTs3119Vc3FuRUZVMan1uGF8HwPhgOpFc=;
	h=Date:To:From:Subject:Message-Id; b=F53h5xGM7LgP2UdKRIoLMfLKNjYQs+uTSyVwUVUnpje+/1JW/k81GN8s8pu5cUZuh/DsHGhh9cZWmjUcr9sLZLJ76x7o9yADaXAngiiuC59ZCr4QK7jW/OFHEo+62ZlGWIR1GrosemSJeA6qHh+GarN8Ufv7Z3WTsfyBepiS1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ptzxyzzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ptzxyzzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8577CC4CED6;
	Mon, 13 Jan 2025 04:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742223;
	bh=W+jQXLJ2HBOTs3119Vc3FuRUZVMan1uGF8HwPhgOpFc=;
	h=Date:To:From:Subject:From;
	b=PtzxyzzoHTUByI7fSXmNRQQGGHy9P7KIskKrG/vPQe2P6whoL3WLSKQuAc75byFiu
	 oj0URIi74DJ17Ef2tQnX/cxtuF69BDf5OTd4ueXUsLT6zWgDimkjxbhXtCvdRmrt8M
	 3Ee5E1S+fPdlMkiUybf7y6XrPNpVRPU9yqOcCt54=
Date: Sun, 12 Jan 2025 20:23:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch removed from -mm tree
Message-Id: <20250113042343.8577CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_map_and_dirty_page() to ocfs2_map_and_dirty_folio()
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert ocfs2_map_and_dirty_page() to ocfs2_map_and_dirty_folio()
Date: Thu, 5 Dec 2024 17:16:46 +0000

All callers now have a folio, so skip the folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20241205171653.3179945-19-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c        |   17 ++++++++---------
 fs/ocfs2/alloc.h        |    6 +++---
 fs/ocfs2/refcounttree.c |    5 ++---
 3 files changed, 13 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio
+++ a/fs/ocfs2/alloc.c
@@ -6808,11 +6808,10 @@ static int ocfs2_zero_func(handle_t *han
 	return 0;
 }
 
-void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
-			      unsigned int from, unsigned int to,
-			      struct page *page, int zero, u64 *phys)
+void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
+		size_t from, size_t to, struct folio *folio, int zero,
+		u64 *phys)
 {
-	struct folio *folio = page_folio(page);
 	int ret, partial = 0;
 	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
@@ -6871,8 +6870,8 @@ static void ocfs2_zero_cluster_folios(st
 		BUG_ON(from > PAGE_SIZE);
 		BUG_ON(to > PAGE_SIZE);
 
-		ocfs2_map_and_dirty_page(inode, handle, from, to, &folio->page, 1,
-					 &phys);
+		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
+				&phys);
 
 		start = (folio->index + 1) << PAGE_SHIFT;
 	}
@@ -7120,7 +7119,7 @@ int ocfs2_convert_inline_data_to_extents
 
 		/*
 		 * Save two copies, one for insert, and one that can
-		 * be changed by ocfs2_map_and_dirty_page() below.
+		 * be changed by ocfs2_map_and_dirty_folio() below.
 		 */
 		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
@@ -7143,8 +7142,8 @@ int ocfs2_convert_inline_data_to_extents
 			goto out_unlock;
 		}
 
-		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, &folio->page, 0,
-					 &phys);
+		ocfs2_map_and_dirty_folio(inode, handle, 0, page_end, folio, 0,
+				&phys);
 	}
 
 	spin_lock(&oi->ip_lock);
--- a/fs/ocfs2/alloc.h~ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio
+++ a/fs/ocfs2/alloc.h
@@ -254,9 +254,9 @@ static inline int ocfs2_is_empty_extent(
 	return !rec->e_leaf_clusters;
 }
 
-void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
-			      unsigned int from, unsigned int to,
-			      struct page *page, int zero, u64 *phys);
+void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
+		size_t from, size_t to, struct folio *folio, int zero,
+		u64 *phys);
 /*
  * Structures which describe a path through a btree, and functions to
  * manipulate them.
--- a/fs/ocfs2/refcounttree.c~ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio
+++ a/fs/ocfs2/refcounttree.c
@@ -2975,9 +2975,8 @@ retry:
 			}
 		}
 
-		ocfs2_map_and_dirty_page(inode,
-					 handle, from, to,
-					 &folio->page, 0, &new_block);
+		ocfs2_map_and_dirty_folio(inode, handle, from, to,
+				folio, 0, &new_block);
 		folio_mark_accessed(folio);
 unlock:
 		folio_unlock(folio);
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


