Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40494368952
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126329; cv=none; b=lkUPpulqczl9H89H4qdpLXzX0MoORdEN85C0I5M57w0mhYQgOOHKQE9KxdXXQhclim1Zm27EVVPc5Tkpmn0veotGw94i2UbB2e419LD0rgRUopMzTKzMNsyZN8+t7+86aa4lpyu/eKH/lpt4wr6/DRKw9IWd8HzRRk4kL1vSwFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126329; c=relaxed/simple;
	bh=ta/zQ6dt9WrEijRkWf73/jEiEQffItsPFizXVcsleXo=;
	h=Date:To:From:Subject:Message-Id; b=XKB9p0jZZpSGuVh/v9r+rDS/6QxQ0EWACCeKnmaOGVRPgeJmRVj49XVLvZu5Ck22qGnwFGz0Bp1pWN9SF4JZA5GDheh8yw6uc1SdNvSeySQaWn56SWXD3ACMz+9PdO07kXnaV//prw93p/nBnZMchljDPOqC7csozPpvYHPO11A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOfzelHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOfzelHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB11BC116C6;
	Thu, 26 Feb 2026 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772126328;
	bh=ta/zQ6dt9WrEijRkWf73/jEiEQffItsPFizXVcsleXo=;
	h=Date:To:From:Subject:From;
	b=zOfzelHgeLpKr33PssJt13Qz8QAewI3wb9iynZizduNpXDUzcDswr3sIZmSPcN27e
	 x9fwUfWc7RP5dVFlvL20gvvmNoKlhxn2GmlnSFdXxRARdE9EkKrL4v/UlUhiwsOUG8
	 H1mxI8G5QPfbI9uN66y1+j/WQTVliDJqYUL4x0LY=
Date: Thu, 26 Feb 2026 09:18:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,mst@redhat.com,mhocko@suse.com,longli@microsoft.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hv_balloon-change-default-page-reporting-order.patch added to mm-new branch
Message-Id: <20260226171848.CB11BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hv_balloon: change default page reporting order
has been added to the -mm mm-new branch.  Its filename is
     hv_balloon-change-default-page-reporting-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hv_balloon-change-default-page-reporting-order.patch

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
Subject: hv_balloon: change default page reporting order
Date: Wed, 25 Feb 2026 23:01:24 -0800

page_reporting_order used to fall back to default value (passed as
parameter or MAX_PAGE_ORDER) if the driver wishes to not provide it.

The way the driver used to do this was by passing the order as zero.

Now that zero is a valid order that can be passed by a driver to page
reporting, we use -1 to signal default value to be used.

Link: https://lkml.kernel.org/r/20260226070125.3732265-3-yuvraj.sakshith@oss.qualcomm.com
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

 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-change-default-page-reporting-order
+++ a/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = -1;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-allow-zero-page_reporting_order.patch
hv_balloon-change-default-page-reporting-order.patch
virtio_balloon-set-pr_devorder-to-new-default.patch

