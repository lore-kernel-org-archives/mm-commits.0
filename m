Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91413B960C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068150; cv=none; b=RVDmuZV1DWe954nu2I/dVf3K37IbcjTEP2g1t5Lbdt9HqFlc/yOPQpel+WzYoiNcXuZF4R4fjAtUlx5hc57OSnJVQa0dZN8oeXtWTDdb1wS06N78btTbDdyD4CrBZd1wmTHFczz1NT66o9YQK8dTxbl7BXoWhzmdaCGd82WRTPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068150; c=relaxed/simple;
	bh=mjgiXjZYNIdfIFqm+D7z8JzPJyIUxn74tVo14G58PnU=;
	h=Date:To:From:Subject:Message-Id; b=Iw3U6GST7uoqbhhBaMdFHCXfyOhWLAxCHzNWujx+em01sxejnEGpjHM62IQRlLp/dlyfdYEl4unY+EIdNYXlghNF2LRFarsdEqCeFqSMEBR2sY3aWdSdKDUHQwzE3/g1bHN9iXf0JluMAcvm0/CXWpr9wf5WNogochXAI1CkAfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SBZDmG7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SBZDmG7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3192E1F000E9;
	Fri,  7 Aug 2026 02:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068149;
	bh=LrLUyuEtFoMAChOAq5UnfipKzasOTvQ8dv+rlMX968k=;
	h=Date:To:From:Subject;
	b=SBZDmG7ZpATywzH8NvXjON4BofTu9m/IcGCHeESvBLIkzGfZ9i21W74fEXho1V87c
	 TuY/qrFv/T7TXSSj/wVrTdIBQmp3xhP4WJhco3CL6UoOhfwuXldl7hLqworSLNp3ZG
	 kVZ38oO8EKq5iCDrN7HVSMCbmp6bQ1P2LxVLOYdo=
Date: Thu, 06 Aug 2026 19:02:28 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,joshua.hahnjy@gmail.com,jane.chu@oracle.com,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-evaluate-subpool-free-state-while-locked.patch removed from -mm tree
Message-Id: <20260807020229.3192E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: evaluate subpool free state while locked
has been removed from the -mm tree.  Its filename was
     hugetlb-evaluate-subpool-free-state-while-locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: hugetlb: evaluate subpool free state while locked
Date: Tue, 21 Jul 2026 11:52:07 +0800

unlock_or_release_subpool() drops spool->lock before calling
subpool_is_free().  However, subpool_is_free() reads fields that are
updated under spool->lock, including count, used_hpages and rsv_hpages.

Keep the free-state evaluation under the same lock that protects those
fields.  The reservation accounting and kfree() calls still happen after
dropping spool->lock.

Link: https://lore.kernel.org/20260721035207.1437935-1-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-evaluate-subpool-free-state-while-locked
+++ a/mm/hugetlb.c
@@ -141,12 +141,14 @@ static inline bool subpool_is_free(struc
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 						unsigned long irq_flags)
 {
-	spin_unlock_irqrestore(&spool->lock, irq_flags);
+	bool free_subpool = subpool_is_free(spool);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
-	if (subpool_is_free(spool)) {
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
+
+	if (free_subpool) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
_

Patches currently in -mm which might be from chenyichong@uniontech.com are


