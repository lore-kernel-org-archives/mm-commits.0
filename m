Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417E1DF261
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308943; cv=none; b=jqAIRRWXr4mKohgjgTB1E6SCNnabfmBBKrofyL9Re/0XbE75B+9LjUToMMOfupaxW/bCZ92pq0+gYXYpU9Mzxago6s/FLCviK79Q3IT3illiyGQNwnOqCvfBRdtIMuDwPvNhKqQ1VzgGjwEi1cBBFM+FRbCSqiLp0ztg3E2GO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308943; c=relaxed/simple;
	bh=QJAqMKhMMASr7SUXGYzjfu2IpJmijvU6YxTpcOvgYVc=;
	h=Date:To:From:Subject:Message-Id; b=IcuD/YrdERMVsiyIcvjxWnIxbk7Q3nKzGYh3HjzDqus5cArkRgcIZUNVoP8kkiNsuXTlCT744gYq7yL0ogNIIANYibN1WoRcCSD1MdDAUCTAhw3U7vslh8egXktcuBIILuQaAlRUVFQZMBzgmKifc4MpoKK/kq5kmOwcWZfeMsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AOp9+WYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AOp9+WYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927A6C116D0;
	Sat, 28 Feb 2026 20:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308942;
	bh=QJAqMKhMMASr7SUXGYzjfu2IpJmijvU6YxTpcOvgYVc=;
	h=Date:To:From:Subject:From;
	b=AOp9+WYYC6YgeKeapFsham6sEe5kySFDC5eSliTuBnV9oBGWkPi16Jkxok9s1GCej
	 wM22kmvsQobXwC8h1pk64ICnrMmYJ/rG2tGjsKMbkr2ODpm6IVW9npTyc8GNtc+Ky4
	 5vWhZp8QYHmSBKp+HcYrlcz66BJe0wdZ7+QhD2+o=
Date: Sat, 28 Feb 2026 12:02:22 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch added to mm-new branch
Message-Id: <20260228200222.927A6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
Date: Fri, 27 Feb 2026 17:44:37 +0800

The folio_referenced() is used to test whether a folio was referenced
during reclaim.  Moreover, ZONE_DEVICE folios are controlled by their
device driver, have a lifetime tied to that driver, and are never placed
on the LRU list.  That means we should never try to reclaim ZONE_DEVICE
folios, so add a warning to catch this unexpected behavior in
folio_referenced() to avoid confusion, as discussed in the previous
thread[1].

Link: https://lkml.kernel.org/r/6562be8c92e07f0a69c8ffd4016d1b1e55198af6.1772185080.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/ [1]
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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
@@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
 	*vm_flags = 0;
 	if (!pra.mapcount)
 		return 0;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch

