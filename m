Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F38284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126289; cv=none; b=EtDgHlkAPLw9HyuC2S4PScNYjtN3teZdMs6iplqLzed9el8SaE0R2OYisdSwJlJnYAjX/6w4aTe2SoAUPDCEDNdRYDaTBeTwn5g3daTWVHmRVFFOPAX/D0hzeGRKmN30G3otJ6fZmGVmVw9AoFAXJjPK5XYw5FYa5Uy9CwczSK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126289; c=relaxed/simple;
	bh=iKM/njCGkMFotBBeHyNb0hXKMso8zyDxypXbviiksw8=;
	h=Date:To:From:Subject:Message-Id; b=joZvZmvx0WhigfRC0SUaE6y+x5Efm/uHZ44aNC5Qvop6bUxDjSPwREPV/uhakLPf8tuLxtKN6vq8DDAg3NeRekbbLWPGvVshJac/IxO2HWQhbW9tA3zll6FFgndvaoarCpsL42VjODBNd2H+mB1p/w5j+p3w4PAld8T9U3OTqNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3Zhy3CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3Zhy3CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2AC4CEE3;
	Thu, 10 Jul 2025 05:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126289;
	bh=iKM/njCGkMFotBBeHyNb0hXKMso8zyDxypXbviiksw8=;
	h=Date:To:From:Subject:From;
	b=O3Zhy3CBZDpO7wc/a3lPjH9UkQtMwHl4vHLOFPQQGQ3wpW6C+GBDRq6gU3YqjLFAo
	 w2OaaJmvO9f+MY6ELU80KDa5gKhmx2ClB+rG9GRt48Qbl6FsLopKoQLipnuAaL+ad7
	 BJmNnlx7dq93L9xA+3037s9YJ3A4w0m0MDmm4Bag=
Date: Wed, 09 Jul 2025 22:44:48 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,dan.carpenter@linaro.org,axboe@kernel.dk,amarkuze@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] direct-io-use-memzero_page.patch removed from -mm tree
Message-Id: <20250710054449.3FD2AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: direct-io: use memzero_page()
has been removed from the -mm tree.  Its filename was
     direct-io-use-memzero_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: direct-io: use memzero_page()
Date: Thu, 12 Jun 2025 15:34:39 +0100

memzero_page() is the new name for zero_user().

Link: https://lkml.kernel.org/r/20250612143443.2848197-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
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

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

