Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14312C86D
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744787; cv=none; b=Xtxx+r0/Egf+EX9F6D+Weg3VghywFCDVQfa5w14Yl9Cz9Wt7Zesj0byhWHoFj8OIywWrD27iiSlyQ1L9BEHzwoqz05Diwf5jbUyfCF2z8rnayJaIYVjxbtnacOv4Rc30tqFunrOPdaw5golUScenOCqMLSmsahRxcS1d6YL7iGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744787; c=relaxed/simple;
	bh=qpSoSYe0UzWoNusgQ3R1PeyBIcmvLH9n4jZVEvX+aAw=;
	h=Date:To:From:Subject:Message-Id; b=rYWDwptp1pAfzt5I02LKGvo4yPYYYpW2pcOf7rX58DHDHBKS3RRdVMW3VD3sGOlanLdnWb6rF1Ak7JM/LlwOKRlsUG4thnk/UJGh7DKh97Qyy1BqkscQHAHvIsXsc7cTokfaXpwRc4WGOWcOZkqXoCA6wEEp9gXtwtSwoiVytQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rS7kL/W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rS7kL/W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A14C4CEF7;
	Sun, 29 Mar 2026 00:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744787;
	bh=qpSoSYe0UzWoNusgQ3R1PeyBIcmvLH9n4jZVEvX+aAw=;
	h=Date:To:From:Subject:From;
	b=rS7kL/W3IFkwJ91hTp0XqRygHH+xjbugv+Jb5Xd+MF+24FAKDxd4S4KBpdV0D7zar
	 uh/oY36yPkzegMe7LGDq3NRlgfTbRugpwIZpf0DKZ2iuXAEcjUFoyPsU3hiRveNCtI
	 7qy1xsaf93AqeP4zQT9g/D8tBXKq+33wsaoIdxIs=
Date: Sat, 28 Mar 2026 17:39:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,yuvraj.sakshith@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] virtio_balloon-set-unspecified-page-reporting-order.patch removed from -mm tree
Message-Id: <20260329003947.A8A14C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: virtio_balloon: set unspecified page reporting order
has been removed from the -mm tree.  Its filename was
     virtio_balloon-set-unspecified-page-reporting-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Subject: virtio_balloon: set unspecified page reporting order
Date: Tue, 3 Mar 2026 03:30:29 -0800

virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly as
vb->prdev.order is never initialised and is auto-set to zero.

Explicitly mention usage of default page order by making use of
PAGE_REPORTING_ORDER_UNSPECIFIED fallback value.

Link: https://lkml.kernel.org/r/20260303113032.3008371-3-yuvraj.sakshith@oss.qualcomm.com
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

 drivers/virtio/virtio_balloon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-set-unspecified-page-reporting-order
+++ a/drivers/virtio/virtio_balloon.c
@@ -1022,6 +1022,8 @@ static int virtballoon_probe(struct virt
 			goto out_unregister_oom;
 		}
 
+		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
_

Patches currently in -mm which might be from yuvraj.sakshith@oss.qualcomm.com are


