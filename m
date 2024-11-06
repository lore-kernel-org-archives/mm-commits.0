Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC99D142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854734; cv=none; b=n4zGwEIzaMOoEnkPd9X4a9OKpDOFcqcwPRc3nA3G9MmxryMBZO7Kc7bH70oAISSfqe3xXXaNRWagg9T7Gkta1YJLQmD5GSss7fc5OtRh3wfBBlcU5Eh4CG86r4BRB6r+eDqUHOyss253XNg8+BtuyAdPLiwPCj8I/rRpvfbuntA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854734; c=relaxed/simple;
	bh=61UUAtYFc1KqkePihgtP6BP+jPhJSqtO+EQW6Rehvlc=;
	h=Date:To:From:Subject:Message-Id; b=Nvlv+BoqQ9upLtFrctB75wI2KQJCe3TRhKR9pBeh2zvTSyWFkc6IAzZRuAHZU4RICL95zqJg8NP09rxj3v4Af/LPchS9y/LMeTjEYxccnGFn7lCyjh3paKb8zieRzZsy4oxAVgDaGXPDQOJhSLL2WGgLag/e9tUghGTncUe0pqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TPplG5OO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TPplG5OO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FE5C4CECF;
	Wed,  6 Nov 2024 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854733;
	bh=61UUAtYFc1KqkePihgtP6BP+jPhJSqtO+EQW6Rehvlc=;
	h=Date:To:From:Subject:From;
	b=TPplG5OOQQLmoHwZlfSmebmb/mf3MqRy6hsaLO8ACcyLWVbYxgao0EYN1HB0TEyMK
	 S+//IiMpSWIKOH8/bg5fX5GxqsDccTLKynsAGbNgJ3LxI/DjupvUbPM5qbff/lalZx
	 9oeuWuTnJBi0WJ/GhGFAeOw1jOlSCHOGRmeHrZWk=
Date: Tue, 05 Nov 2024 16:58:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005853.C2FE5C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: copy_pte_range() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: copy_pte_range() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:21 +0800

In copy_pte_range(), we may modify the src_pte entry after holding the
src_ptl, so convert it to using pte_offset_map_rw_nolock().  Since we
already hold the exclusive mmap_lock, and the copy_pte_range() and
retract_page_tables() are using vma->anon_vma to be exclusive, so the PTE
page is stable, there is no need to get pmdval and do pmd_same() check.

Link: https://lkml.kernel.org/r/9166f6fad806efbca72e318ab6f0f8af458056a9.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-copy_pte_range-use-pte_offset_map_rw_nolock
+++ a/mm/memory.c
@@ -1084,6 +1084,7 @@ copy_pte_range(struct vm_area_struct *ds
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
+	pmd_t dummy_pmdval;
 	pte_t ptent;
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress, max_nr, ret = 0;
@@ -1109,7 +1110,15 @@ again:
 		ret = -ENOMEM;
 		goto out;
 	}
-	src_pte = pte_offset_map_nolock(src_mm, src_pmd, addr, &src_ptl);
+
+	/*
+	 * We already hold the exclusive mmap_lock, the copy_pte_range() and
+	 * retract_page_tables() are using vma->anon_vma to be exclusive, so
+	 * the PTE page is stable, and there is no need to get pmdval and do
+	 * pmd_same() check.
+	 */
+	src_pte = pte_offset_map_rw_nolock(src_mm, src_pmd, addr, &dummy_pmdval,
+					   &src_ptl);
 	if (!src_pte) {
 		pte_unmap_unlock(dst_pte, dst_ptl);
 		/* ret == 0 */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


