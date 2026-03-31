Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8711540855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917831; cv=none; b=Y1HI3TmaygkAc2dtKAIZzAiH0zAxtciSXzy08lW9253di19+ev9W8fxZhckhHU9PRlzu+eXRHLA60UEFUsCOXV8hLriA0oF2jQWHGcSHjjcr/izU5z63GMEZNmTz9GqQ/nFDPWDUswJPED+pTLHz1lP6cwBIXDnBWc/2uz/U5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917831; c=relaxed/simple;
	bh=y1XAkYB77X3ZMHVVTHoWhHrte226FDQoKhvHXHNbaFo=;
	h=Date:To:From:Subject:Message-Id; b=juUUKzPcUScMQXeYiJSQroQc5vGMahGmERMOO5bTn9zlMX2MpYykhKxo5rq/tG9HSDXkfnm6y4ktLNCNb4esOhstUmEfMqnr5Hp2BvXL2Xyv22F44O+8IUktJZj3pm5asrYpfx3WEwgRZGHWoLyec0qsi7OzGDkus820k8267k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vklYkTzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vklYkTzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF59C4CEF7;
	Tue, 31 Mar 2026 00:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917831;
	bh=y1XAkYB77X3ZMHVVTHoWhHrte226FDQoKhvHXHNbaFo=;
	h=Date:To:From:Subject:From;
	b=vklYkTzlZI5mK+Ocslp5ehmKlNW3kth6ZsFLizUGj2iy/Va4gziF+SmLY33tlNwnh
	 LhEd29WO8nlm90Vlj9a79yQcsOoFCmhtOMkuVCOvuuexua/RNElQdJmAI54o/TYidn
	 ib44Zg7hYsLOIuhBB4BrvwjgXX8oUUwD2vhsoiBA=
Date: Mon, 30 Mar 2026 17:43:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-unnecessary-sanity-checks.patch removed from -mm tree
Message-Id: <20260331004351.5EF59C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove unnecessary sanity checks
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-unnecessary-sanity-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: remove unnecessary sanity checks
Date: Fri, 20 Mar 2026 18:07:25 +0000

These checks have been in place since 2014, I think we can safely assume
that we are in a place where we don't need these as runtime checks.

In addition there are 4 other invocations of folio_remove_rmap_pmd(), none
of which make this assertion.

If we need to add this assertion, it should be in folio_remove_rmap_pmd(),
and as a VM_WARN_ON_ONCE(), however these seem superfluous so just remove
them.

Link: https://lkml.kernel.org/r/0c4c5ab247c90f80cf44718e8124b217d6a22544.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-unnecessary-sanity-checks
+++ a/mm/huge_memory.c
@@ -2448,7 +2448,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 		flush_needed = true;
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
@@ -2479,7 +2478,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 	if (folio_is_device_private(folio)) {
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 		folio_put(folio);
 	}
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

