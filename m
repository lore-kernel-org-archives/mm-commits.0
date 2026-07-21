Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848523D1AB3;
	Tue, 21 Jul 2026 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594610; cv=none; b=sXCRoPOr7eAOGFqMvneuOCbrq/HrNi3g03IF5Bh5c+w4ZpzeOkdbpBwDU/fPnN258B0wFAkrKrNK2/HIbDsxWavW07F2CP2IpZ1RCMIyeX/l7WXngJ0zA67XN96F8N1k2zCH/HGRf1JwAT8jEccf6RwqSegqcsQ4B7m7+eAct2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594610; c=relaxed/simple;
	bh=E9W9sQfxBKOGUyAjw9MDUHrCAYow/Y6+EQpPx1A2zT0=;
	h=Date:To:From:Subject:Message-Id; b=BO8O6HRMUHAZ7T2Hfe+1EBhalK8Q/Dsbikw3qzOnoqXUcT6X0ijGm1tHBR6b4L/5PPrxC5A9CMrzEIYViQJh1kBXcyK8DLHP0OAUJ0Yz0JOTrEa4+96mMJ0VhzOTN/LQk+VwPnVXQpdCORawH4ovpLCIQ4nlFj+awMNuZ314cLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eUnIZ8do; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eUnIZ8do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382601F00A3A;
	Tue, 21 Jul 2026 00:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594609;
	bh=HoGl31KKtXi7YHU2J7Z+hSGy2etUiKYNw1qoEqMnZDk=;
	h=Date:To:From:Subject;
	b=eUnIZ8do+jf5V/21Lj7A8x1lEjaciiZGHNm5F34erSRVSFuu8ZdEvuN74OUd12lBA
	 Vjg+J7/JvtlRTrZf7R9tZ1QaRs310tBaa14D7R0Ee5geVEmVuBjdNgudk02BqH7XLG
	 J5xBo4mAfMGnj8btQqhJa4F8M/IjSrT59WhJaE5I=
Date: Mon, 20 Jul 2026 17:43:28 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,apopple@nvidia.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch removed from -mm tree
Message-Id: <20260721004329.382601F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_hmm: use device devt for coherent device range selection
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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

mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch

