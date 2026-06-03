Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED684C0433;
	Wed,  3 Jun 2026 23:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780529187; cv=none; b=TnQlKDYexVVQrOUcey+1vf27H8SGTVq2hT+/0//AyRQbISZQ+TD1Z+EbYfTEr6BZzeeZzSjQA1xn1W7iaZMsgZv6rfRGkXFzdBE8sbo0JUCjzD0utofD4dN3uH3mjKllCVcWpNegGs/HKDJ/8NAbmn5I3e4KLUDyw2Vt3aZFiD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780529187; c=relaxed/simple;
	bh=O7H7zQc9ntX63UVNJqCr5GXsxTpYkFpbk7HG70sjQIQ=;
	h=Date:To:From:Subject:Message-Id; b=oh98wv5aAYkxhTa1fypKgddNUBECXKfMxrIslMiu+j+2/2pN/y27zb/jjMDdsj8385pBLTDNuGDzWbrHp9MWvSyDlCp5NXx6bxoto1awsoKz/Mpehvmdmp82pKLPnHJ/0IJaZg3OmWKfAniguwhH45L+X7z+ETfgLOW9kGmv48Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vr1KkSGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vr1KkSGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8262B1F00893;
	Wed,  3 Jun 2026 23:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780529186;
	bh=bl0sINzJsbrpBy6RKgwjbXVVCIJ/olIhsNM2rBEqoEk=;
	h=Date:To:From:Subject;
	b=vr1KkSGRIosKz1i4BIW7LhVaeELOzM8u20/nOJUA4BPCgaN/ha9hs1MBfYc5kRlJb
	 OfOdodjQj5zAoPJhmlW6zv5VXw/sSfup/PCN8+/LDInpRWmJvrzprDo0RUfe//pIft
	 O7iLCBNJ0NDrFt4sbQ+ZcWPDBT3qlc/zOq5HjySs=
Date: Wed, 03 Jun 2026 16:26:26 -0700
To: mm-commits@vger.kernel.org,xieyisheng1@huawei.com,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,hch@lst.de,axboe@kernel.dk,shenxiaogll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-fix-use-after-free-in-zram_bvec_write_partial.patch removed from -mm tree
Message-Id: <20260603232626.8262B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix use-after-free in zram_bvec_write_partial()
has been removed from the -mm tree.  Its filename was
     zram-fix-use-after-free-in-zram_bvec_write_partial.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cunlong Li <shenxiaogll@gmail.com>
Subject: zram: fix use-after-free in zram_bvec_write_partial()
Date: Thu, 28 May 2026 10:48:44 +0800

zram_read_page() picks the sync or async backing device read path based on
whether the parent bio is NULL.  zram_bvec_write_partial() passes its
parent bio down, so for ZRAM_WB slots the read is dispatched
asynchronously and zram_read_page() returns 0 while the bio is still in
flight.  The caller then runs memcpy_from_bvec(), zram_write_page() and
__free_page() on the buffer, leaving the async read to write into a freed
page.

zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
("zram: fix synchronous reads") for the same reason; the write_partial
counterpart was missed.

Link: https://lore.kernel.org/20260528-zram-v3-1-cab86eef8764@gmail.com
Fixes: 8e654f8fbff5 ("zram: read page from backing device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-use-after-free-in-zram_bvec_write_partial
+++ a/drivers/block/zram/zram_drv.c
@@ -2337,7 +2337,7 @@ static int zram_bvec_write_partial(struc
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);
_

Patches currently in -mm which might be from shenxiaogll@gmail.com are

zram-drop-unused-bio-parameter-from-write-helpers.patch

