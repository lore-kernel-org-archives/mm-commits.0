Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908D112F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619840; cv=none; b=PnuWyaiTEZM4EkMfQQjjMWgUmtgkCSvO9aLFYuPmR1qAierXaOJm6cQbzGaXCkRy/H+WsCY4AHBks9lrQfW9GGKg72mQ+rVt6kGdJobe2ZD8+f94eETszUriydWHodYnI9kQkJUOvzz0SjjRurJ0/z8jiL3gNBeYTixOMimiFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619840; c=relaxed/simple;
	bh=LuyNoGXh+wrsSrXxSm3sBF3qPFOuDfF8uJPlVfoKmPo=;
	h=Date:To:From:Subject:Message-Id; b=YVe3quSFv4zVzEKJkofXG0B+9946iwqqzHW87K/4Pdjrsbw/vjSucqlevn52izYnnnNWzLJZ1HaOl/1ERuPl7q694GsXbC7/rzRddfhRMGWZ04Hlfe8ZldltAJ1BDx8u6dKzWzAUfLhgR/ADyYEJloCJuEaHonEjewFJCD1UQPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmliaJPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmliaJPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B721C4CEDD;
	Sat, 22 Mar 2025 05:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619840;
	bh=LuyNoGXh+wrsSrXxSm3sBF3qPFOuDfF8uJPlVfoKmPo=;
	h=Date:To:From:Subject:From;
	b=xmliaJPuuynNw3+/rvckwpFUNz4RPUp+2ABA9NzjsChZ8uK3uwK72Nxd+vCQOBv8y
	 J78ewIPFRbOvqiWHbf6MXdFuWR8xVROAa1zIuEXflthSfx+vLVWC7M5/0ZUcf8FPDL
	 noCFP2/qP0OF/B7CSp0OHs53nlmyFQL1nBl1MpxQ=
Date: Fri, 21 Mar 2025 22:03:59 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,mhklinux@outlook.com,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hv_balloon-update-the-nr_balloon_pages-state.patch removed from -mm tree
Message-Id: <20250322050400.5B721C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hv_balloon: update the NR_BALLOON_PAGES state
has been removed from the -mm tree.  Its filename was
     hv_balloon-update-the-nr_balloon_pages-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: hv_balloon: update the NR_BALLOON_PAGES state
Date: Fri, 14 Mar 2025 15:37:56 -0600

Update the NR_BALLOON_PAGES counter when pages are added to or removed
from the Hyper-V balloon.

Link: https://lkml.kernel.org/r/20250314213757.244258-4-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Cc: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hv/hv_balloon.c~hv_balloon-update-the-nr_balloon_pages-state
+++ a/drivers/hv/hv_balloon.c
@@ -1192,6 +1192,7 @@ static void free_balloon_pages(struct hv
 		__ClearPageOffline(pg);
 		__free_page(pg);
 		dm->num_pages_ballooned--;
+		mod_node_page_state(page_pgdat(pg), NR_BALLOON_PAGES, -1);
 		adjust_managed_page_count(pg, 1);
 	}
 }
@@ -1221,6 +1222,7 @@ static unsigned int alloc_balloon_pages(
 			return i * alloc_unit;
 
 		dm->num_pages_ballooned += alloc_unit;
+		mod_node_page_state(page_pgdat(pg), NR_BALLOON_PAGES, alloc_unit);
 
 		/*
 		 * If we allocatted 2M pages; split them so we
_

Patches currently in -mm which might be from npache@redhat.com are


