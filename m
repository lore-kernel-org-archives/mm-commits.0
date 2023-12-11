Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E927493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e59tbXZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CF8C433C7;
	Mon, 11 Dec 2023 01:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257845;
	bh=eDvLDT6iiMhgHVUN0QAuYTDdpGPOxz8K4Vq6JODwvXE=;
	h=Date:To:From:Subject:From;
	b=e59tbXZm6Le5tPE2OMYM0d3cobyM8G0pzC+DjkudDmVj+KWIgD5lNVXLFcldwfTG7
	 qllTnQCPlqBXGnARHs9i59YUwrrvo4l6dwYsJzZkf/iuqE7unZuNekF+Kg41BfSBDh
	 rsgSC6E5WxTqcHGCFP50U9IASKiD7zVOXb7xTEoM=
Date: Sun, 10 Dec 2023 17:24:04 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-page_address-from-nilfs_add_link.patch removed from -mm tree
Message-Id: <20231211012405.50CF8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove page_address() from nilfs_add_link
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-page_address-from-nilfs_add_link.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove page_address() from nilfs_add_link
Date: Mon, 27 Nov 2023 23:30:23 +0900

In preparation for removing kmap from directory handling, use
offset_in_page() to calculate 'from'.  Matches ext2.

Link: https://lkml.kernel.org/r/20231127143036.2425-5-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-remove-page_address-from-nilfs_add_link
+++ a/fs/nilfs2/dir.c
@@ -493,7 +493,7 @@ int nilfs_add_link(struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	from = (char *)de - (char *)page_address(page);
+	from = offset_in_page(de);
 	to = from + rec_len;
 	err = nilfs_prepare_chunk(page, from, to);
 	if (err)
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

