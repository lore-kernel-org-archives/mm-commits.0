Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841291A317D
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 17:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126331; cv=none; b=OSNK+gVxmBdZ5lTpMCjSunq3CJvCNyI7Si/iZgR+L/l6UbEFb1MRgsIlZJ+vpMMiR2JAMCxnm/zGObAOwHWaFB562DOUSlRmUDktW9AnFKy7D/A9StE0TpFnr/f6iX6B8Z4v13u5Y+Cs5fPTaApKP3Rj8BuQk4SnCHhmW8sJxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126331; c=relaxed/simple;
	bh=ZkpK6NUGHDMvUjYOOSxcq9h03CQZNd6vWjZCnWnVMuE=;
	h=Date:To:From:Subject:Message-Id; b=ZhMf+B3y9M4nx7nu7IdPa6HVT6Sms+vfuUb2aAUQIB2MGYExdgS3wOD8OjOY7zqotTkY4k5ve6z4j26tk4IPc2S0Vy05gS9UqhfYeJPxw6KmGf83Ae16aupaeUO2bhVSjHbix2+bPcP08D/pQdCSp2w1cvEt8dwRnfIFM+nYRkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MjPWsM9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MjPWsM9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F0EC116C6;
	Thu, 26 Feb 2026 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772126331;
	bh=ZkpK6NUGHDMvUjYOOSxcq9h03CQZNd6vWjZCnWnVMuE=;
	h=Date:To:From:Subject:From;
	b=MjPWsM9c0AYHY/jvHSqyKfK0WYJqZv8qrheIgWR8nBxagHFvw/f4VMm64T5OoV7Ht
	 hG6UFQNtomUXkKYeLLrkBeT+xh4pSgeslVoopn9jy4IRlafLTq43NWZAH8BddzoKdP
	 E4wLuaINjUkwyrW1cC1hYCqCj0NZDcTYO16wUowA=
Date: Thu, 26 Feb 2026 09:18:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,mst@redhat.com,mhocko@suse.com,longli@microsoft.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + virtio_balloon-set-pr_devorder-to-new-default.patch added to mm-new branch
Message-Id: <20260226171851.02F0EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: virtio_balloon: set pr_dev.order to new default
has been added to the -mm mm-new branch.  Its filename is
     virtio_balloon-set-pr_devorder-to-new-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virtio_balloon-set-pr_devorder-to-new-default.patch

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
Subject: virtio_balloon: set pr_dev.order to new default
Date: Wed, 25 Feb 2026 23:01:25 -0800

Drivers registering with page reporting used zero as a way to signal
page_reporting_order to be set as a default value (either passed as a
param or MAX_PAGE_ORDER).

Since page_reporting_order can now have zero as valid order, default
fallback value send by drivers to page reporting is now -1.

Link: https://lkml.kernel.org/r/20260226070125.3732265-4-yuvraj.sakshith@oss.qualcomm.com
Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-set-pr_devorder-to-new-default
+++ a/drivers/virtio/virtio_balloon.c
@@ -1023,6 +1023,20 @@ static int virtballoon_probe(struct virt
 		}
 
 		/*
+		 * page_reporting_register() takes the order either
+		 * from the driver or the commandline. If neither
+		 * are provided, it falls back to MAX_PAGE_ORDER.
+		 *
+		 * Order given by the driver is required to be in the
+		 * range [0, MAX_PAGE_ORDER].
+		 *
+		 * One way for the driver to not provide any order
+		 * is by setting it to -1.
+		 */
+
+		vb->pr_dev_info.order = -1;
+
+		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
 		 * size is used. The page reporting won't be triggered if the
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-allow-zero-page_reporting_order.patch
hv_balloon-change-default-page-reporting-order.patch
virtio_balloon-set-pr_devorder-to-new-default.patch

