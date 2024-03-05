Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE7F1078F
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600561; cv=none; b=BZoaAFUKe3UtjFj7vu/44fL05ufGKgp/3Y40gJkIJn1tO3lPXjMamdha4RvGeH5QPCx3/G9RbRbqmVzGaUlpi4dCIzbWcI8zCOPGitYTnhOP/hdS4s1GHVosYs222tYLULOStaQGzt58BQ6xAxv4dJU8ejqSA7qDu9Y6yxO4rwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600561; c=relaxed/simple;
	bh=EsTRxNHYgSrfRnyGzawoqzyaF2stfsCuaX5vxmuyE/Y=;
	h=Date:To:From:Subject:Message-Id; b=KjBsuUVL27S6UjkNQrdWZU7T8cAOcXmoPPM8l4MiSD7/NXQeDPZ2K9kii9M2FNVNJDfPyDmqi58/Qj+Inc6dPHtFfbo0oQj7swUQtXBWxd7wRFRlyRCCJwvnn54ze1f9TQk7eFJJr3RFEmfbdog3F2Lp/gppqH/3UpKMOHpkKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2W5AW36r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2W5AW36r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D072FC433F1;
	Tue,  5 Mar 2024 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600560;
	bh=EsTRxNHYgSrfRnyGzawoqzyaF2stfsCuaX5vxmuyE/Y=;
	h=Date:To:From:Subject:From;
	b=2W5AW36rTzdJZNENZ+0OYDta1s9wHoT/+5drIbn5GXwNHoTcW3KCGGvtuGLhEebLV
	 YpqeHwhkRp5l+zJaCnKXV1ZLcb6VPnFvTjRkIqduRvpLT6oI2tYzDBBE+vxafRzohu
	 bPCcepDRqexxKWBdGVKCn4QhQb1vnjQy5bQJ2sK8=
Date: Mon, 04 Mar 2024 17:02:40 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,songmuchun@bytedance.com,shy828301@gmail.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,david@redhat.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch removed from -mm tree
Message-Id: <20240305010240.D072FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: keep mm in mm_slot without MMF_DISABLE_THP check
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/khugepaged: keep mm in mm_slot without MMF_DISABLE_THP check
Date: Tue, 27 Feb 2024 11:51:35 +0800

Previously, we removed the mm from mm_slot and dropped mm_count
if the MMF_THP_DISABLE flag was set. However, we didn't re-add
the mm back after clearing the MMF_THP_DISABLE flag. Additionally,
We add a check for the MMF_THP_DISABLE flag in hugepage_vma_revalidate().

Link: https://lkml.kernel.org/r/20240227035135.54593-1-ioworker0@gmail.com
Fixes: 879c6000e191 ("mm/khugepaged: bypassing unnecessary scans with MMF_DISABLE_THP check")
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-keep-mm-in-mm_slot-without-mmf_disable_thp-check
+++ a/mm/khugepaged.c
@@ -920,7 +920,7 @@ static int hugepage_vma_revalidate(struc
 {
 	struct vm_area_struct *vma;
 
-	if (unlikely(hpage_collapse_test_exit(mm)))
+	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -1428,7 +1428,7 @@ static void collect_mm_slot(struct khuge
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit_or_disable(mm)) {
+	if (hpage_collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -2456,7 +2456,7 @@ breakouterloop_mmap_lock:
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
+	if (hpage_collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
_

Patches currently in -mm which might be from ioworker0@gmail.com are


