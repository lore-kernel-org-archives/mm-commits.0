Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27434225771
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769336; cv=none; b=pfZw9WzWYIJXFEOIzIk27+TRAihJcKi4fEymL5veB54gvwRaJJXzGB6a87aZWdmBun1+TtL9BjmL6odRlYMR1H5qsXHJAa/E/N9KWXAAyOiwLWEsmpkFKQvB4HZ1+v+7lgYHYYNK9DCTKXDmu513Z+sC5SBXjXRwde4rxhOtOMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769336; c=relaxed/simple;
	bh=mxhL/GiGBOKIqBDLNEogCKRZgn0HNJQRQHYwEl+mgdo=;
	h=Date:To:From:Subject:Message-Id; b=TJiQl6V39Pn+9kOYrNGQox+hA13fHqqLNh9ouDEEohswZUrQ8onltTjC6XlvcUeUZMWZSoPNFy95VkkTGuMXTGd22ibd+Lra//UraT1P8iIDfqpB8SAaHJvKqpwC/7h1j7eJLXuMEl69LrWuzpu6phx2TGDfuLusGHlBzwskWqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PME7219j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PME7219j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E57C4CEEA;
	Thu, 12 Jun 2025 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769336;
	bh=mxhL/GiGBOKIqBDLNEogCKRZgn0HNJQRQHYwEl+mgdo=;
	h=Date:To:From:Subject:From;
	b=PME7219jG4pA2Qk3xje6/bj0m2E70W42vs8AoTifE5dFYt8Vmu8bmDJgHNj5fSGbi
	 KYqa+i51oCSM55oo9ot0WRjYFFKfitPIW28iADIPCeS4O8ofQyZ/KtM8kWZalAMrBg
	 J/tuh8uLaSRvtQ9+clE7pljumNkN/aHMtSqpj/uk=
Date: Thu, 12 Jun 2025 16:02:15 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + direct-io-use-memzero_page.patch added to mm-new branch
Message-Id: <20250612230215.E8E57C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: direct-io: use memzero_page()
has been added to the -mm mm-new branch.  Its filename is
     direct-io-use-memzero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/direct-io-use-memzero_page.patch

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
Subject: direct-io: use memzero_page()
Date: Thu, 12 Jun 2025 15:34:39 +0100

memzero_page() is the new name for zero_user().

Link: https://lkml.kernel.org/r/20250612143443.2848197-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/direct-io.c~direct-io-use-memzero_page
+++ a/fs/direct-io.c
@@ -996,7 +996,7 @@ do_holes:
 					dio_unpin_page(dio, page);
 					goto out;
 				}
-				zero_user(page, from, 1 << blkbits);
+				memzero_page(page, from, 1 << blkbits);
 				sdio->block_in_file++;
 				from += 1 << blkbits;
 				dio->result += 1 << blkbits;
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

