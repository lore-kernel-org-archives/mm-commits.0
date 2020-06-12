From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/5] amdgpu: a NULL ->mm does not mean a thread is
 a kthread
Date: Thu, 11 Jun 2020 17:30:20 -0700
Message-ID: <20200612003020.TztYfgQuv%akpm@linux-foundation.org>
References: <20200611172827.bc85320ccf09b4c7e401d3f3@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgFLAaX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 20:30:23 -0400
In-Reply-To: <20200611172827.bc85320ccf09b4c7e401d3f3@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mst@redhat.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com

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
