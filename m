Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C92853E0
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126288; cv=none; b=F30z6TT7c5wGpaRiNyMLjhqoOkCAg1CLQUWOxmxpDj42Ey0cFeffb1/vxcYGcyOwPfLpOBoZtBUvQU3Fuikp2Er4RgglQgQJVzA50E44gFi/5rNvjabl589RaWWKkwndFHafSyV1cbWjcJIVrBrmn0vguxLfdbu1zuWoFy7vcn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126288; c=relaxed/simple;
	bh=zk8xMOd/MMqSz8B3hKnpN9jrQhg/fqatKuTFGYF/kwA=;
	h=Date:To:From:Subject:Message-Id; b=boJxVwvXBIlbOdPOPblr0iSYe4kgIq0xsqrMAQJs/ccJsnz2fW6En6HqHw1br7XBlNjy+EKl71bRqD1kntdI5yzsCW8GHw9pGL0bUhEasmd5m1TlZjjZDml52ilQ/i34ck8knuW4iF7KHihbpxdqNSiPaq7GW1XXLGsuwC2BLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o+MUluA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o+MUluA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A10C4CEE3;
	Thu, 10 Jul 2025 05:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126288;
	bh=zk8xMOd/MMqSz8B3hKnpN9jrQhg/fqatKuTFGYF/kwA=;
	h=Date:To:From:Subject:From;
	b=o+MUluA+svIi2zzNIeHdFX4preWSmn1TsOTQA1ANQPrAYc7mVHSZ6M5ey7mWPz/8u
	 vp6PodfSR+83HZCPDo2q+zvfzwT3zUAmLcUusOX3GOzJYxcEld08FjS5yNymQlpqpf
	 YgEd0G/qjGruWXE6zU3iERkuc3EbOk4/+rpEvKu4=
Date: Wed, 09 Jul 2025 22:44:47 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,dan.carpenter@linaro.org,axboe@kernel.dk,amarkuze@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] null_blk-use-memzero_page.patch removed from -mm tree
Message-Id: <20250710054448.16A10C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: null_blk: use memzero_page()
has been removed from the -mm tree.  Its filename was
     null_blk-use-memzero_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: null_blk: use memzero_page()
Date: Thu, 12 Jun 2025 15:34:38 +0100

memzero_page() is the new name for zero_user().

Link: https://lkml.kernel.org/r/20250612143443.2848197-3-willy@infradead.org
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

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

