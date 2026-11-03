Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672159;
	b=Pls1a/4kGEHdLmvvQRapi08j7FZPBf4s/qWUY6MZ5VQzeb6uUyCZYZPTJwn+JP69f+GE
	 d+HmxSOcfoosI/66XOXEUcm/QsRcfU2rOHW8Jne8DIO32p2EmHd5qMSodJ4ZNPkRV71D4
	 Fb6+kykoIgrzSOPKTTxntd38XDqcXu3pueFFEBl0RquWtysrUyj9xbekFnjf0luSxKXAy
	 zP/biUOqAx3fxvs3Tc71Fr3t+WwAgv7FUFMIu0Oy5g/uGqqWAxyLthJ5f67rN97kzaRjZ
	 z01073rxqSOyZHv7y4c2zO8Rw3Sw4XVpAZPfli7slclADcM5BlMPTACVIMa182yPLoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672159;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BmU6ueIQkQJQ43IbzyBFj3Dwj9u/zzjD/0axEM5FElY=;
	b=Js6xciCxldg0bvabrzwol077+7lGsRW5w5eVU2cJoadolsfqgC9n0nu3F/IxUKF5M2f3
	 i5hq1gf7F8QvTN64xOWtyLwxxo5DJ6czabXB+PedzM9zAUI4L4fvLt9rtCo9LNoni4SOB
	 6S5wbKgdTxjw/RU3gKe9aFQnHMDhr0X+KBAMeq1F76vbg9Jqhp2y8dZnPt57HUioAlt5c
	 afoEVJ85QkQjGFJ3Nyqcs/h2NcbgD0q/CbumJ7IqBtS8YrFJiHMC1J2CgjY4t2CwE+N5r
	 M+kzz1TYdIxqBRkwFdH+Jf2iVzVhsZzrvnV+AuZM8Rs3WpnKBwewAYEEfHkNfv98A7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d3X6rj9L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029F3606A33A;
	Tue,  3 Nov 2026 02:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d3X6rj9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29AE1F000C1;
	Tue,  3 Nov 2026 02:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672158;
	bh=BmU6ueIQkQJQ43IbzyBFj3Dwj9u/zzjD/0axEM5FElY=;
	h=Date:To:From:Subject;
	b=d3X6rj9LPgkdNLiqV9t4hT6U815t4exMXJ0QUGiAVjuHTOurgoavCRX4F440pQ/XG
	 yblm9lq4Wk7ZUSCQ9ndPwC3oMVIjMZ0AyzsvKTY31pq2R63qCau4dWztfjqS7r4SAl
	 6XntFcrtLmbgbbVuJxPW7VtJPqcC8liUBGtHjRzI=
Date: Mon, 02 Nov 2026 18:15:58 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,kas@kernel.org,david@kernel.org,rppt@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch removed from -mm tree
Message-Id: <20261103021558.B29AE1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/cma: accept memory of CMA areas reserved at a fixed address
has been removed from the -mm tree.  Its filename was
     mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Thu, 29 Oct 2026 12:18:38 +0200

CMA areas allocated from memblock have their memory accepted by
memblock_alloc_range_nid(), but areas reserved at a fixed address with
memblock_reserve() are not.

If a fixed CMA area is requested by the cma=<size>@<base> command line
parameter, it may be in regular RAM and on TDX and SEV-SNP guests it
must be accepted.

Accept the memory of fixed CMA areas as well, so that all CMA areas are
accepted regardless of how they were reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-2-2cbced8b5cb7@kernel.org
Fixes: 75d090fd167a ("x86/tdx: Add unaccepted memory support")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address
+++ a/mm/cma.c
@@ -381,6 +381,8 @@ static int __init cma_fixed_reserve(phys
 		return -EBUSY;
 	}
 
+	accept_memory(base, size);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch
mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

