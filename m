Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815315B12F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854728; cv=none; b=I4lN1wd7dAS+DbMpdZ8XTb3Q0fC6eivI+kuzyf7BxS0UfJpQcKLlmIhH3pFZIsx4ITnxSENTMSz2ziVh9LdiQMSjkDb+Zzlj/CO3T7FyhslzSNSbiujC/X8mYf2KFu9DQ/UCvFT/Dzz3YGashg+0exkqQWkfAAZZnRpFM+EHywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854728; c=relaxed/simple;
	bh=Vwd8e/u5R+knBY92KLVKdVmSDgutlPJBR/2o7+CD428=;
	h=Date:To:From:Subject:Message-Id; b=ZYLBl3B5ONRA4l+QdPTAH9MzjSRZp+2EDvnzFSNDDh+5ek6bNGSaiil0mZizG4Mn5NDvHOFpzYgfk32JyR7gEfYHBnsiPxpzCGNLRzgWtgRLgaMvDjzUzeI09c741f4L8CYGamKa6mkWgKWxwPPQco7Kafcx8Vg0wPB4c8dfvSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndb2KnQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndb2KnQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7DBC4CECF;
	Wed,  6 Nov 2024 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854728;
	bh=Vwd8e/u5R+knBY92KLVKdVmSDgutlPJBR/2o7+CD428=;
	h=Date:To:From:Subject:From;
	b=ndb2KnQSS1jmym0ODIlnTF7YxQghFZbIQ4ugFL3dFaso0PcoMoIlTQptXiEspdVtq
	 bFACRffpcWTjim2Y60o1sboeBhbbVEet5UKcWhwxdUpdPC0lHH3uYxydzsVwaFKLh4
	 lHpDGkiL49bVoRjNSSUKoDs9k9+nMRoFRFjoTxnc=
Date: Tue, 05 Nov 2024 16:58:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch removed from -mm tree
Message-Id: <20241106005848.9D7DBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: __collapse_huge_page_swapin() use pte_offset_map_ro_nolock()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: khugepaged: __collapse_huge_page_swapin() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:17 +0800

In __collapse_huge_page_swapin(), we just use the ptl for pte_same() check
in do_swap_page().  In other places, we directly use
pte_offset_map_lock(), so convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/dc97a6c3cb9ea80cab30c5626eeea79959d93258.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock
+++ a/mm/khugepaged.c
@@ -1014,7 +1014,11 @@ static int __collapse_huge_page_swapin(s
 		};
 
 		if (!pte++) {
-			pte = pte_offset_map_nolock(mm, pmd, address, &ptl);
+			/*
+			 * Here the ptl is only used to check pte_same() in
+			 * do_swap_page(), so readonly version is enough.
+			 */
+			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


