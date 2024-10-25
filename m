Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEEF20EA30
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885073; cv=none; b=MdHI/r9X6UFMSmR+AZA2L3jkXLvrED73Gov5GGMh33qBJVdMzElGDzPoa3CdeBTDYaWvNLwHAZy3Uc8bNfZrcs+AYR1xOeQUUybAiNUsmRnx6+cRWsDvUc4HKlfvlRMo1ID728VJ3Pa3mKs8H93gj04LzqeYxBA82oqbXrjYIjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885073; c=relaxed/simple;
	bh=D5/x9TfiIp9D/HdpBiMAEwVKYMFT3behMFoGV8VfYGw=;
	h=Date:To:From:Subject:Message-Id; b=YUl1A94thiSTVov4cVwrVKTgNTvVKmiNa5D/w/icYlRurTRTc2fMjBd0fNMX/Zg8sGDjmez9taqb1A22giLs+eom1ATbKZaAUxE1OO1mceB81pfJ+o5Ck/wd5kRkppYRqzvWQqXT3pBErrXiZeHY9chDvGHZfW1tzqQ2TWp4Z8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmPgadnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmPgadnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFFAC4CEC3;
	Fri, 25 Oct 2024 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885073;
	bh=D5/x9TfiIp9D/HdpBiMAEwVKYMFT3behMFoGV8VfYGw=;
	h=Date:To:From:Subject:From;
	b=dmPgadnI83ZggALDoP6dDIyXA44DC4a+28pwUbjtbgqwsGoM1ytNJqGHrcYqVssyI
	 8phkaO5fLBOWsdJJu93GZ6H+KNWAd9X0zH4wCdxRnB9m0AltbAMVGM9nEqjwViISTQ
	 JewX9i8xdPxfX6iLU5ljac1f5IozPjtsTYAAbKRo=
Date: Fri, 25 Oct 2024 12:37:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-inode-file-to-be-folio-based.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193753.2CFFAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert inode file to be folio-based
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-inode-file-to-be-folio-based.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-inode-file-to-be-folio-based.patch

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

nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch
nilfs2-convert-segment-buffer-to-be-folio-based.patch
nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch
nilfs2-convert-segment-usage-file-to-be-folio-based.patch
nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch
nilfs2-convert-inode-file-to-be-folio-based.patch
nilfs2-convert-dat-file-to-be-folio-based.patch
nilfs2-remove-nilfs_palloc_block_get_entry.patch
nilfs2-convert-checkpoint-file-to-be-folio-based.patch

