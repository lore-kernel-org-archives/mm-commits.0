Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60975423761
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525608; cv=none; b=hSQSAsy7VmBehG7cjSsIsWX6eDNJxUzbqfxY9LIjVHsVx6X9oI7SDysX/yENfjNMLe0nneQt9GCOnRrUbaqV+i9d3YIdihckHtDA+mX45TeGcSPMPmYiN0nVhXDTp+r6peckVbszuVJNFrfQgv1mcq028T+C6Dvt20X0scGd4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525608; c=relaxed/simple;
	bh=C78Y+Ed03xt8al8kbpOKjw+0FHRZm0dSAjOkD+UhNNU=;
	h=Date:To:From:Subject:Message-Id; b=o1a5aH2AFk8t2J0nKd/xXtzSK744waGy7NInIR+7XrrAFu0wPwkvVlQKota95eWqMuCiAwwrkkJBumm79vWIgToTAcHcdX1IkR/YI0n2oq/6Mm1MXhBmglXFT5sIXpnUh41GU/twQshmHQrc+7kX6u74MqWepAnf0CE5D2tgMhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0r9smkPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0r9smkPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCF31F00899;
	Fri,  9 Oct 2026 06:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525606;
	bh=/J4EnjtGjL6B5T+O9JB5SFBLocAOyek7CUd924ywWXw=;
	h=Date:To:From:Subject;
	b=0r9smkPCNrwUl7zWm8+RfCz0fWEtSMzRyaCsBTd8OyGjv3zudW8FGOsCiXbU2lVpe
	 +oL07PbgqzvSKleNUd3ARwOYL+TY/tVKEX2wuoDgqc61DsKbaBUk2oDlcOZVk0hw2i
	 UuGgfDM5UpqQRPdLyMYfaBkfVkq3lHNqCQ7ubBk0=
Date: Thu, 08 Oct 2026 23:00:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch removed from -mm tree
Message-Id: <20261009060005.DCCF31F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move the racy refcount check into unmap_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move the racy refcount check into unmap_folio()
Date: Wed, 23 Sep 2026 23:32:41 +0200

The check only exists to avoid the expensive PMD-splitting unmap of a
folio that cannot be split anyway.  Move it from __folio_split() and
folio_split_unmapped() into one check in unmap_folio(), right before the
PMD split.  All split helpers get the same early check without repeating
it.

unmap_folio() now returns -EAGAIN if the check fails and the split helpers
propagate the error.  folio_split_unmapped() drops its own copy of the
check: it works on already unmapped folios and the definitive
folio_ref_freeze() in __folio_freeze_split_anon() still catches unexpected
references.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-10-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio
+++ a/mm/huge_memory.c
@@ -3538,13 +3538,22 @@ void vma_adjust_trans_huge(struct vm_are
 		split_huge_pmd_if_needed(next, end);
 }
 
-static void unmap_folio(struct folio *folio)
+/*
+ * A return value of 0 does not mean that unmapping succeeded. It might
+ * still have failed, but remap_anon_folio() must be called afterwards,
+ * for anon folios.
+ */
+static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
 		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	/* Racy check if we can split the page, before we split PMDs */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
+		return -EAGAIN;
+
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
@@ -3558,6 +3567,8 @@ static void unmap_folio(struct folio *fo
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
 
 	try_to_unmap_flush();
+
+	return 0;
 }
 
 static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
@@ -4028,7 +4039,9 @@ static int __folio_freeze_split_anon(str
 
 	if (folio_mapped(folio)) {
 		need_remap = true;
-		unmap_folio(folio);
+		ret = unmap_folio(folio);
+		if (ret)
+			return ret;
 	}
 
 	local_irq_disable();
@@ -4122,7 +4135,9 @@ static int __folio_freeze_split_file(str
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	unmap_folio(folio);
+	ret = unmap_folio(folio);
+	if (ret)
+		return ret;
 
 	xas_lock_irq(xas);
 
@@ -4326,15 +4341,6 @@ static int __folio_split(struct folio *f
 		i_mmap_lock_read(mapping);
 	}
 
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4373,7 +4379,6 @@ static int __folio_split(struct folio *f
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
 	if (anon_vma) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
@@ -4421,9 +4426,6 @@ int folio_split_unmapped(struct folio *f
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
_

Patches currently in -mm which might be from kasong@tencent.com are


