Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3661314D1E
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577290; cv=none; b=RisINKaCkTisaEpu5+mTRFIQeDOQZp7GKY7i8mabWNxrvF9CmkhvoIpnm1a1kkOPmybzgD1LtfwpptufAlwSoFSTPJgl170VUSRewu4ZuSanuekyNJMpIWJoYIQwZ5A9wPHr41NlCk6RlGnjzievOvLKfAu6PeYUEFmNsKXdtIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577290; c=relaxed/simple;
	bh=tpdmie/vH29szTph0J94yh2Ka/bwFex3c3Rol/3HndM=;
	h=Date:To:From:Subject:Message-Id; b=VO/1BK0EQG4vazXJl9Ob7gFf0fF1vTDWNdkBxGgzBDmQJR3WuBNw/A5Zn4hHnA9T1RWgzq7Whne4DMSTkyznjACTaJoOXmUurOcTyY/CEDjbuDPlyGMABlczwhcL5+VZIL+KrS/1agI63VZXBt0CxW/T8fKTIuOvMB1jfo33PaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lblFHEDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lblFHEDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B059C116C6;
	Tue,  3 Mar 2026 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577290;
	bh=tpdmie/vH29szTph0J94yh2Ka/bwFex3c3Rol/3HndM=;
	h=Date:To:From:Subject:From;
	b=lblFHEDoTHG6H3lv2wGr2XZPjF6+19UC2vtY0MFUCcd9t1BRDiomFY1MOBN3LHYy3
	 L1IHOwJ8KjIa3Ai3chDBbwOXKwRQlfzxv6THNgWgGL7n/jPqRxJQgg+Z93CA28ybYl
	 vhpKLkKl25OLdYYRhnE9gW73qROtnXvbcXv/RkPw=
Date: Tue, 03 Mar 2026 14:34:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch added to mm-new branch
Message-Id: <20260303223450.4B059C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch

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
Subject: mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
Date: Tue, 3 Mar 2026 03:30:31 -0800

PAGE_REPORTING_ORDER_UNSPECIFIED is now set to zero.  This means, pages of
order zero cannot be reported to a client/driver -- as zero is used to
signal a fallback to MAX_PAGE_ORDER.

Change PAGE_REPORTING_ORDER_UNSPECIFIED to (-1), so that zero can be used
as a valid order with which pages can be reported.

Link: https://lkml.kernel.org/r/20260303113032.3008371-5-yuvraj.sakshith@oss.qualcomm.com
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

 include/linux/page_reporting.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page_reporting.h~mm-page_reporting-change-page_reporting_order_unspecified-to-1
+++ a/include/linux/page_reporting.h
@@ -7,7 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
-#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
+#define PAGE_REPORTING_ORDER_UNSPECIFIED	-1
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are

mm-page_reporting-add-page_reporting_order_unspecified.patch
virtio_balloon-set-unspecified-page-reporting-order.patch
hv_balloon-set-unspecified-page-reporting-order.patch
mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch
mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

