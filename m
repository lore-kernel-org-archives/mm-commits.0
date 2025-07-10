Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3642853EF
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126287; cv=none; b=CAg2TM+7zL7WAAf+5mTXYNYrCBKv9UxVp67s5qn2G4wd4x0qhybuAYSh8vDjOuYMfqB3JeHsaMpu672fEAwPr6BCM+UMrRjVceXKl1r5ltJjKkAqUh8iKmW6OpF2VJgfhQWQZhmG7dAK+M28YZ+jr4VKU0yukU3YOAbQhfAnghM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126287; c=relaxed/simple;
	bh=3Dn48ucoqkIgktmj/YcsLls4NEw7/QoIAQ4IiVLV02s=;
	h=Date:To:From:Subject:Message-Id; b=OAJtsQQZsb5EtCkhk7xQJrs/nU06C2n1OcnR/JboTRlbC8bvb5q3FpcwV9EUej+UGYj4PyxfyE8Ywybz3//2GbIeztrf2tv7+iUimZksWSog1MsXnMQnpeGfhWnF/viBlYSiixhFa+QM5R67ScJy/2ZsrQtYv2bUAxP/A1eBwI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E+oF59iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E+oF59iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E096EC4CEE3;
	Thu, 10 Jul 2025 05:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126287;
	bh=3Dn48ucoqkIgktmj/YcsLls4NEw7/QoIAQ4IiVLV02s=;
	h=Date:To:From:Subject:From;
	b=E+oF59iDDX3c0ytp5PeBgTMMl0zWu6v7RIIPF10Ou8AtT27dqMMCu6CFDa49Y/a2K
	 7kEQWD0jd13qhX9PzVpu+TFOpd4nLc6fpHzRd99unzY/VIfG7qLqlDVm3xkmKufMKp
	 mTPQUUhwvM6qhRa+5kNuOyisBQitUCYmfqY0g0mE=
Date: Wed, 09 Jul 2025 22:44:46 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,dan.carpenter@linaro.org,axboe@kernel.dk,amarkuze@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bio-use-memzero_page-in-bio_truncate.patch removed from -mm tree
Message-Id: <20250710054446.E096EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bio: use memzero_page() in bio_truncate()
has been removed from the -mm tree.  Its filename was
     bio-use-memzero_page-in-bio_truncate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
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

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

