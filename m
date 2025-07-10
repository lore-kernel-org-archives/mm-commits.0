Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FD469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122430; cv=none; b=oKJ/fuOBv85pbZo05le35rM5FkBOErPilhAFj+L2BUzXnNmCiQ2sR0xoZtpxLa+Nx1j/NqoTnN7E8pfOgnQRSI5nPwSdlJOebddIFKdgCJH71JmJhQ9PdI8V8PWVqibegytzXBDNy14RzwsLdQXAtoma8xJqQJ3vrv9g4eOzVQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122430; c=relaxed/simple;
	bh=biUReNVZlGkMWVNLFjBvS0MljIHLG8u6Qj67y5JqL70=;
	h=Date:To:From:Subject:Message-Id; b=iQ86YRVKnIRVuZNKH+keu7DMyaGJTMNrmB0hzx6Gae9JNiGcqPySVVklB/OauZn49KSasvhcTN6vMoOJxlfFAJcRIIJ9dcDTAONxExS1ae4H6aNyiCPiAaKCsdddL5IytbcPZLzYTr6USmGbjzCKpBhwPyrnoVykaaMXnMtvbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fy4RJs4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fy4RJs4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D022AC4CEE3;
	Thu, 10 Jul 2025 04:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122429;
	bh=biUReNVZlGkMWVNLFjBvS0MljIHLG8u6Qj67y5JqL70=;
	h=Date:To:From:Subject:From;
	b=Fy4RJs4slsh0o1USWBokehmc7xDyC5cIvt3iC/OxyfQe9AJD0L9S2GeoA3QdJ+Abt
	 JfZgn6CcagT7FveWW7a9g0bAn/TauKnWtb3sIfNmnLgpB7As3gnm4NODYdKPectwGH
	 igYyR6+9sYjoTuhAVFX53q+mcIAjrd0uC6lQejuU=
Date: Wed, 09 Jul 2025 21:40:29 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,willy@infradead.org,Slava.Dubeyko@ibm.com,ira.weiny@intel.com,idryomov@gmail.com,hch@lst.de,axboe@kernel.dk,amarkuze@redhat.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch removed from -mm tree
Message-Id: <20250710044029.D022AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
has been removed from the -mm tree.  Its filename was
     ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix.patch

This patch was dropped because it was folded into ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
Date: Wed, 25 Jun 2025 10:22:11 -0500

The filemap_lock_folio() never returns NULL.  It returns error pointers.
Update the checking to match.

Link: https://lkml.kernel.org/r/685c1424.050a0220.baa8.d6a1@mx.google.com
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ceph/file.c~ceph-convert-ceph_zero_partial_page-to-use-a-folio-fix
+++ a/fs/ceph/file.c
@@ -2536,12 +2536,13 @@ static inline void ceph_zero_partial_pag
 	struct folio *folio;
 
 	folio = filemap_lock_folio(inode->i_mapping, offset >> PAGE_SHIFT);
-	if (folio) {
-		folio_wait_writeback(folio);
-		folio_zero_range(folio, offset_in_folio(folio, offset), size);
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (IS_ERR(folio))
+		return;
+
+	folio_wait_writeback(folio);
+	folio_zero_range(folio, offset_in_folio(folio, offset), size);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 
 static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mmmemory_hotplug-implement-numa-node-notifier-fix.patch

