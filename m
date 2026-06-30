Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6607E288AD;
	Tue, 30 Jun 2026 00:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778028; cv=none; b=t6Tg+Cu8Xeh8+1jQ9nTYKFhZNDJ8Hawg7/ScDzYeFAg3PLlQ9kaavq5zqRw3+Hwby2uGw0onq6kAvxIhf6qYoWFcqgzu3fl6zUVNqt0RdspU+ISiPOCYQovSYetp9D4qQhuqqHKrtqQbEYRtu2NrpX8SdgQJVKJ03NA0MCyu2s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778028; c=relaxed/simple;
	bh=48oVKqp++UwmWwYbOQj+zEgCOQDZdYF1TON13bpfwL4=;
	h=Date:To:From:Subject:Message-Id; b=qSZ599SjqXdtsbiyM/2cW/p4beL7ZFbjUuM6TqqNORAoQ7FH0ACCe/p5R8rGxzKTWU+TnXU4QAvmUPUZOG07d1cRxMAA1xpbYWN0INBR4nnSAdc/gM0B2S6akHKZrG3O9ZbtfWDtxsp5PlxwycuxUmB34n2MlP5O0UjQ3Nyl5jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=StLhMONR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="StLhMONR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088041F000E9;
	Tue, 30 Jun 2026 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778027;
	bh=ypL546/XRnjqYdyZKSkW5L04xouqnRJrLMHPXAQ1Nfw=;
	h=Date:To:From:Subject;
	b=StLhMONREzRcNqTWCCQBU1fb7SGoaXxbUguI1FG3CIMCnpNZIm+dl0usNUw4SB1F+
	 3yxSa4CsorbFAnsJA1e7mg6CD4OYmUPAu4vKrWQdr2PeZjycYGY98E0uQDz+1DaxM7
	 6wn/wL0DvpVbB8jCeUr7rUd8d1yjBM65m/JekOjY=
Date: Mon, 29 Jun 2026 17:07:06 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,apopple@nvidia.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch added to mm-hotfixes-unstable branch
Message-Id: <20260630000707.088041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_hmm: use device devt for coherent device range selection
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: lib: test_hmm: use device devt for coherent device range selection
Date: Mon, 29 Jun 2026 16:30:14 -0700

Commit af69016dab96 ("lib: test_hmm: implement a device release method")
moved the initial dmirror_allocate_chunk() call before cdev_device_add(). 
That means the struct cdev has not been added yet, so cdev_add() has not
initialized mdevice->cdevice.dev.

The coherent-device range selection uses the device minor to choose
between spm_addr_dev0 and spm_addr_dev1.  Reading
MINOR(mdevice->cdevice.dev) before cdev_add() therefore always sees an
uninitialized dev_t.  As a result, both coherent devices select the same
physical range, and adding the second device fails due to the overlapping
dev_pagemap range.

Use mdevice->device.devt instead.  It is initialized in
dmirror_device_init() before dmirror_allocate_chunk() is called and is the
same dev_t later passed to cdev_device_add().

Link: https://lore.kernel.org/178277581197.172200.16265155329935822153.stgit@skinsburskii
Fixes: af69016dab96 ("lib: test_hmm: implement a device release method")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-device-devt-for-coherent-device-range-selection
+++ a/lib/test_hmm.c
@@ -581,7 +581,7 @@ static int dmirror_allocate_chunk(struct
 		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
 		break;
 	case HMM_DMIRROR_MEMORY_DEVICE_COHERENT:
-		devmem->pagemap.range.start = (MINOR(mdevice->cdevice.dev) - 2) ?
+		devmem->pagemap.range.start = (MINOR(mdevice->device.devt) - 2) ?
 							spm_addr_dev0 :
 							spm_addr_dev1;
 		devmem->pagemap.range.end = devmem->pagemap.range.start +
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch

