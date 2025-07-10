Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984532857E6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126290; cv=none; b=JckrdY4Z/ZglQTgbf5yD8RagcqNOKBwl8tNFe5t0JshTQLyC4dFyH7ASjEV4QgK4I07dbVnbZDpIP92tWXKT5Tujz/XDkNGAC5DTleMGjcFtPJT+zFCra4EUrl0bSfnObB9Cq1f6JxgD0/nhrnWFtWfbpJt/m0D7PvxqGCGNkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126290; c=relaxed/simple;
	bh=nHrp96+8ub2d8GBXaTfP5Lwv2hP0lHJCRbJB5Id769s=;
	h=Date:To:From:Subject:Message-Id; b=JwAU6vuLJ3R82J8sQMC/0UXJA/QiubdphD6XsRJnot9wwhq1YlEXSdPWGKOPoyC8jE3VYbgm5EzkBbxt0yhsUd9ZMNZnmtKdMq2bx96tV8+8+0Q4i5xi1hSh/mjU4d5BBjyrLrYn55oE7+64/kIznXfVVTqWxSaScQ5LEN8aPsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ezUXby9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezUXby9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD1AC4CEF4;
	Thu, 10 Jul 2025 05:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126290;
	bh=nHrp96+8ub2d8GBXaTfP5Lwv2hP0lHJCRbJB5Id769s=;
	h=Date:To:From:Subject:From;
	b=ezUXby9JPZXsQ/R2XqAuEIGPqDaLpQzVe0FFvzDRuixBI1pRysn4dzcNx5FmFCBno
	 4a4aki0ek6whAMbe4Ld2QUWii0aOrG29mbMCmrW68Ot2KtPwQhcZ+amvKkH5dZhZrU
	 o2Ccjw2cfoEDzJy1O+v99gjH0alrhI5wVH1agpDU=
Date: Wed, 09 Jul 2025 22:44:49 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,dan.carpenter@linaro.org,axboe@kernel.dk,amarkuze@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20250710054450.6DD1AC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ceph: convert ceph_zero_partial_page() to use a folio
has been removed from the -mm tree.  Its filename was
     ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ceph: convert ceph_zero_partial_page() to use a folio
Date: Thu, 12 Jun 2025 15:34:40 +0100

Retrieve a folio from the pagecache instead of a page and operate on it. 
Removes several hidden calls to compound_head() along with calls to
deprecated functions like wait_on_page_writeback() and find_lock_page().

[dan.carpenter@linaro.org: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()]
  Link: https://lkml.kernel.org/r/685c1424.050a0220.baa8.d6a1@mx.google.com
Link: https://lkml.kernel.org/r/20250612143443.2848197-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Markuze <amarkuze@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ceph/file.c~ceph-convert-ceph_zero_partial_page-to-use-a-folio
+++ a/fs/ceph/file.c
@@ -2530,19 +2530,19 @@ static loff_t ceph_llseek(struct file *f
 	return generic_file_llseek(file, offset, whence);
 }
 
-static inline void ceph_zero_partial_page(
-	struct inode *inode, loff_t offset, unsigned size)
+static inline void ceph_zero_partial_page(struct inode *inode,
+		loff_t offset, size_t size)
 {
-	struct page *page;
-	pgoff_t index = offset >> PAGE_SHIFT;
+	struct folio *folio;
 
-	page = find_lock_page(inode->i_mapping, index);
-	if (page) {
-		wait_on_page_writeback(page);
-		zero_user(page, offset & (PAGE_SIZE - 1), size);
-		unlock_page(page);
-		put_page(page);
-	}
+	folio = filemap_lock_folio(inode->i_mapping, offset >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		return;
+
+	folio_wait_writeback(folio);
+	folio_zero_range(folio, offset_in_folio(folio, offset), size);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 
 static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

