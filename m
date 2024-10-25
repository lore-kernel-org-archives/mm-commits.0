Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E0198856
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885076; cv=none; b=AgxuaHuIRlsRMbG+RvUA51EiZQR5yU3MH5g+ea2Lp2gAJAqqTS9f6ZZg7ZatT32tX8+iL36E5RD7m0M3+xsYR0EXeXOcr0ZPvtvpshGh3Vv8/D5BTWRxPnZ0MlboXzn196ksXf8WEOS/zi9GhuBNzyrXzDGxbpuL39yi7arUFM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885076; c=relaxed/simple;
	bh=KmJ5QEA7YF/PMbef7VpUDwjt0yXvrel/x/sLzm5IqCE=;
	h=Date:To:From:Subject:Message-Id; b=X/i78uFfg4FcmP/AVTZrXAhsH428LCooENnAfK5N0PLo8qOn0SrS/9mrfvxgca9yXcjMjJ8fnPjtAqvZtS98dkO/5giUCReUGpy4PQRJoon9tyemzrv/9eVkS+IzK+xzc+qEVgf+L0rC1cAttaFGoyCZxtxTbPLE1uvXYpxteqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iA5Ld1E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iA5Ld1E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BCC4CEC3;
	Fri, 25 Oct 2024 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885076;
	bh=KmJ5QEA7YF/PMbef7VpUDwjt0yXvrel/x/sLzm5IqCE=;
	h=Date:To:From:Subject:From;
	b=iA5Ld1E86F8+1ecahM05y4UQYDhcBGu/usaIr3Mul722un69GM3UbZLjLbsLSHm+6
	 Rf9VKC4r1d4cBa2sSuzU3LA3uSRikc55tKlNSzpLKUOCgucTOXXMz/TiLiBLgd1LRk
	 K2EHLRpdykfUAjHQcdCSH0NsEouXQgNxa1ieiqkE=
Date: Fri, 25 Oct 2024 12:37:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-nilfs_palloc_block_get_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193755.E67BCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: remove nilfs_palloc_block_get_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-nilfs_palloc_block_get_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-nilfs_palloc_block_get_entry.patch

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
Subject: nilfs2: remove nilfs_palloc_block_get_entry()
Date: Thu, 24 Oct 2024 18:25:41 +0900

All calls to nilfs_palloc_block_get_entry() are now gone, so remove it.

Link: https://lkml.kernel.org/r/20241024092602.13395-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   19 -------------------
 fs/nilfs2/alloc.h |    2 --
 2 files changed, 21 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-remove-nilfs_palloc_block_get_entry
+++ a/fs/nilfs2/alloc.c
@@ -391,25 +391,6 @@ size_t nilfs_palloc_entry_offset(const s
 }
 
 /**
- * nilfs_palloc_block_get_entry - get kernel address of an entry
- * @inode: inode of metadata file using this allocator
- * @nr: serial number of the entry (e.g. inode number)
- * @bh: buffer head of the buffer storing the entry block
- * @kaddr: kernel address mapped for the page including the buffer
- */
-void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
-				   const struct buffer_head *bh, void *kaddr)
-{
-	unsigned long entry_offset, group_offset;
-
-	nilfs_palloc_group(inode, nr, &group_offset);
-	entry_offset = group_offset % NILFS_MDT(inode)->mi_entries_per_block;
-
-	return kaddr + bh_offset(bh) +
-		entry_offset * NILFS_MDT(inode)->mi_entry_size;
-}
-
-/**
  * nilfs_palloc_find_available_slot - find available slot in a group
  * @bitmap: bitmap of the group
  * @target: offset number of an entry in the group (start point)
--- a/fs/nilfs2/alloc.h~nilfs2-remove-nilfs_palloc_block_get_entry
+++ a/fs/nilfs2/alloc.h
@@ -31,8 +31,6 @@ nilfs_palloc_entries_per_group(const str
 int nilfs_palloc_init_blockgroup(struct inode *, unsigned int);
 int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
-void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
-				   const struct buffer_head *, void *);
 size_t nilfs_palloc_entry_offset(const struct inode *inode, __u64 nr,
 				 const struct buffer_head *bh);
 
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

