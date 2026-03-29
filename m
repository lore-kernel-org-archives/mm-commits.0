Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC181FF1C7
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744773; cv=none; b=mZlOcwFekUrdAccnx+/8aY+FjMbSuPgT988FFmDBPqjoJ4kyjOsOxTFRnFsnRkEf2bozs2y7ASP7Kczs7t+8cse/xpG8cLacGW0sD/y5u56yj+RpcWhvo1pe4p/Ya03jRjUNkYjERnSmL7MnbNpEl9g4KJiAr0pfrOqnGrCuqnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744773; c=relaxed/simple;
	bh=ycSe/5GY4nUqb2VWdQtL6S1Pl0h7wvMSO2oNsO1Kh00=;
	h=Date:To:From:Subject:Message-Id; b=GNeCVUNM9W30eE9Esz2yftTCdWBrWLWYaB32MP5C2trvhqPrNyO41jOZFSU0DVCZ7qwL3TWpeOZxG5+8PEMdKU5fLL1smHKWoZkR8qufjlIE1c0CVD9+vKCIYw6y4u0YwlmWer7rK5qCEXjdkoWxy+yEXuxJMeq15k/LSZA5aFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oox+kkJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oox+kkJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F40C4CEF7;
	Sun, 29 Mar 2026 00:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744773;
	bh=ycSe/5GY4nUqb2VWdQtL6S1Pl0h7wvMSO2oNsO1Kh00=;
	h=Date:To:From:Subject:From;
	b=Oox+kkJp7YJBEzGG+xr8RpRMq9HQlmUa12wQPczIXFjgH0l3XUwVDGc55Q4XM6W57
	 X0Bv1gzPuNL8eo+7EcSEks8Cu0bekfu5RSPIkIUhIJuiSBMgBGQwMKNAuIeCGHwH0d
	 IxbtOuWUEDvAv2dmz2g6FJXgt4vf1DXgNkqDsLsg=
Date: Sat, 28 Mar 2026 17:39:32 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch removed from -mm tree
Message-Id: <20260329003932.F3F40C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
Date: Fri, 6 Mar 2026 14:43:39 +0800

The folio_referenced() is used to test whether a folio was referenced
during reclaim.  Moreover, ZONE_DEVICE folios are controlled by their
device driver, have a lifetime tied to that driver, and are never placed
on the LRU list.  That means we should never try to reclaim ZONE_DEVICE
folios, so add a warning to catch this unexpected behavior in
folio_referenced() to avoid confusion, as discussed in the previous
thread[1].

[1] https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/
Link: https://lkml.kernel.org/r/64d6fb2a33f7101e1d4aca2c9052e0758b76d492.1772778858.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced
+++ a/mm/rmap.c
@@ -1072,6 +1072,7 @@ int folio_referenced(struct folio *folio
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
 	*vm_flags = 0;
 	if (!pra.mapcount)
 		return 0;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

