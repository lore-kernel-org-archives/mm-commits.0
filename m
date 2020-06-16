From: akpm@linux-foundation.org
Subject: [merged]
 amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch removed from -mm
 tree
Date: Tue, 16 Jun 2020 10:28:29 -0700
Message-ID: <20200616172829.1bg7nzI9-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbgFPR2a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 13:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: amdgpu: a NULL ->mm does not mean a thread is a kthread
has been removed from the -mm tree.  Its filename was
     amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: amdgpu: a NULL ->mm does not mean a thread is a kthread

Use the proper API instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200404094101.672954-2-hch@lst.de
Fixes: 70539bd795002 ("drm/amd: Update MEC HQD loading code for KFD")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -196,7 +196,7 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_coun
 			pagefault_disable();				\
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
-			} else if (current->mm == NULL) {		\
+			} else if (current->flags & PF_KTHREAD) {	\
 				kthread_use_mm(mmptr);			\
 				valid = !get_user((dst), (wptr));	\
 				kthread_unuse_mm(mmptr);		\
_

Patches currently in -mm which might be from hch@lst.de are
