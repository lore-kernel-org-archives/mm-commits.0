Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674EA10F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327681; cv=none; b=rKz7USXrEoLhhTDAuXN+Twuxdn5zXtodX7ZMpKbg40hyOL6cTBDqZ+AujjTFCZ/lr5KgcbU+LhjSzqFPbhcP2iEBiB5gdKhK4GIoTTfxTkSwLBgungzFVhg0fCFj2h7eWrJGUCzYub2/Ot5O+rJzzBI1O2Pp9PSQj7vD1g1svZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327681; c=relaxed/simple;
	bh=UfFGxHQFlLrz18SNVKuKoIcrOi0KXoqWYrl/Y15hZkI=;
	h=Date:To:From:Subject:Message-Id; b=eou7p5mltG9+8vjvgNXQ8fKzgVfVQqNUmdzz2jg8dEyq0mFOY83I+X50F30vraeKDY8hZ+viiQu/G98D1MfD/jPz2cWjcfncy6G8Y++kwF7xXcy4/Xv9I5knJrpoo6VSHkmeNsMmF1pezD/V/5uNiy6522BlxIm089BdmyZyY4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sYoJFe5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sYoJFe5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3366BC4CED0;
	Mon, 16 Dec 2024 05:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327681;
	bh=UfFGxHQFlLrz18SNVKuKoIcrOi0KXoqWYrl/Y15hZkI=;
	h=Date:To:From:Subject:From;
	b=sYoJFe5MYSV4t6C2SIDQCghgUn8UZoc4aOmEQ1IJ3O710SdvzLHnY1DEZtw20p7GR
	 VrWHCpOYIS8gYeVt26Un/2pjd00yaZH47fknvBROJdqwu0Z8BB0pYMMnmGPs+fJZ+n
	 ZR/0F1pOoPTdUfAa/6s9ZRu1eTalyd4qPJkr+VLk=
Date: Sun, 15 Dec 2024 21:41:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054121.3366BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_map_and_dirty_page() to ocfs2_map_and_dirty_folio()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ocfs2-convert-w_target_page-to-w_target_folio.patch
ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch
ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch
ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch
ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch
ocfs2-convert-w_pages-to-w_folios.patch
ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch
ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch
ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch
ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch
ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch
ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch
ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch
ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch
ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

