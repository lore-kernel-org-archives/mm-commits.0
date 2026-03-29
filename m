Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B2A21256C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744789; cv=none; b=YCgAJEqUX1A0/D89vUqHJJIdlAxXo5z9OFd2l8XsvRCrtXwXG6bFO9xkPO3i7znieiSOshi+KSw8mZg/wO1MNocofQI/WzE2ZPK79tS7n1xLjNlSUZlu8floUxfeFG5DpMOHTgblwlffu5pUgUYXB9ntI7FBrNzgCO9PYBrKdog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744789; c=relaxed/simple;
	bh=RYBF6MuvY+9Pwm2d2SmJ7rVgxXFwRQzY6sw19M81dvg=;
	h=Date:To:From:Subject:Message-Id; b=o6+JCFQt5b0CB8ClX9ds3vfBWxoz93MagXpE8zm00129VkSUQhRM+2zdjGsxeKDjZhhcx85O22wbNBQQXBqMUFF+Akd2efL/f90bUJKozjYGTN7VFLLhaDdX0EwHIvNQZiiOjvkBGs4OzTP7wKl8wSfXRgspAG1wtWNRU7Em+NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ntNiO5Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntNiO5Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3C5C4CEF7;
	Sun, 29 Mar 2026 00:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744789;
	bh=RYBF6MuvY+9Pwm2d2SmJ7rVgxXFwRQzY6sw19M81dvg=;
	h=Date:To:From:Subject:From;
	b=ntNiO5LcTmeirsqpbcHnSuYW9nKhbyEs+OVFWzM268BcED/G2QIMxkBRO8/3Zmuuv
	 7P08ht4qe0nCRlAldnyvbW1jJ6WquRkiGfBfJY7YgO4zrq/GVb/1qPQZp5J8clwi4v
	 bvf/OHXCPUjlRb1zUjpRkHZp7i+kxBSRt0FbEsRQ=
Date: Sat, 28 Mar 2026 17:39:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hv_balloon-set-unspecified-page-reporting-order.patch removed from -mm tree
Message-Id: <20260329003949.0F3C5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hv_balloon: set unspecified page reporting order
has been removed from the -mm tree.  Its filename was
     hv_balloon-set-unspecified-page-reporting-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


