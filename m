Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5371B2EE611
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577281; cv=none; b=C/DS8kMuoaAMaL6xeALAjtYgHDgfyvx/p0//MVxXf58924pjztkeiFKV+Q6nR40n/GFTJdGt01+3mnJtrvnotcxz+8nmsa+8LmWhsYMsjGPeHsqhMrtZRB4nkQQUiZuBHY13HhGOjgE0NWZ0MPyVcGSF5hw6lhP2MIdz+grc9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577281; c=relaxed/simple;
	bh=EcuDgR1s1PB5bcheC9LQ+XHtdTDqhlyuX3/fB7KWsqY=;
	h=Date:To:From:Subject:Message-Id; b=EFhaRUqsX4z9qo3SJtVLUIxXlgylhSbat7st+LK0DjF1TnmjyDZwgJ7spOhpWxp96P7ncG+QZxB2yYXpShX4O+lc356wJAapnOIn4lnn1QuDk/9UMJ8H4eM9Fp0H4zhCzsGd8geSTT0lLV71Bf+w+9QOb1SZv/WIYOUaxWbGb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nM4cAeNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nM4cAeNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9F0C116C6;
	Tue,  3 Mar 2026 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577280;
	bh=EcuDgR1s1PB5bcheC9LQ+XHtdTDqhlyuX3/fB7KWsqY=;
	h=Date:To:From:Subject:From;
	b=nM4cAeNESUOYTW7dQ6zfdYtEmmzwjAxaccwHe0qYTC8hJMcyxTgNwWtgvCGKYi/DH
	 M9NAMY+KrSzINvnTa/Jm9NE2QqxGmTiyBR0P/XAgNvNFe9b60mr7cm77Z1tJlDdRs0
	 Tfxvdth0iAT3nH5noRUu8EVYX9urosbg1Le3mktc=
Date: Tue, 03 Mar 2026 14:34:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-add-page_reporting_order_unspecified.patch added to mm-new branch
Message-Id: <20260303223440.BD9F0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-add-page_reporting_order_unspecified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-add-page_reporting_order_unspecified.patch

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
@@ -371,7 +371,8 @@ int page_reporting_register(struct page_
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
+			prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-add-page_reporting_order_unspecified.patch
virtio_balloon-set-unspecified-page-reporting-order.patch
hv_balloon-set-unspecified-page-reporting-order.patch
mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch
mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

