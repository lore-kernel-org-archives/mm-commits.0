Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE0B2FD1D5
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025807; cv=none; b=nLekVxdlyYl1M0V3bYd6r8Isdn4e1Nr++GJFxQOj4UtRBtQH3phqMxzRpHXY+u0CSlCuTKTiF0tiUSgSTx7OMwuaib7YUloGNV/XEJ0LBOfLBgqaKHrQQDAIY9eQl1sTHQanp4EwPMNt9YAW8ArYJE72k6EowPmcLAyg/M4aC60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025807; c=relaxed/simple;
	bh=NCJtjWZIM4ZRylZNromQt4YXBdaCX+JLZydJcmpQ+j8=;
	h=Date:To:From:Subject:Message-Id; b=UUHqDDmaPLygeMyBm7+/n4eAYoXGdbF3HynC55PRqWqg0QA1I5bHjohjblThYZrxIBYtcTsv/hUzm1RDdh33zp2wm6OrS3umLiIr0qfk8u3pPhav7CiIWZJbDPCYBa/rd07HbhmUPvXeKK7vA9jLjX+eRN1nJdyY3oecKHkB8tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3woWowa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3woWowa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E8DC4CEF1;
	Mon, 24 Nov 2025 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025807;
	bh=NCJtjWZIM4ZRylZNromQt4YXBdaCX+JLZydJcmpQ+j8=;
	h=Date:To:From:Subject:From;
	b=c3woWowatKL2wcvwWQDX+Uv4k9fB2ru6p+Q8UIISLB7w+1U3PIZI99dUdSfuk5VVv
	 2nofbtUNx/CEoiBhxmrnMM6/MMPkpFBO+Cb0x+zPY0d4UBkDo2oM9+WnEhuYO4WcTu
	 ACkf5Nyi1XtvuQkcVUt6Ab2HJRwc8/tWhoue1wvY=
Date: Mon, 24 Nov 2025 15:10:06 -0800
To: mm-commits@vger.kernel.org,mpenttil@redhat.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,make24@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch removed from -mm tree
Message-Id: <20251124231006.F1E8DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm/test: fix error handling in dmirror_device_init
has been removed from the -mm tree.  Its filename was
     mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Ke <make24@iscas.ac.cn>
Subject: mm/hmm/test: fix error handling in dmirror_device_init
Date: Sat, 8 Nov 2025 19:53:46 +0800

dmirror_device_init() calls device_initialize() which sets the device
reference count to 1, but fails to call put_device() when error occurs
after dev_set_name() or cdev_device_add() failures.  This results in
memory leaks of struct device objects.  Additionally,
dmirror_device_remove() lacks the final put_device() call to properly
release the device reference.

Found by code review.

Link: https://lkml.kernel.org/r/20251108115346.6368-1-make24@iscas.ac.cn
Fixes: 6a760f58c792 ("mm/hmm/test: use char dev with struct device to get device node")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Cc: Haoxiang Li <make24@iscas.ac.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~mm-hmm-test-fix-error-handling-in-dmirror_device_init
+++ a/lib/test_hmm.c
@@ -1740,20 +1740,25 @@ static int dmirror_device_init(struct dm
 
 	ret = dev_set_name(&mdevice->device, "hmm_dmirror%u", id);
 	if (ret)
-		return ret;
+		goto put_device;
 
 	ret = cdev_device_add(&mdevice->cdevice, &mdevice->device);
 	if (ret)
-		return ret;
+		goto put_device;
 
 	/* Build a list of free ZONE_DEVICE struct pages */
 	return dmirror_allocate_chunk(mdevice, NULL, false);
+
+put_device:
+	put_device(&mdevice->device);
+	return ret;
 }
 
 static void dmirror_device_remove(struct dmirror_device *mdevice)
 {
 	dmirror_device_remove_chunks(mdevice);
 	cdev_device_del(&mdevice->cdevice, &mdevice->device);
+	put_device(&mdevice->device);
 }
 
 static int __init hmm_dmirror_init(void)
_

Patches currently in -mm which might be from make24@iscas.ac.cn are


