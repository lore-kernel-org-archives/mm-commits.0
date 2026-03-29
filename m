Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D06123505E
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744792; cv=none; b=k3hLaAFDje9IPiP+L5DVUQr5SRErO+ihNX0XLzOEYMdyUFxRfi9zth51IKVcYR39gVJms8tqE1kticphWI/Bz9izgKrJYfaOD045ZZoAX3bqCvor1nR1RcXrKLeG9nSq1nskIzzu9/4n12NH7r07gjQmm6pMUmvOHpzBgvHJ7as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744792; c=relaxed/simple;
	bh=vdplp3idR/9rD0t9OvzmtRbqxCtFsj4XbKcdUV8bJUA=;
	h=Date:To:From:Subject:Message-Id; b=B0o0mnaUoIxX3XLa6rftw7BrAFSB7R1NGX1XXwkMaBhvcB8byBpgX+13oWcZ/NY0S5x1/UurWuWLktQdAvPFS+kesLlW8mLRf/ZS5jVPMHDNJ3VIxyOFcFEGrXgNc3GCyLsa4uaO7yzIdOEWYz7k5xtnh3KuluhSgrLSBx28Q0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gC+ZxRrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gC+ZxRrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA112C4CEF7;
	Sun, 29 Mar 2026 00:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744791;
	bh=vdplp3idR/9rD0t9OvzmtRbqxCtFsj4XbKcdUV8bJUA=;
	h=Date:To:From:Subject:From;
	b=gC+ZxRrrnoZtE8oZ1eqdThpTGfe3Tn9WMLZOvAYUJcoygJRv0gw9urE1fapWZpL24
	 s88l0SecRS66qknyl9OcoGk1GImG9X0uDkfV+crV66V3RbeX/r87W2LD8Z4QT+5FjM
	 po+0dbEIubvrCZUsqCXk50dU9NLJ5stfA6M0XqwY=
Date: Sat, 28 Mar 2026 17:39:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch removed from -mm tree
Message-Id: <20260329003951.CA112C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_reporting: change page_reporting_order to PAGE_REPORTING_ORDER_UNSPECIFIED
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/page_reporting.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_reporting.c~mm-page_reporting-change-page_reporting_order-to-page_reporting_order_unspecified
+++ a/mm/page_reporting.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 /* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
@@ -369,7 +369,7 @@ int page_reporting_register(struct page_
 	 * pageblock_order.
 	 */
 
-	if (page_reporting_order == -1) {
+	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
 		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
 		    prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are


