Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB3A5672
	for <mm-commits@vger.kernel.org>; Sat, 15 Mar 2025 01:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742000609; cv=none; b=aCrcbnN3SM+0EKOuT9fgtCTchiNJCR5X1+RAOciHgn4yRW9t95HY4ELHFBB17d0nHVumBpebQt42zdIEGpVBLZNRwUfEIwkbHV88jA//TpbzVcssOmJxCsku7y4+wdhe4f6XFuddZEJCbNlb/Jii1YMTmyS6c/BiZ1j2thBF3nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742000609; c=relaxed/simple;
	bh=Zkn/a0aa/IhFTk2MQxfiOxzDO4G5cL6NjEDqSY1esJc=;
	h=Date:To:From:Subject:Message-Id; b=nXX8Q7VRVHnyOYC60tXi5nn/dLznkPzp/EBin23eN8D6pOqhCKG0qX+5qtHF1rja/+19YeHqS1VDXNWI9XGs/fotnrSkt5BvN23ffrGQbAd1Pp3A27OAvkQX5TaUSMGbgzKfkr1wsd5kIuo7De4H5YqlDpAbPdxicHNUNEIrlWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZRvHB7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZRvHB7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F4C4CEE3;
	Sat, 15 Mar 2025 01:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742000609;
	bh=Zkn/a0aa/IhFTk2MQxfiOxzDO4G5cL6NjEDqSY1esJc=;
	h=Date:To:From:Subject:From;
	b=xZRvHB7a6quKy9utUJZJ5Ojh+o7MKqmuq/L0DKuEPszdOp39SDR8bAztjuRNi8iLz
	 ZQ69N7YJzGjrLekEVWeS7pQhPfu/xZTdpfIdHRVSeg0t2KHWDDSurPQabVAMmygPO5
	 OiLL42hTRIO5j/e09Ep/Gf2/dFELYE/DZqy4/CDQ=
Date: Fri, 14 Mar 2025 18:03:28 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xen-balloon-update-the-nr_balloon_pages-state.patch added to mm-unstable branch
Message-Id: <20250315010329.232F4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xen: balloon: update the NR_BALLOON_PAGES state
has been added to the -mm mm-unstable branch.  Its filename is
     xen-balloon-update-the-nr_balloon_pages-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xen-balloon-update-the-nr_balloon_pages-state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: xen: balloon: update the NR_BALLOON_PAGES state
Date: Fri, 14 Mar 2025 15:37:57 -0600

Update the NR_BALLOON_PAGES counter when pages are added to or removed
from the Xen balloon.

Link: https://lkml.kernel.org/r/20250314213757.244258-5-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
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

 drivers/xen/balloon.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/xen/balloon.c~xen-balloon-update-the-nr_balloon_pages-state
+++ a/drivers/xen/balloon.c
@@ -157,6 +157,8 @@ static void balloon_append(struct page *
 		list_add(&page->lru, &ballooned_pages);
 		balloon_stats.balloon_low++;
 	}
+	inc_node_page_state(page, NR_BALLOON_PAGES);
+
 	wake_up(&balloon_wq);
 }
 
@@ -179,6 +181,8 @@ static struct page *balloon_retrieve(boo
 		balloon_stats.balloon_low--;
 
 	__ClearPageOffline(page);
+	dec_node_page_state(page, NR_BALLOON_PAGES);
+
 	return page;
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch

