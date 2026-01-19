Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC823FC54;
	Mon, 19 Jan 2026 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854660; cv=none; b=rIFjkkLV2riGt7fOS5/51YpFjhUDZ/6qazpIoguiLSQk6kPMqrwKYYQ1N4aTXuCZZIaZaqHGiB5sK95+dhWpUjBAuu7Yt22Q53SzKBbWK83Y8MPXlsbn+31ynJhPLgovE8iLoeVaYXchGSxrkuUiBaf+2D/OAai0lMgBcq2GGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854660; c=relaxed/simple;
	bh=6r0Hql0eGEWxZ1s2todJ0p1HExEl+k3w8xptt7z24wE=;
	h=Date:To:From:Subject:Message-Id; b=RDuj66ms0zwCfPoeDFZpJD5objw2MXQhF6fdaQ58h059rDbWk4MiBYXa5EK3R+UWsSY4QLWxL5L/LXvRuQix4/L3pQe0Bqolx7aARmKc8xDUbqwbacHMhLoKfdFjFdlZ7mMC4nSYdgowCQZgeYmbpHnrhLEo234D4+GQWMaGlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uM7nHsg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uM7nHsg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBB6C2BC86;
	Mon, 19 Jan 2026 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854660;
	bh=6r0Hql0eGEWxZ1s2todJ0p1HExEl+k3w8xptt7z24wE=;
	h=Date:To:From:Subject:From;
	b=uM7nHsg9AMDqnDaSASNWcCq73SWAqrtFEssI1u5N3WgzyY9dKmJ0dKLrjW8jCo+I4
	 j37m9tHwXcE0D92k1/JbmCWedtSr2Jeus5+yoIoMEttnfM1FQhUZzlfPPEozsSC37n
	 tY73gm5IIi9Uwr08YRaj/OXceYZz/8GbHhDGlcmo=
Date: Mon, 19 Jan 2026 12:31:00 -0800
To: mm-commits@vger.kernel.org,suschako@amazon.de,stable@vger.kernel.org,riel@surriel.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,lance.yang@linux.dev,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20260119203100.7EBB6C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 22:40:36 +0100

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251223214037.580860-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-two-comments-related-to-huge_pmd_unshare
+++ a/mm/rmap.c
@@ -2016,14 +2016,8 @@ static bool try_to_unmap_one(struct foli
 					flush_tlb_range(vma,
 						range.start, range.end);
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					goto walk_done;
 				}
@@ -2416,14 +2410,8 @@ static bool try_to_migrate_one(struct fo
 						range.start, range.end);
 
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					page_vma_mapped_walk_done(&pvmw);
 					break;
_

Patches currently in -mm which might be from david@kernel.org are

vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch
vmw_balloon-remove-vmballoon_compaction_init.patch
powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch
mm-balloon_compaction-centralize-basic-page-migration-handling.patch
mm-balloon_compaction-centralize-adjust_managed_page_count-handling.patch
vmw_balloon-stop-using-the-balloon_dev_info-lock.patch
mm-balloon_compaction-use-a-device-independent-balloon-list-lock.patch
mm-balloon_compaction-remove-dependency-on-page-lock.patch
mm-balloon_compaction-make-balloon_mops-static.patch
mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch
drivers-virtio-virtio_balloon-stop-using-balloon_page_push-pop.patch
mm-balloon_compaction-remove-balloon_page_push-pop.patch
mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc.patch
mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch
mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch
mm-balloon_compaction-remove-extern-from-functions.patch
mm-vmscan-drop-inclusion-of-balloon_compactionh.patch
mm-rename-balloon_compactionch-to-balloonch.patch
mm-kconfig-make-balloon_compaction-depend-on-migration.patch
mm-rename-config_balloon_compaction-to-config_balloon_migration.patch
mm-rename-config_memory_balloon-config_balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon-fix.patch

