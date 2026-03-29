Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0C420E023
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744790; cv=none; b=HmW/hagGvXy2Yy+OmxeJWsnEmsMaBXUkPBWOadvSg3lh9ysqXpT9uHH12Oni2YMnE+WVUzoSIJ83AV+hXfNmGRsD6NqE3AJFm+++/cF6xCiqcxqNU0dkS67tTPEJKRCs0x6C0rQM+43+IgJHAlEXB2eAKeYdu5LUMwOqAx9KoMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744790; c=relaxed/simple;
	bh=l5QzJPoa4CWo+qydNjuIyYAopdvYALEzhf8Djcwv/6M=;
	h=Date:To:From:Subject:Message-Id; b=JFWdGWA9/fk5QkFR1KsJCq02uHmPcD9pMGePcFKuw1k7WG0V9bPU4OSTn7TuRQ3YriRFxqNjHHLMLw2LvWXSTYBZc1qxyf2nrQarXW0UHbMT7vD7ixSC8QB+gVKnA4pns4MkffeYwbtR2QREPQgsRC6uD95XIMjWF5hfLTFLOSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEZ1OR4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEZ1OR4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72304C4CEF7;
	Sun, 29 Mar 2026 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744790;
	bh=l5QzJPoa4CWo+qydNjuIyYAopdvYALEzhf8Djcwv/6M=;
	h=Date:To:From:Subject:From;
	b=QEZ1OR4BLOC1m9Axb6HEY+ZVveMNTXJdaMBEGFyKSSSHQ58kQcUD4VkkJx4tRuM+t
	 uHUqe092KVaFxjp4/Q2eW+NaWIcpkQalsyRSf+llfHih9HWPhLb730y+D1fR75JnMf
	 DIG/Og73UKqafURKZZmRFhD44oH1qrlf4+9/kfBc=
Date: Sat, 28 Mar 2026 17:39:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch removed from -mm tree
Message-Id: <20260329003950.72304C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-change-page_reporting_order_unspecified-to-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


