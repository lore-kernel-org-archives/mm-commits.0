Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67614DC535
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609084; cv=none; b=QLS5nPmWpo0gBRigzSmEMaZdIhYKjnA7KixfPPU0eKsiz0SUrYL7IjRwspOq1JOLMPw7jtFvZNBmomBpo6ZENgnnwik6wZXspx8sKMr/3FWGjg2tBiuU5vfyMGPBMtEzV4+Gbc92gpZs+/6y+sAlL0pCzdvj76N8uvjRS9EwtOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609084; c=relaxed/simple;
	bh=bczpsfaIbWBTVvGE1p9kL2qo3uXz2D7dRsiwqjBJQYU=;
	h=Date:To:From:Subject:Message-Id; b=ivMQI263CEwyjLlK26Kly2Mt3732pwmi3OsAmyD1blpHTEjQEkrB8RqvYCCgUY9amBbcQmkbt5xdRPsnhhXXJuX7gy/2SyUdsOQHcZwoSjvY82XYMCtd1O92cxrCJ/M7DBw3PEgp/YJ6njij75XXVLyaCxJfuc6pV5x8fu64CHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PVpp1nrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PVpp1nrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414661F00893;
	Thu,  4 Jun 2026 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609081;
	bh=cwfoQwXCl3i8BU1+BEIXA9dvT0FNcnhgdnbnkA91Auo=;
	h=Date:To:From:Subject;
	b=PVpp1nrNAwv6pSGlQeHG8RMto/s+ugIkU8Kq7O+Ri2RgkEesWE+slBfffc4mCrga/
	 jP0jPx+469QK6xjLm4Iz+TG5PjApXigVipQ2dhhlDXz9uejOVX3o1Xe+d8bknZOBxz
	 vmVRT19YYMaNV9imPluoXQkTBHeFW/v1ndEQ98S8=
Date: Thu, 04 Jun 2026 14:38:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-switch-deferred-split-shrinker-to-list_lru-fix.patch removed from -mm tree
Message-Id: <20260604213801.414661F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
has been removed from the -mm tree.  Its filename was
     mm-switch-deferred-split-shrinker-to-list_lru-fix.patch

This patch was dropped because it was folded into mm-switch-deferred-split-shrinker-to-list_lru.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
Date: Thu May 28 03:12:45 PM PDT 2026

fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
Link: https://lore.kernel.org/202605281620.lc3rtkBm-lkp@intel.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-switch-deferred-split-shrinker-to-list_lru-fix
+++ a/include/linux/huge_mm.h
@@ -679,7 +679,15 @@ static inline int try_folio_split_to_ord
 	return -EINVAL;
 }
 
-static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return 0;
+}
+
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped)
+{
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-deferred-split-shrinker-to-list_lru.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

