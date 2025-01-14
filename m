Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2276523C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837038; cv=none; b=Pa3CrCqd/QPJTMpNrORe4huKeG0d690lLYU7dQeiLiTCraZ7hni0USLnw4z1rx48BRxISY56fQvFiyPghO/n3zhKI7fSE4j2qjk0pcDudKD9oBZxqtZmac7E98ISqR9qQVF9y3b+P8VgtMmAgTmj33VZ7Y5dVSHYB5IifOL6wR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837038; c=relaxed/simple;
	bh=7SQHFYBvm0YJZ4DZemWU5ClN1MpPfOLEZphWNhxrBXU=;
	h=Date:To:From:Subject:Message-Id; b=UXfYBBvzSGtnq9jfKY9Pc2mSkt/vmVy6KELCcmJ6XNcbWRoyfGxZYONfuKGn2r3V4O8lYZ7Lsm471SsnQhWPnxXeNoi+bXRUPI8eWpf3wXS3AjZH446pV6gB4I4ZjvajAXwqaM04OL9rqPncZbgTz4X+l4xo6/Rw3KUsJ+oyAWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bhz+8VZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bhz+8VZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDCC4CEDD;
	Tue, 14 Jan 2025 06:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837038;
	bh=7SQHFYBvm0YJZ4DZemWU5ClN1MpPfOLEZphWNhxrBXU=;
	h=Date:To:From:Subject:From;
	b=bhz+8VZXtL04Dr6EkwuwQDtqXSvz3HfZu4Sp5DmPxQzDvQy2ox9/A07WdRIecjkEF
	 1iwZpHeiEvzsCrWrR71+ZIaAZTDTfbwrhZqTsip8d1DEynIonPhmxwjNs81ElyP0FZ
	 nznlzeDpp6mjZjAuuxNvDH8tuLSLWcD+aNRehMXw=
Date: Mon, 13 Jan 2025 22:43:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch removed from -mm tree
Message-Id: <20250114064357.ECFDCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: don't use __GFP_HARDWALL when migrating pages via memory offlining
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: don't use __GFP_HARDWALL when migrating pages via memory offlining
Date: Thu, 5 Dec 2024 10:05:08 +0100

We'll migrate pages allocated by other context; respecting the cpuset of
the memory offlining context when allocating a migration target does not
make sense.

Drop the __GFP_HARDWALL by using GFP_KERNEL.

Note that in an ideal world, migration code could figure out the cpuset
of the original context and take that into consideration.

Link: https://lkml.kernel.org/r/20241205090508.2095225-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining
+++ a/mm/memory_hotplug.c
@@ -1838,7 +1838,7 @@ put_folio:
 		nodemask_t nmask = node_states[N_MEMORY];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
-			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 			.reason = MR_MEMORY_HOTPLUG,
 		};
 		int ret;
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

