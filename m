Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176542EE611
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577293; cv=none; b=kh0uGg3Akh1E5HpEMygJb8kYHuRbyQ8CDCOVkCLSV1OV9lBq/h5/yqkPkbn/5CPjpwKAVZvsr1sdEPIaS8fypxAyxJxvuURCZn6PTdZfb5p2EyhbnWSYmkY06PLZ+E994U8udMFJ+SEPi0cTYlP33Kz5v/mGhZNeK+5/bxTiA8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577293; c=relaxed/simple;
	bh=EN4SgYZT88/bLUsluObaATkXaFU9f+8TneD0+xJOHtk=;
	h=Date:To:From:Subject:Message-Id; b=AVjdXQC3WG3HNwjHtSoHWwZQjKP72VzQCvUyhinXQqO/m7SgwRyFqF5rafcB1VDllBDywkLl90YEZdC3syofiZwQJYni+jK0+dSWmjo3jXnyu7+UDTs870YpsyjJYNnuIj6gp2Y3SjAnMSqmpDJoQt9vxxs+EdrumGHBnMhC+PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cz0kxfuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cz0kxfuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF45C116C6;
	Tue,  3 Mar 2026 22:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577292;
	bh=EN4SgYZT88/bLUsluObaATkXaFU9f+8TneD0+xJOHtk=;
	h=Date:To:From:Subject:From;
	b=Cz0kxfuwRT8TGhM7X2VR2VFB3zYLomE8xXrFhr0zKXM4AnOjjDW42GVKz0vfpWgEU
	 36ldicj7zIOXtrkKe4w00fgYrKlVHrUD+DWGcHDF7A4yHW68sCNAlfyIrGqEKBRTnd
	 im2DF+0Rit7ZYJl7dOpmeVS5ncyU0CPeZ8O3AeYs=
Date: Tue, 03 Mar 2026 14:34:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch added to mm-new branch
Message-Id: <20260303223452.9AF45C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDER_UNSPECIFIED
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

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
Subject: mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDER_UNSPECIFIED
Date: Tue, 3 Mar 2026 03:30:32 -0800

page_reporting_order when uninitialised, holds a magic number -1.

Since we now maintain PAGE_REPORTING_ORDER_UNSPECIFIED as -1, which is
also a flag, set page_reporting_order to this flag.

Link: https://lkml.kernel.org/r/20260303113032.3008371-6-yuvraj.sakshith@oss.qualcomm.com
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

 mm/page_reporting.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_reporting.c~mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified
+++ a/mm/page_reporting.c
@@ -13,7 +13,7 @@
 #include "internal.h"
 
 /* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
@@ -370,7 +370,7 @@ int page_reporting_register(struct page_
 	 * pageblock_order.
 	 */
 
-	if (page_reporting_order == -1) {
+	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
 		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
 		    prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-add-page_reporting_order_unspecified.patch
virtio_balloon-set-unspecified-page-reporting-order.patch
hv_balloon-set-unspecified-page-reporting-order.patch
mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch
mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

