Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C04142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854737; cv=none; b=qPo71PDhI52j35kq6Q8ER1JvZotzj5PK/AgrmpbykdiN7ggvquVeEw4C9qH7E5MdcgnTUCEZ817sn0BzggirXDIg8Y7oe04c3jqCQnIOTrSFLEPWmPH37gmRBztw/dbwJK0U7q0bvy4e9rI5fFLeWWsTdV+7FuQf73KVR8sRzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854737; c=relaxed/simple;
	bh=eF+qWJh9MBOj0Ss9+zbwxEJSRWYTCwogzQzJuxg1oRI=;
	h=Date:To:From:Subject:Message-Id; b=JpnTPG/f8WOQpndhpa4y+OKBrfI4byt34aiRHqAH3W2ez1E7DRTG/krl+p1soJWUksOMTGp3d7tZfgt2dznY4N6CCFHLscRvziI0c2te20pL5nkOLNAw+L30O7hBGT7Lpu+Qk7+PR/K47t3/pfELYmzPOAKZ4ikSA8rkhVLIooQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1MckXdk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1MckXdk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30481C4CECF;
	Wed,  6 Nov 2024 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854737;
	bh=eF+qWJh9MBOj0Ss9+zbwxEJSRWYTCwogzQzJuxg1oRI=;
	h=Date:To:From:Subject:From;
	b=1MckXdk3p73XFkn5v9qvHgahHaOl457MGupOHChth5etz63ErdFgquYoDk3DwrBMw
	 EaBGUvb1T+gOIGvhzp5d4ITVeI3C+5hhM/1cNran5GQHNKmFeVIUZjxMTV/Nj8RMtc
	 b8sP4SGPdnigPVF1XaKOCfAgQ7MxfPPdk8vwpngY=
Date: Tue, 05 Nov 2024 16:58:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005857.30481C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: move_pages_pte() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: userfaultfd: move_pages_pte() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:24 +0800

In move_pages_pte(), we may modify the dst_pte and src_pte after acquiring
the ptl, so convert it to using pte_offset_map_rw_nolock().  But since we
will use pte_same() to detect the change of the pte entry, there is no
need to get pmdval, so just pass a dummy variable to it.

Link: https://lkml.kernel.org/r/1530e8fdbfc72eacf3b095babe139ce3d715600a.1727332572.git.zhengqi.arch@bytedance.com
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

 mm/userfaultfd.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock
+++ a/mm/userfaultfd.c
@@ -1135,7 +1135,7 @@ static int move_pages_pte(struct mm_stru
 	spinlock_t *src_ptl, *dst_ptl;
 	pte_t *src_pte = NULL;
 	pte_t *dst_pte = NULL;
-
+	pmd_t dummy_pmdval;
 	struct folio *src_folio = NULL;
 	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
@@ -1146,7 +1146,14 @@ static int move_pages_pte(struct mm_stru
 				src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
-	dst_pte = pte_offset_map_nolock(mm, dst_pmd, dst_addr, &dst_ptl);
+	/*
+	 * Use the maywrite version to indicate that dst_pte will be modified,
+	 * but since we will use pte_same() to detect the change of the pte
+	 * entry, there is no need to get pmdval, so just pass a dummy variable
+	 * to it.
+	 */
+	dst_pte = pte_offset_map_rw_nolock(mm, dst_pmd, dst_addr, &dummy_pmdval,
+					   &dst_ptl);
 
 	/* Retry if a huge pmd materialized from under us */
 	if (unlikely(!dst_pte)) {
@@ -1154,7 +1161,9 @@ retry:
 		goto out;
 	}
 
-	src_pte = pte_offset_map_nolock(mm, src_pmd, src_addr, &src_ptl);
+	/* same as dst_pte */
+	src_pte = pte_offset_map_rw_nolock(mm, src_pmd, src_addr, &dummy_pmdval,
+					   &src_ptl);
 
 	/*
 	 * We held the mmap_lock for reading so MADV_DONTNEED
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


