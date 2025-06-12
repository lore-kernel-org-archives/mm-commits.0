Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A032225771
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769335; cv=none; b=f7qE7JhCxtbdGpkUB/+nZ5m7devTdbUOgY1u+IHT4+gGK2WggfEXUWn4XeZQ6MQYSUN4S6nQvyrQuOic6lkEmsMfLFUX2jWBWAup1C49V0GyLPmSX+cNAMVrCw5MCpgFbQhW0MXdVJJQQ1CjMIVIT1HGBd1oaZiHwTzeg+kYrPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769335; c=relaxed/simple;
	bh=Pr/tGyH2GbdYJdxJTiBiouJ0BhvkLbH/rj2EfhEjrX4=;
	h=Date:To:From:Subject:Message-Id; b=b2cpBhsYOADbe3Lh6s8Uj7+hYEArqdujHuG8o2ODr5IMftHkRaUZYjLPtBuEU688pGQhMPtCAdv+K1vkHMHAdadmp2r7jIS7iDg/WSyW8o6PIN9h96q0ugDTaT1grPrgE6VX3nd1EMELbOgfjg60A1uTC2bvofVT4RaFH9lukuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPl3Rq7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPl3Rq7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA9EC4CEEA;
	Thu, 12 Jun 2025 23:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769334;
	bh=Pr/tGyH2GbdYJdxJTiBiouJ0BhvkLbH/rj2EfhEjrX4=;
	h=Date:To:From:Subject:From;
	b=CPl3Rq7Yy0Lm9Syk716Il2ZXMTT6ENj/Oz6qmlX8mLIhkTtv8hXvqsmH0w7mARPmP
	 Rjq8DukCyjvUPiTNbmsFcQljS13gqwMW5h7Cq6vDO5rteEhzS3/mH5zgbDMv5j+ND5
	 Vs/wH++Q62SRuzZb0b8kjOGhuWwKYK4qRMDjk0bQ=
Date: Thu, 12 Jun 2025 16:02:14 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + null_blk-use-memzero_page.patch added to mm-new branch
Message-Id: <20250612230214.AFA9EC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: null_blk: use memzero_page()
has been added to the -mm mm-new branch.  Its filename is
     null_blk-use-memzero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/null_blk-use-memzero_page.patch

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
Subject: null_blk: use memzero_page()
Date: Thu, 12 Jun 2025 15:34:38 +0100

memzero_page() is the new name for zero_user().

Link: https://lkml.kernel.org/r/20250612143443.2848197-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/null_blk/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/null_blk/main.c~null_blk-use-memzero_page
+++ a/drivers/block/null_blk/main.c
@@ -1179,7 +1179,7 @@ static int copy_from_nullb(struct nullb
 			memcpy_page(dest, off + count, t_page->page, offset,
 				    temp);
 		else
-			zero_user(dest, off + count, temp);
+			memzero_page(dest, off + count, temp);
 
 		count += temp;
 		sector += temp >> SECTOR_SHIFT;
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

