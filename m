Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3EE2F2F
	for <mm-commits@vger.kernel.org>; Sat, 15 Mar 2025 01:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742000607; cv=none; b=DZAGsdfTby/GdI8MIvlh7QC9JjNghUxF35jzBTS6j+/odirayeKb244v63+WvX/9vNAnClWiIAe5S0centAqVu3JTMMR6LCzAlMNe8X6btICCxOvuwvUkCG2pRMVN7qklepN17KgTIdrHqb1Tw56ymtGW8rUA54+WPLeVK9S4Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742000607; c=relaxed/simple;
	bh=8BpTSKbdHHe5GIvrDZOanqaSVkU3GUdzvAR1tkoyR0k=;
	h=Date:To:From:Subject:Message-Id; b=OudFZeJHV7sGxgf2JQB9WbO2WTF76/Jcpe6rDnT5VOtJ6Br81BzABksegQOWVNrYUHkKaD289ifCYRFXmUNTHOU3Iu9rMgu2zvuumQPZpB9wfMY/m/GZYDLtVrNzaTHJPwVo7rji/HHCOdyDq3y7dAIiKTwHxCGehQyNCtzhiKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jWD1pTIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWD1pTIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED295C4CEE3;
	Sat, 15 Mar 2025 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742000607;
	bh=8BpTSKbdHHe5GIvrDZOanqaSVkU3GUdzvAR1tkoyR0k=;
	h=Date:To:From:Subject:From;
	b=jWD1pTIBi2DfrRIdWcGWw6UAm/bgQ4qLmFyl2VTS2ERRyk0SZ1+e5b5LmuhRz+XDc
	 al5eJGCPLb3DHoFf5jUx4+kKQgAoZvbD5RndbJ8zGANLu+OC6dnsRNjHcRCole3W74
	 6o1GbDEKVG2tmgcBlFeW7kSY78odEGiNExkb0MT0=
Date: Fri, 14 Mar 2025 18:03:26 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hv_balloon-update-the-nr_balloon_pages-state.patch added to mm-unstable branch
Message-Id: <20250315010326.ED295C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hv_balloon: update the NR_BALLOON_PAGES state
has been added to the -mm mm-unstable branch.  Its filename is
     hv_balloon-update-the-nr_balloon_pages-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hv_balloon-update-the-nr_balloon_pages-state.patch

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
Subject: hv_balloon: update the NR_BALLOON_PAGES state
Date: Fri, 14 Mar 2025 15:37:56 -0600

Update the NR_BALLOON_PAGES counter when pages are added to or removed
from the Hyper-V balloon.

Link: https://lkml.kernel.org/r/20250314213757.244258-4-npache@redhat.com
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

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch

