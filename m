Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7E6140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189514; cv=none; b=YuuXIZWRg4Jd2+2+vjK08/vkoZQlMOcVgMrjFFQGQeytrYBExmPMS3MrtR0xtyHu7qnu1ziJHt+qRH6gElJ6D3cuwNmxR7QKtYsiBq8pE34PLIYGUKccrG6MHhrBEXZ0nsd1jR56QbMDkO0Yt/PBEuMw7PolGpbOHGC8ID37Wjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189514; c=relaxed/simple;
	bh=gvNnAlxz6Nz5DCd5xdr6VXafkTUeI7kCmOH7lB7O+P8=;
	h=Date:To:From:Subject:Message-Id; b=gEAqH099q/Bxvtbg3ImNMAfFIidqXkyNNcYkkTU01cGhaNqDD/l3hoADUR26YL6bfjiv+5+t+RQvnRXgYoi1CVKEPHl9PiMp3/6Gum2X9v1GPLa4zZHWWeTEiseuy9gg+qai4KZMgY5/IXD7YY1tb5XurzlfP1bdjTVJt039IQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmN2fsUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmN2fsUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC43C4CEEC;
	Mon, 17 Mar 2025 05:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189513;
	bh=gvNnAlxz6Nz5DCd5xdr6VXafkTUeI7kCmOH7lB7O+P8=;
	h=Date:To:From:Subject:From;
	b=xmN2fsUBrlBkaDyuamMFPN6/+X8KirQu4l24jAmMOMSbzPCv9R3n8pfNaCoLntZbn
	 9M2NpG+IJyZFw6u2J5JK6CAhBi+zkf//+QijVuXoLqeCla4SLvnJNEqJKInxvUlm1F
	 u/vRefqQAANShOrzdIuHWPsxlrrcJ7Jo3iJEHU98=
Date: Sun, 16 Mar 2025 22:31:53 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-reference-to-bh-b_page.patch removed from -mm tree
Message-Id: <20250317053153.BDC43C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove reference to bh->b_page
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-reference-to-bh-b_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: remove reference to bh->b_page
Date: Thu, 13 Feb 2025 21:45:31 +0000

Buffer heads are attached to folios, not to pages.  Also
flush_dcache_page() is now deprecated in favour of flush_dcache_folio().

Link: https://lkml.kernel.org/r/20250213214533.2242224-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-remove-reference-to-bh-b_page
+++ a/fs/ocfs2/quota_global.c
@@ -273,7 +273,7 @@ ssize_t ocfs2_quota_write(struct super_b
 	if (new)
 		memset(bh->b_data, 0, sb->s_blocksize);
 	memcpy(bh->b_data + offset, data, len);
-	flush_dcache_page(bh->b_page);
+	flush_dcache_folio(bh->b_folio);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	ocfs2_set_buffer_uptodate(INODE_CACHE(gqinode), bh);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

