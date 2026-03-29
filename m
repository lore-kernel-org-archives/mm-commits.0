Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015521256C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744786; cv=none; b=idiJj8SJZLMD1qwHXir7Y9gEPKT0UOUusXujXw3V7+1jrgeQHvYzZMclUbnDw90c3KFz2IsjV6gP8p4QX+SWPfXQ/1vj7ehQI5mNl3MzPwAwMoR5W0FKX0Uhu2Vh1tCN1xpekJV4R+Al1uaGj7JZIzOPBGVTw0CllkMmUsT1bgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744786; c=relaxed/simple;
	bh=b6AStHvA3PctJyg4hJ09dKmFAaZ8Y52J/rjijCoUWHk=;
	h=Date:To:From:Subject:Message-Id; b=MrsUsTrFcb1LIOf0L5EcSCpNjqKSF51e9KHdPYsxj6R0BaWEggP/8me4FjasEkk36d7de2Kl0EJqt0yp92xb4b5aUVvJnAIuvqx7xLS9xdDxaKgVe9zg/yu6FfeTHnROTWf4r9hp4LXgOCGYCW8lMEId5uARl/OzRuVX8Psz6G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYuQG2ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYuQG2ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FE2C4CEF7;
	Sun, 29 Mar 2026 00:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744786;
	bh=b6AStHvA3PctJyg4hJ09dKmFAaZ8Y52J/rjijCoUWHk=;
	h=Date:To:From:Subject:From;
	b=fYuQG2dsLqubzAdGIZBAYaHTAQUjIeIynDtVwl1Ss1VVXkbPJFkSuTdfvrJwypB8k
	 cBcVFXMBlBUCsdK9X3krFL0dE4SMFkYLFUCjE6uvHnA6Ws07TKm4dHOQvoVpgoiavm
	 OPITwFrfEijG4wTqlh47mM4wWMyxN5ukt+zAefx4=
Date: Sat, 28 Mar 2026 17:39:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-add-page_reporting_order_unspecified.patch removed from -mm tree
Message-Id: <20260329003946.46FE2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-add-page_reporting_order_unspecified.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Subject: mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue, 3 Mar 2026 03:30:28 -0800

Patch series "Allow order zero pages in page reporting", v4.

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

This patch changes the default fallback value from '0' to '-1' in all
possible clients of free page reporting (hv_balloon and virtio-balloon)
together with allowing '0' as a valid order in page_reporting_register().


This patch (of 5):

Drivers can pass order of pages to be reported while registering itself. 
Today, this is a magic number, 0.

Label this with PAGE_REPORTING_ORDER_UNSPECIFIED and check for it when the
driver is being registered.

This macro will be used in relevant drivers next.

[akpm@linux-foundation.org: tweak whitespace, per David]
Link: https://lkml.kernel.org/r/20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com
Link: https://lkml.kernel.org/r/20260303113032.3008371-2-yuvraj.sakshith@oss.qualcomm.com
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
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_reporting.h |    1 +
 mm/page_reporting.c            |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/page_reporting.h~mm-page_reporting-add-page_reporting_order_unspecified
+++ a/include/linux/page_reporting.h
@@ -7,6 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_order_unspecified
+++ a/mm/page_reporting.c
@@ -370,7 +370,8 @@ int page_reporting_register(struct page_
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
+		    prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are


