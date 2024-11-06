Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A97189F56
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855659; cv=none; b=cFcxoQHW611QIrFxH6lN3s9icB4DMDXvuhBdGbhDejj2UToy5xb3F0lwkeb/es4soLHLkjwqInGFUWqarhjfPNziLyf0s+LV8IelyIjBFVDx2X3RS37tOJbViOqZF+UwXTMqsEo8+6Ixtf5D/ob6eXd/jmHYAyOUtO2h2tb3BOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855659; c=relaxed/simple;
	bh=52O3arLU5E1OXLUqUWR3zFKZSLyx6TmN5HZUHS2/aws=;
	h=Date:To:From:Subject:Message-Id; b=J3r3BDjiCRuGXWmV7rCiHJB1hcCARc7EHk+QHAG3uOPCmSESnRRYDkYqlOxUxI3N++uzuJ5qkb2uOhzObrjPB6siR0HVweuCuTgzJb/DU/AMcg47zbOGcTKcitzNI/zUx//yPLP1hrsudUSEtiGnDiyb6irFYn4BoK0DiO7v7PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPp3aJFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPp3aJFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB228C4CECF;
	Wed,  6 Nov 2024 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855658;
	bh=52O3arLU5E1OXLUqUWR3zFKZSLyx6TmN5HZUHS2/aws=;
	h=Date:To:From:Subject:From;
	b=VPp3aJFZ/ae8zeqGbgp2zB7aY6siAcCoYI5YKIPy/0QhApRSitQTAFLIpZRJqFega
	 P8605lnZ8fyH9izv799IZBYzjXCVHvp0R3G7fBLKyVenRRM9cmkbdtG/PR0jkGq/ZW
	 8Qhuc6Hm73IKbZRNcyGMX/OId3Ex+HhPQb0g8KGo=
Date: Tue, 05 Nov 2024 17:14:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-inode-file-to-be-folio-based.patch removed from -mm tree
Message-Id: <20241106011418.CB228C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert inode file to be folio-based
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-inode-file-to-be-folio-based.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert inode file to be folio-based
Date: Thu, 24 Oct 2024 18:25:39 +0900

Convert the page-based implementation of ifile, a metadata file that
manages inodes, to folio-based.

Link: https://lkml.kernel.org/r/20241024092602.13395-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ifile.c |   10 +++++-----
 fs/nilfs2/ifile.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/ifile.c~nilfs2-convert-inode-file-to-be-folio-based
+++ a/fs/nilfs2/ifile.c
@@ -98,7 +98,7 @@ int nilfs_ifile_delete_inode(struct inod
 		.pr_entry_nr = ino, .pr_entry_bh = NULL
 	};
 	struct nilfs_inode *raw_inode;
-	void *kaddr;
+	size_t offset;
 	int ret;
 
 	ret = nilfs_palloc_prepare_free_entry(ifile, &req);
@@ -113,11 +113,11 @@ int nilfs_ifile_delete_inode(struct inod
 		return ret;
 	}
 
-	kaddr = kmap_local_page(req.pr_entry_bh->b_page);
-	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
-						 req.pr_entry_bh, kaddr);
+	offset = nilfs_palloc_entry_offset(ifile, req.pr_entry_nr,
+					   req.pr_entry_bh);
+	raw_inode = kmap_local_folio(req.pr_entry_bh->b_folio, offset);
 	raw_inode->i_flags = 0;
-	kunmap_local(kaddr);
+	kunmap_local(raw_inode);
 
 	mark_buffer_dirty(req.pr_entry_bh);
 	brelse(req.pr_entry_bh);
--- a/fs/nilfs2/ifile.h~nilfs2-convert-inode-file-to-be-folio-based
+++ a/fs/nilfs2/ifile.h
@@ -21,9 +21,9 @@
 static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
 {
-	void *kaddr = kmap_local_page(ibh->b_page);
+	size_t __offset_in_folio = nilfs_palloc_entry_offset(ifile, ino, ibh);
 
-	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
+	return kmap_local_folio(ibh->b_folio, __offset_in_folio);
 }
 
 static inline void nilfs_ifile_unmap_inode(struct nilfs_inode *raw_inode)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


