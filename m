Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FE16DC3F
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740968; cv=none; b=jexIBh0Z/tih3QY6R6gCMK5lHYxOOOzaue4JVP7MFszPSe55aDrVAfTFDKm/ROEFUZZ8rk8UnFiA8yx2sAYtRNSFjIPBcIM6k3T+grnCMMK1Rlt7nH+M7qgrp5YIt9UVmABQ4xUEC9crq4yCawxF7WXcs7v5sdKJLfypEJycKwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740968; c=relaxed/simple;
	bh=SeZMVby3yV97U8AEZiuJL+OlsWT7UZoFs2YlGjHFfOk=;
	h=Date:To:From:Subject:Message-Id; b=XNn5LyaTXv86Y61f2juHgKIbwQkdGwhbks5/k67NF2It00a7qPOC4nGDwSmcomFDje2xDrZHSZ/ep3X0WOTIFRo96KLk0gb+Mq72ccIDxHVHgEsx6xuDk9vZ+D1e4iTCA2rvQvIruaOAU91KUzidi3aF9r5CvFAWyQScki77+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vzt7bf0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vzt7bf0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B28C3277B;
	Tue, 18 Jun 2024 20:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740968;
	bh=SeZMVby3yV97U8AEZiuJL+OlsWT7UZoFs2YlGjHFfOk=;
	h=Date:To:From:Subject:From;
	b=Vzt7bf0U1p/Q/rq40Aq4fFqpUGxI8l9yNJIXIRCa+lohvnimv+gDpnddR+2NpGPe+
	 moWGAfO8zosIkVm1TAfemzXvQTmlR3W+C4ca79DnsiM0ShrhJ78HErf+dIV+UA8aBu
	 xDvyV2U+kj4yByn1yqLhBB891jJE6lI1eFQfkwe8=
Date: Tue, 18 Jun 2024 13:02:47 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,v-songbaohua@oppo.com,trondmy@kernel.org,sfrench@samba.org,ryan.roberts@arm.com,jlayton@kernel.org,hanchuanhua@oppo.com,chrisl@kernel.org,anna@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] nfs-fix-nfs_swap_rw-for-large-folio-swap.patch removed from -mm tree
Message-Id: <20240618200248.43B28C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nfs: fix nfs_swap_rw for large-folio swap
has been removed from the -mm tree.  Its filename was
     nfs-fix-nfs_swap_rw-for-large-folio-swap.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nfs: fix nfs_swap_rw for large-folio swap
Date: Fri, 14 Jun 2024 12:03:25 +0200

The series "large folios swap-in: handle refault cases first" will permit
the MM to swap out larger than page size chunks.  NFS has all code ready
to handle this, but has a VM_BUG_ON that triggers when this happens. 
Simply remove the VM_BUG_ON to fix this use case.

Link: https://lkml.kernel.org/r/20240614100329.1203579-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/direct.c~nfs-fix-nfs_swap_rw-for-large-folio-swap
+++ a/fs/nfs/direct.c
@@ -141,8 +141,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 {
 	ssize_t ret;
 
-	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = nfs_file_direct_read(iocb, iter, true);
 	else
_

Patches currently in -mm which might be from hch@lst.de are

nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch

