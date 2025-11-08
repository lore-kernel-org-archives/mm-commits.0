Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0E723EAA1
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626077; cv=none; b=AQr7guQk8KjmNKStSsFfzTeRXmNTB14Ttth2Pv2isc2mVAQEb3uBxLCgSPAywf4+YPgUYPQGB7gK5RDM8nmJ0lhE33QfeFZ2K4L/JK3EMLG5BIicTCqaf0Gs7TxVuSjetCcIDYANYvTIfJqt08Z2ZbF9/31TUGLRUltqN9GVulU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626077; c=relaxed/simple;
	bh=VbqXQXGk1Mges3GMdO+uB5Hggzkw6FS3+QTL1yza4Pc=;
	h=Date:To:From:Subject:Message-Id; b=XDIMffrEvQ9xELTjC9KrX2fplQzYNWICnr6E52YMQ3wlGvfYMj9FPJvIH+Wa8+0RqPfT1ZF+FW+CLCgsABrqbQ8suUt9Q3jaBgYL9g2TwZ64f1QVbDnXD+FbgbxOeJhz30MmBd4zk4VjiQy4eUOXEvD2Ebvm9FpByEyDxs4I5KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3/m7B6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3/m7B6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B5C4CEF5;
	Sat,  8 Nov 2025 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762626077;
	bh=VbqXQXGk1Mges3GMdO+uB5Hggzkw6FS3+QTL1yza4Pc=;
	h=Date:To:From:Subject:From;
	b=j3/m7B6tP6HANuptmrBFlKFuDRi2lvHaZBDZIc+p9zqmj1ZCg5csP4H55kqp8kuDf
	 bKcDWdbFRQR+mjIpS6qYiEc/0bTbwER4FeXvd8lpCPmmWjuyg6ho+F2Mnk/f0JFXWP
	 cox4perb2hGIPMpq1KrdsBFH5cFoXMx3EBt5c9Zs=
Date: Sat, 08 Nov 2025 10:21:16 -0800
To: mm-commits@vger.kernel.org,mpenttil@redhat.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,make24@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch added to mm-new branch
Message-Id: <20251108182116.EE0B5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm/test: fix error handling in dmirror_device_init
has been added to the -mm mm-new branch.  Its filename is
     mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch

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

mm-hmm-test-fix-error-handling-in-dmirror_device_init.patch

