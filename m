Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED352192584
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769334; cv=none; b=WE4vi/KvELKajOTIUWenteio9ZwF1od+GOyDzGiUnEO+DSVHVmz+ziv/1IsRjPHUVY8skMSJirtizxLHz7+tQRKBbm7QLqVXwEdTBvdxJeGC/SZ+L6XhfmmHrnqFBD1ocOE9MuVGjWO/W/9zYYDhw6TUeF7Dsvh+2457SojHO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769334; c=relaxed/simple;
	bh=ATFNF9Kx5Irx4zBccFBljyoI2faUPlM2DHtlCcWezKs=;
	h=Date:To:From:Subject:Message-Id; b=jSmU6wygQcTpzvzJVud8LqtuTc3gKaoPE2S7NoqSdSBNvAdAYhhlWsq05grz0BFLxsd93R9LIpkOmMTlEQ7tV+n8kMLfyPFDMsY5Iduo1X1NuVN8qfMg3JKLkm4MoQfWgm60NK3kgwa/qg0EKg18kDUz1B4S7YWohSTepkhnntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s684TA1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s684TA1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F724C4CEEA;
	Thu, 12 Jun 2025 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769333;
	bh=ATFNF9Kx5Irx4zBccFBljyoI2faUPlM2DHtlCcWezKs=;
	h=Date:To:From:Subject:From;
	b=s684TA1BPqLfhf/vOq088ToW9u59zwFvZhSa/N261LsVE7Uc9I0+zY5GMhQMyDHdB
	 bGnI/9LnJftdB8hyf9OJ2xdZKh6pBTlWLV9ZZ+njxEuCUTVCdhWp9nQLsl4cYPFCX9
	 2XFwCboo924qW4K2ocmyFLpAhYwc2jN0rkXuSaZ4=
Date: Thu, 12 Jun 2025 16:02:12 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bio-use-memzero_page-in-bio_truncate.patch added to mm-new branch
Message-Id: <20250612230213.6F724C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bio: use memzero_page() in bio_truncate()
has been added to the -mm mm-new branch.  Its filename is
     bio-use-memzero_page-in-bio_truncate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bio-use-memzero_page-in-bio_truncate.patch

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
Subject: bio: use memzero_page() in bio_truncate()
Date: Thu, 12 Jun 2025 15:34:37 +0100

Patch series "Remove zero_user()".

The zero_user() API is almost unused these days.  Finish the job of
removing it.


This patch (of 5):

memzero_page() is the new name for zero_user().

Link: https://lkml.kernel.org/r/20250612143443.2848197-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250612143443.2848197-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/bio.c~bio-use-memzero_page-in-bio_truncate
+++ a/block/bio.c
@@ -653,13 +653,13 @@ static void bio_truncate(struct bio *bio
 
 	bio_for_each_segment(bv, bio, iter) {
 		if (done + bv.bv_len > new_size) {
-			unsigned offset;
+			size_t offset;
 
 			if (!truncated)
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, bv.bv_offset + offset,
+			memzero_page(bv.bv_page, bv.bv_offset + offset,
 				  bv.bv_len - offset);
 			truncated = true;
 		}
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

