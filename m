Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4610F35F18B
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 00:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681764; cv=none; b=OtVFTe8sb5NgWgpe9dY0g5dUPLSVtKtD0AYv2/8u0xiAjIx/kMnrDA/6X0CQ23ZK0aXppL6B2KOl5jO1OQUek2RiL103bYLMsmuBm/WFiBNj5oAlagBfFiNNRLqXJNUT1vqOZd8Tjkp+F0km7dB9xjUmMFSg7EtfNiw+hB3veIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681764; c=relaxed/simple;
	bh=uLK7kcWZUvZ3J3KsMAdp8WnI8Y8UvvqMs1pcmAsxGkI=;
	h=Date:To:From:Subject:Message-Id; b=strkLEaA9ZlHfPU3wWHVQz+derLbJivAs3VTHl3W42bMV1PgYycDyzVpHAFKN+0zEllg1g1wu1V1Kvrv9smObzSiGQGOcVMzjMzUKNfzjVlD9LCdfjPA4lbq7SVSUGF4MDS5iRyQT7oTHOQMmLMWF7DLN9wTkcc2NmV4h2QRKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vawEC03W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vawEC03W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027BD1F000E9;
	Wed, 22 Jul 2026 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784681763;
	bh=FFEnbJ3thBffLwJ8smu4Rh+EOspuoJznwtJy6AMJyUw=;
	h=Date:To:From:Subject;
	b=vawEC03WXl+ozhiZRCMobqi0+J7qHKRyKGqu9Re9wVTclpZcD7KTyIF/U0xlWZBZq
	 87kgtQpAYBqgFau8SP8NDyGkY0aXM6fj2jcalEsCsFDvURk+Abo0EUspmRNdEhHwP8
	 zHxX2HP5f9I8EgKn6v++yYSQoslcrVbEN+F4FHus=
Date: Tue, 21 Jul 2026 17:56:02 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,joshua.hahnjy@gmail.com,jane.chu@oracle.com,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-evaluate-subpool-free-state-while-locked.patch added to mm-new branch
Message-Id: <20260722005603.027BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: evaluate subpool free state while locked
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-evaluate-subpool-free-state-while-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-evaluate-subpool-free-state-while-locked.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch
hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
hugetlb-evaluate-subpool-free-state-while-locked.patch
fat-release-buffer-head-after-rebuilding-parent.patch

