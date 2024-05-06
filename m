Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF4E2207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957058; cv=none; b=TNxsM1p4pWXPgayTBeNBXzOLdkbX5MHUrQ3GXtzCNrgYx5Zc+GBOuyDusE8rEmcbV/yz61KKJn0R+H5bT3Bh5Qq/F+KYjEG8xr0qxoEF/onA/meNUNUAwvK5/rDa0Hlpu5Ul7pLBL30jgdkC/B1d5pMjiBE3Q50fE+KE3SThfpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957058; c=relaxed/simple;
	bh=7TjLkVpCVr5nSD4e8VCdCVOYtEAKGwoV3zFLSiWOBaQ=;
	h=Date:To:From:Subject:Message-Id; b=kcc6lojQ/HFHckK9RnEzfk5n/c5Qbj6C/ei8KmHmYZHTR2NxOMAgh1P0U00ftZ8QQRGpM2nNnZaKNG+5RPILyr3Z2ZmB0AnYisnTiCIdY04KfOXQmkbxgDiolHrLqxfnRFG8b9M2ZVWT8uAb2ia/DSzlr1d9fnW5c/KjbfC1QpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dhdnriAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dhdnriAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A511C116B1;
	Mon,  6 May 2024 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957058;
	bh=7TjLkVpCVr5nSD4e8VCdCVOYtEAKGwoV3zFLSiWOBaQ=;
	h=Date:To:From:Subject:From;
	b=dhdnriAkJrU9jcG+Oo6t8E+EUHAg0rBLLr3JEyNjeKNsksbEYx76JERauFj4k+rZA
	 oz03LqIEJs+Eo9JSmqgbO01wM/hOWFbRL/Vj0WtihpF4XO8M0QOuNP2/ci7LtWmt/D
	 z6GbMle5wPhMdT3O4cQPrmW9ln18yF+EejEK843g=
Date: Sun, 05 May 2024 17:57:37 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-add-kernel-doc-for-try_to_free_buffers.patch removed from -mm tree
Message-Id: <20240506005738.0A511C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: add kernel-doc for try_to_free_buffers()
has been removed from the -mm tree.  Its filename was
     buffer-add-kernel-doc-for-try_to_free_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add kernel-doc for try_to_free_buffers()
Date: Tue, 16 Apr 2024 04:17:47 +0100

The documentation for this function has become separated from it over
time; move it to the right place and turn it into kernel-doc.  Mild
editing of the content to make it more about what the function does, and
less about how it does it.

Link: https://lkml.kernel.org/r/20240416031754.4076917-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-try_to_free_buffers
+++ a/fs/buffer.c
@@ -2868,26 +2868,6 @@ int sync_dirty_buffer(struct buffer_head
 }
 EXPORT_SYMBOL(sync_dirty_buffer);
 
-/*
- * try_to_free_buffers() checks if all the buffers on this particular folio
- * are unused, and releases them if so.
- *
- * Exclusion against try_to_free_buffers may be obtained by either
- * locking the folio or by holding its mapping's i_private_lock.
- *
- * If the folio is dirty but all the buffers are clean then we need to
- * be sure to mark the folio clean as well.  This is because the folio
- * may be against a block device, and a later reattachment of buffers
- * to a dirty folio will set *all* buffers dirty.  Which would corrupt
- * filesystem data on the same device.
- *
- * The same applies to regular filesystem folios: if all the buffers are
- * clean then we set the folio clean and proceed.  To do that, we require
- * total exclusion from block_dirty_folio().  That is obtained with
- * i_private_lock.
- *
- * try_to_free_buffers() is non-blocking.
- */
 static inline int buffer_busy(struct buffer_head *bh)
 {
 	return atomic_read(&bh->b_count) |
@@ -2921,6 +2901,30 @@ failed:
 	return false;
 }
 
+/**
+ * try_to_free_buffers - Release buffers attached to this folio.
+ * @folio: The folio.
+ *
+ * If any buffers are in use (dirty, under writeback, elevated refcount),
+ * no buffers will be freed.
+ *
+ * If the folio is dirty but all the buffers are clean then we need to
+ * be sure to mark the folio clean as well.  This is because the folio
+ * may be against a block device, and a later reattachment of buffers
+ * to a dirty folio will set *all* buffers dirty.  Which would corrupt
+ * filesystem data on the same device.
+ *
+ * The same applies to regular filesystem folios: if all the buffers are
+ * clean then we set the folio clean and proceed.  To do that, we require
+ * total exclusion from block_dirty_folio().  That is obtained with
+ * i_private_lock.
+ *
+ * Exclusion against try_to_free_buffers may be obtained by either
+ * locking the folio or by holding its mapping's i_private_lock.
+ *
+ * Context: Process context.  @folio must be locked.  Will not sleep.
+ * Return: true if all buffers attached to this folio were freed.
+ */
 bool try_to_free_buffers(struct folio *folio)
 {
 	struct address_space * const mapping = folio->mapping;
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

