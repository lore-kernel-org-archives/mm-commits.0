Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B134314D1E
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577288; cv=none; b=m2Z/iQDrfT9Y23DxEJdOfPRmcMk7a+knRA8z1cojSZuDiem91L3zrwno1dvHwR52mzO1VyzAFpOqmbPpPdZd9fpkeA/GwHwBVXCtiqig7UEm7fny0KOHxCRIaFyYAinV0zk1s9RwUGRs+9UdA9LrF1yKzQcCfa6qtL+PlYbvHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577288; c=relaxed/simple;
	bh=YvxEMgjM5e0V5EVRxgUJvy4EpGuyfg2DoAbQ9/ktLh8=;
	h=Date:To:From:Subject:Message-Id; b=c3KOMWxnYHYIvci+dTxU/AFk4wdhjU9QiAs/Oc+3zKK5kzitbYKZ+3UYPQSa5ecREMD6QjegtNDzkD+IgcxxsVjagWAsLywN+rAfwjCBaeY/ZWLVyyYpwtrZAHV6w2dijNVfF5GpOfn5/3A5SjEl04S24yRIi7ey6Gw6OZWCCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7mK+C4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7mK+C4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A6EC116C6;
	Tue,  3 Mar 2026 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577288;
	bh=YvxEMgjM5e0V5EVRxgUJvy4EpGuyfg2DoAbQ9/ktLh8=;
	h=Date:To:From:Subject:From;
	b=p7mK+C4wM4Ytw4wnKLeuYOz1dOmC2kYYZ8+raZ6ENos0I96Q1k8UPbLmhSfC/I72t
	 cNlkXjnOjH7+/70TK1rf88A67iKlLP6ZGXH2oKU4twfmLLyYYv6yqoj69L7q3v7Fmu
	 /rdNcDncpua4IETpgqEnlr94rZNGlpQVF7tT46Ww=
Date: Tue, 03 Mar 2026 14:34:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hv_balloon-set-unspecified-page-reporting-order.patch added to mm-new branch
Message-Id: <20260303223447.F3A6EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hv_balloon: set unspecified page reporting order
has been added to the -mm mm-new branch.  Its filename is
     hv_balloon-set-unspecified-page-reporting-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hv_balloon-set-unspecified-page-reporting-order.patch

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
Subject: hv_balloon: set unspecified page reporting order
Date: Tue, 3 Mar 2026 03:30:30 -0800

Explicitly mention page reporting order to be set to default value using
PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.

Link: https://lkml.kernel.org/r/20260303113032.3008371-4-yuvraj.sakshith@oss.qualcomm.com
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

 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-set-unspecified-page-reporting-order
+++ a/drivers/hv/hv_balloon.c
@@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
 	 * We let the page_reporting_order parameter decide the order
 	 * in the page_reporting code
 	 */
-	dm_device.pr_dev_info.order = 0;
+	dm_device.pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 	ret = page_reporting_register(&dm_device.pr_dev_info);
 	if (ret < 0) {
 		dm_device.pr_dev_info.report = NULL;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-add-page_reporting_order_unspecified.patch
virtio_balloon-set-unspecified-page-reporting-order.patch
hv_balloon-set-unspecified-page-reporting-order.patch
mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch
mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

