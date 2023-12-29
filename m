Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E211F12B93
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yV7tOWK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314E7C433C8;
	Fri, 29 Dec 2023 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876677;
	bh=0Dn31Vb2HbABIzqZ4bBJPefk9fq/qtr9oizTZonAK3k=;
	h=Date:To:From:Subject:From;
	b=yV7tOWK8lVyp4pyww3i5nrPkqLDbUmMjgGnrm8dI0jTIyh/GDCL1s7HVx3+bOOFOv
	 CeNGs8QbQX4QRZWwiVJF8t/Iv08aVcs5KM/7TPmGgskmkIHqim81AQ75SLibBtAvZ6
	 MmXFZKgBLJhwX810fgvOx62feng9IobMjM4We564=
Date: Fri, 29 Dec 2023 11:04:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch removed from -mm tree
Message-Id: <20231229190437.314E7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch

This patch was dropped because it was folded into mm-memcg-fix-split-queue-list-crash-when-large-folio-migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
Date: Wed Dec 27 02:03:52 PM PST 2023

fix comment, per Zi Yan

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
+++ a/mm/memcontrol.c
@@ -7544,7 +7544,7 @@ void mem_cgroup_migrate(struct folio *ol
 	/* Transfer the charge and the css ref */
 	commit_charge(new, memcg);
 	/*
-	 * If the old folio a large folio and is in the split queue, it needs
+	 * If the old folio is a large folio and is in the split queue, it needs
 	 * to be removed from the split queue now, in case getting an incorrect
 	 * split queue in destroy_large_folio() after the memcg of the old folio
 	 * is cleared.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-split-queue-list-crash-when-large-folio-migration.patch
maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
kasan-stop-leaking-stack-trace-handles-fix.patch

