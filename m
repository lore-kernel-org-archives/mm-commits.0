Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA6E4334DE;
	Tue,  4 Aug 2026 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816374; cv=none; b=TdUc+FF12mEx+WTp+UrXe4oYft6BIZmlh/JqMRHUInfXipxiC/QwHc+vid3pWtGgAlOP+B4J0V8/RYN9QwpDqtxsUGgr6DcRjh9BnlCcgas0TrunHJ2TcNRs3Yi0YLZcjXSZerlfHk8xY9pwv8REfPKZmSsHGQUrCfBu4XrKJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816374; c=relaxed/simple;
	bh=Vn/2HKDO8dEFlTPcx0zq+KN4KSWHaYJYFftG+RUdymA=;
	h=Date:To:From:Subject:Message-Id; b=tCVtRoQNS4PgHVWGNcK7uHew39Vo7cQzveJnw5iqa5NzINueq8ql8xSqFET4A6iTD3HooEho/RkB/y8k7a4M1N3OngEMqiZ/T24hpthDYOOMDZ18DTygJw72nEGEeBIxCRdpUBCA7DPHtUTmdZbF7n4ztEAn5C1AH5pcUTDZVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQZI3x5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQZI3x5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429391F00A3A;
	Tue,  4 Aug 2026 04:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816373;
	bh=gIGQOt6TX9xKLGXBdCOpUBfbDd7Q4g5BbzikC3VmCfQ=;
	h=Date:To:From:Subject;
	b=UQZI3x5Yr6LiaTp1mYyWZLRv/3obPwjyDgnVvUxsF0Pe+/IZmgl4Kf0R/1NBcqfsL
	 J4M/O8qZElQ5towuITd5jo1+kCJFOsBficxUXsejrLiP+jhgoHTWnBucYQrODux/mb
	 rXNT6wFk74gMhvxhS58LBi+44P2jBRfTBp9a+zTI=
Date: Mon, 03 Aug 2026 21:06:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,error27@gmail.com,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch removed from -mm tree
Message-Id: <20260804040613.429391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: mport_cdev: fix use-after-free in dma_req_free()
has been removed from the -mm tree.  Its filename was
     rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Kim <james010kim@gmail.com>
Subject: rapidio: mport_cdev: fix use-after-free in dma_req_free()
Date: Fri, 24 Jul 2026 08:52:20 +0900

dma_req_free() acquires buf_mutex through req->map, drops the mapping
reference with kref_put(), and then dereferences req->map again to unlock
the mutex.

If kref_put() drops the last reference, mport_release_mapping() frees the
mapping, and the subsequent mutex_unlock() dereferences a freed object. 
This is a use-after-free.

Fix this by caching map and md before kref_put(), clearing req->map while
holding buf_mutex, and using the cached md for mutex unlocking.

The bug is reachable from userspace via the RapidIO mport character device
interface.

Link: https://lore.kernel.org/20260723235220.588424-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-mport_cdev-fix-use-after-free-in-dma_req_free
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -564,9 +564,13 @@ static void dma_req_free(struct kref *re
 	}
 
 	if (req->map) {
-		mutex_lock(&req->map->md->buf_mutex);
-		kref_put(&req->map->ref, mport_release_mapping);
-		mutex_unlock(&req->map->md->buf_mutex);
+		struct rio_mport_mapping *map = req->map;
+		struct mport_dev *md = map->md;
+
+		mutex_lock(&md->buf_mutex);
+		req->map = NULL;
+		kref_put(&map->ref, mport_release_mapping);
+		mutex_unlock(&md->buf_mutex);
 	}
 
 	kref_put(&priv->dma_ref, mport_release_dma);
_

Patches currently in -mm which might be from james010kim@gmail.com are


