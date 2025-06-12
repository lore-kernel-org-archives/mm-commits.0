Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4B192584
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769339; cv=none; b=bGxoZcd/SkbslIv4gPj+VNI9WLFmw+mhQVD8vGJ3NKjyFJtEP2Z6pEIRmHc2k7jkz7XYcmrFPNyqeDRZZN75V0RcmYRWCgxkCA3xXO6iudjPrye/doiOvcBZ766jLeJjVAjtjCAJ9cTzQ/u1MkNi1BLDWZzsGfhAtkNnj2hZOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769339; c=relaxed/simple;
	bh=pb8JwIw0zL8F3XewIFrtWpWXyH6lfsVc53V9nr7a07c=;
	h=Date:To:From:Subject:Message-Id; b=V1FLge/6H7BnL1vQpuQ41gPagU0cMzDYfqyPHTUk+UySSvs7E282tWwQBz+IsaW465Ho/7PpQKdhx6vjuPqHfQYD7IWxi1V0P7/ycUgWeiYdFzvI4VlkkTyZd6bWQHMGayRABEcjYCRgwOYNRHOpcfp4bwX9ZYSfSd37BS2FvlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xaKHT+Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xaKHT+Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F7CC4CEEA;
	Thu, 12 Jun 2025 23:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769338;
	bh=pb8JwIw0zL8F3XewIFrtWpWXyH6lfsVc53V9nr7a07c=;
	h=Date:To:From:Subject:From;
	b=xaKHT+BtuyqqxFR9LFtLiKF6uwEs9lg9a7581kb5lzrAkUKw+kTzXKqvNEEesvaob
	 T/PDKNeiECJo95vHajl+r392MAILvdMOPchJGlAJMTs/v4rhX2cuFHtQEnZ58LiI2+
	 Sfv8Php2nQmlS1w8QxYzZOmoU6oDoeGhWhpufP7k=
Date: Thu, 12 Jun 2025 16:02:18 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-zero_user.patch added to mm-new branch
Message-Id: <20250612230218.C6F7CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove zero_user()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-zero_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-zero_user.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove zero_user()
Date: Thu, 12 Jun 2025 15:34:41 +0100

All users have now been converted to either memzero_page() or
folio_zero_range().

Link: https://lkml.kernel.org/r/20250612143443.2848197-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/highmem.h~mm-remove-zero_user
+++ a/include/linux/highmem.h
@@ -292,12 +292,6 @@ static inline void zero_user_segment(str
 	zero_user_segments(page, start, end, 0, 0);
 }
 
-static inline void zero_user(struct page *page,
-	unsigned start, unsigned size)
-{
-	zero_user_segments(page, start, start + size, 0, 0);
-}
-
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

