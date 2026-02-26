Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22715368952
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126327; cv=none; b=lFxs+1b990v1rvHQDaDXU916Al/TtUm1DStl4CQ2biZvf5KHnc6DyyasUM/jQJa21KozzBsUO3eFZPNlZklX0qzuaD9wFksnmXDcYUMXKDPzEBY+/qTRB69LvNOWglYCF3jNIb+GAwjqWlyzg9jszpTIYmyy4b8EcFfFN7Vlf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126327; c=relaxed/simple;
	bh=wCJnk1YaquKDJzRFpuEprsWkuiU+Hog6qx5jnO/MpfU=;
	h=Date:To:From:Subject:Message-Id; b=MWQGtc1V6IUOZ93nP0LOVAixYxJOI3BWOZfSHxuKjYpXSJ2xU7JCh4V5Ejc2AtGj6HsL38+pGI+qTmj/d5QVKDD9muvfTP1gHR0OvqBjqs1FPaXBbF90HBmCinwT9zV6k35tP77at0TO/W1WZYY/N806dt8CrZZtDZuMpepQDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AesKyMjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AesKyMjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D2C116C6;
	Thu, 26 Feb 2026 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772126326;
	bh=wCJnk1YaquKDJzRFpuEprsWkuiU+Hog6qx5jnO/MpfU=;
	h=Date:To:From:Subject:From;
	b=AesKyMjWHtLHJfbm1BWayvwl5K9PTYp8ol9IQQxyhpComS0XBqs7uqEHzRqtMMUVk
	 61HsiZtcFkckJVSmWCM1BSD+HLqVZGkPfC6eJgOvFRw5tvDeS2Kz8AsAx4bWAU9a6R
	 Ldn+RyeGgB9qGNPPdoLg1nDueqoFbqaFfmPexbtA=
Date: Thu, 26 Feb 2026 09:18:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,mst@redhat.com,mhocko@suse.com,longli@microsoft.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-allow-zero-page_reporting_order.patch added to mm-new branch
Message-Id: <20260226171846.998D2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: allow zero page_reporting_order
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-allow-zero-page_reporting_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-allow-zero-page_reporting_order.patch

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
Subject: mm/page_reporting: allow zero page_reporting_order
Date: Wed, 25 Feb 2026 23:01:23 -0800

Patch series "Allow order zero pages in page reporting".

Today, page reporting sets page_reporting_order in two ways:

(1) page_reporting.page_reporting_order cmdline parameter
(2) Driver can pass order while registering itself.

In both cases, order zero is ignored by free page reporting because it is
used to set page_reporting_order to a default value, like MAX_PAGE_ORDER.

In some cases we might want page_reporting_order to be zero.

For instance, when virtio-balloon runs inside a guest with tiny memory
(say, 16MB), it might not be able to find a order 1 page (or in the worst
case order MAX_PAGE_ORDER page) after some uptime.  Page reporting should
be able to return order zero pages back for optimal memory relinquishment.

This patchset changes the default fallback value from '0' to '-1' in all
possible clients of free page reporting (hv_balloon and virtio-balloon)
together with allowing '0' as a valid order in page_reporting_register().


This patch (of 3):

Some drivers might require page sized chunks to be reported.  This patch
allows registering a driver with order as zero.

Example use case: virtio-balloon driver running on a guest with very small
memory.  After some time has passed, the guest might not be able to find a
chunk of 8KB.

Link: https://lkml.kernel.org/r/20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com
Link: https://lkml.kernel.org/r/20260226070125.3732265-2-yuvraj.sakshith@oss.qualcomm.com
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

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-allow-zero-page_reporting_order
+++ a/mm/page_reporting.c
@@ -370,7 +370,7 @@ int page_reporting_register(struct page_
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order >= 0 && prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-allow-zero-page_reporting_order.patch
hv_balloon-change-default-page-reporting-order.patch
virtio_balloon-set-pr_devorder-to-new-default.patch

