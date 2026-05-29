Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C218435B136
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 03:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026477; cv=none; b=c/i12Kx5PVlm5cRAUDlyuOgrQq/MkLvmrYHliQK5yZMa8Taf0Xtiu3gaTubIa97NCTYKyk1xF8CjbS5RSuj4aSuQkSgK1XuLP5/JWKpinpttmmEqMRGNoJOOj1zn3TCKEaWH9NqDVI5gWicrsa3Wx0nTqvuEFrZynSpxEwPFg5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026477; c=relaxed/simple;
	bh=k8PkLQk2aqId9bUBztv8v/EcdswoHZTM1dBue57ZlCI=;
	h=Date:To:From:Subject:Message-Id; b=TgKQHVegOrOjrryljxUExL4aOWxw1dRldgNscd2zAbsouhx8fYFJHjXTNGGa+bXS20UJF2N9fh9qLxJuYubiUCn+5miVy0rL28tCSzfnLwo/6IDBZuV9pnFTKu+Smv3fUzIo8iXGMhyfoHlsxUAHdcjEqYhrGu5uPu1UO5JJ+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxP4wD/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxP4wD/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCCB1F000E9;
	Fri, 29 May 2026 03:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026476;
	bh=4PKiWhxGP76MA8GDjc1qqa2vDZF+aUvK48rXyvDStt4=;
	h=Date:To:From:Subject;
	b=HxP4wD/+QycYWuqv4eq8F9hmyJU4/ZHDQL6wA93j8FxbVnBIyJu5npf/QsJTjVYMp
	 7ngQjHQbHNiyBh2qAfw+o7du5bIhmbzzGwEGUc7Qy9r9s9VASl8uj/eSDTiidDFQoh
	 4RdTXkt0KGW5C/+HA6OLAH+5TmZNlZH9evmYzqFs=
Date: Thu, 28 May 2026 20:47:55 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch removed from -mm tree
Message-Id: <20260529034756.3DCCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch

This patch was dropped because it was folded into mm-hugetlb-avoid-false-positive-lockdep-assertion.patch

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
Date: Thu, 14 May 2026 10:45:38 +0100

account for the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case

Link: https://lore.kernel.org/agWZsPGYid08uU6O@lucifer
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
+++ a/mm/hugetlb.c
@@ -118,6 +118,9 @@ static int hugetlb_acct_memory(struct hs
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
@@ -6969,6 +6972,13 @@ pte_t *huge_pmd_share(struct mm_struct *
 	return NULL;
 }
 
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks)
+{
+	return 0;
+}
+
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-hugetlb-avoid-false-positive-lockdep-assertion.patch
drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch
mm-vma-remove-mmap_action-success_hook.patch
mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter.patch

