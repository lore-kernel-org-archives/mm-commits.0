Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3177F3537CC
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577286; cv=none; b=hDIeUfOx+VqPALbPYBcUg3Qnd4GHJ0/rGp7dZumvrvJPv56bhjPFGSE7WTZFV1gF/rEXds3DGyFdc1ZO9KEmCT3t3G5ZLlX0+wh9GVyxbawRA5djaZQCU4M1wRqXQM0lmLkvjvhL1cge/aAWmakAHwWP1K8An5eFycrl0/P5Nig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577286; c=relaxed/simple;
	bh=5DTgGXzfE4YYoCxtyHKVqauWO6aK7Tlh95o7l4q6BbA=;
	h=Date:To:From:Subject:Message-Id; b=biuwaaopWCJJPPwLUaprqd4KzkA5MOnjA8V48vcXglrM21bzbhQueZa91t1ojJ5/0Q5/+Cfc6zk+r246F+QIdqfzAsCh8zbL4eDLGLCilgLAGoYDn0MDlWqKq8hMFY8nBg6hKu/yP8grr9mobVG8UNbRDwx+9Ku5F2E2MtqKCLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zSrzywFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zSrzywFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F2AC116C6;
	Tue,  3 Mar 2026 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577285;
	bh=5DTgGXzfE4YYoCxtyHKVqauWO6aK7Tlh95o7l4q6BbA=;
	h=Date:To:From:Subject:From;
	b=zSrzywFDLTvJQ01u4sy/8T9i0s1+YIga7r5F3vFAAlu/1m2SCOl4uvAVeCuRW52ps
	 Rrpf3WtotaUKWdLW/vbChbQXzCnA/cj9GzUlDI0wt61nX2LRprzK0gD0MlsCy+aza9
	 x0FxJ+/8gLw+X5dikKuZvcm2nd1oLcaP7ryoTlT8=
Date: Tue, 03 Mar 2026 14:34:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + virtio_balloon-set-unspecified-page-reporting-order.patch added to mm-new branch
Message-Id: <20260303223445.B1F2AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: virtio_balloon: set unspecified page reporting order
has been added to the -mm mm-new branch.  Its filename is
     virtio_balloon-set-unspecified-page-reporting-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virtio_balloon-set-unspecified-page-reporting-order.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Subject: virtio_balloon: set unspecified page reporting order
Date: Tue, 3 Mar 2026 03:30:29 -0800

virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly as
vb->prdev.order is never initialised and is auto-set to zero.

Explicitly mention usage of default page order by making use of
PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.

Link: https://lkml.kernel.org/r/20260303113032.3008371-3-yuvraj.sakshith@oss.qualcomm.com
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-set-unspecified-page-reporting-order
+++ a/drivers/virtio/virtio_balloon.c
@@ -1022,6 +1022,8 @@ static int virtballoon_probe(struct virt
 			goto out_unregister_oom;
 		}
 
+		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-add-page_reporting_order_unspecified.patch
virtio_balloon-set-unspecified-page-reporting-order.patch
hv_balloon-set-unspecified-page-reporting-order.patch
mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch
mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

