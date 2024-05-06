Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A873A1B6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957165; cv=none; b=NKz2pbt/ndWsUZ9+llky/wetxwU1ND7aESXRzR5+0jA9QmQp3xzXcoRvxYXnO9W+vrGovzY8YZ/uVLw9A2a/VyUgFDksZZqM8CORbtysSdlYpReiVwxjf8fJhsOrprNDkk9/pUXR7xM6QHPfgT8cf+geJiQKmE9rKUBHu/Vvh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957165; c=relaxed/simple;
	bh=YWpZZnO0YG3Bm/dJ+GfgmLiqDlcrIxSKYS8iD1DQZWA=;
	h=Date:To:From:Subject:Message-Id; b=mxp+KtfjPOjR6lKOmP0nzcBQtlu64WxdK67RNQzdwbM9ZjZaUwGIwfco3FfvYIVfNS47eljtX4xO2lXjxZlNu4ONQTOHf6BDJl6kPwEzUgUMQUshBVVjnoq8DcVE3XXaUggVkOUhQiZPJZc+BNGy7PJHObLvH/gXYOzEESRYqGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p3iKEHui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p3iKEHui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA6EC113CC;
	Mon,  6 May 2024 00:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957164;
	bh=YWpZZnO0YG3Bm/dJ+GfgmLiqDlcrIxSKYS8iD1DQZWA=;
	h=Date:To:From:Subject:From;
	b=p3iKEHuibpVczUmzkCwm8lAFpAzBFEUfWnSiR34qyv1qFtlLeIk/2mHQM7BjtuDSi
	 rUddjt5nJu1mTLJAC0dmhb6gr4ZXTlxAkfFcMQaSs7aPAFqeoSFQ54EDswk9RqpWRz
	 SoPnRxoYCrxTd0jANuvsGfUcRYu8ZdnNbkmVtcyY=
Date: Sun, 05 May 2024 17:59:24 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch removed from -mm tree
Message-Id: <20240506005924.CFA6EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/bus.c: use the right locking mode (read vs write) in size_show
has been removed from the -mm tree.  Its filename was
     dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: use the right locking mode (read vs write) in size_show
Date: Tue, 30 Apr 2024 11:44:26 -0600

In size_show(), the dax_dev_rwsem only needs a read lock, but was
acquiring a write lock.  Change it to down_read_interruptible() so it
doesn't unnecessarily hold a write lock.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-4-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show
+++ a/drivers/dax/bus.c
@@ -937,11 +937,11 @@ static ssize_t size_show(struct device *
 	unsigned long long size;
 	int rc;
 
-	rc = down_write_killable(&dax_dev_rwsem);
+	rc = down_read_interruptible(&dax_dev_rwsem);
 	if (rc)
 		return rc;
 	size = dev_dax_size(dev_dax);
-	up_write(&dax_dev_rwsem);
+	up_read(&dax_dev_rwsem);
 
 	return sysfs_emit(buf, "%llu\n", size);
 }
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


