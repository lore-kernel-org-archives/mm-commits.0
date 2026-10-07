Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030844E06EA;
	Wed,  7 Oct 2026 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398655; cv=none; b=Eeb+ffVBTxWO0LSVBc6TeWjYrljXt1S9IAd3ujbfE40Lal9eKOrGVr+nHAWr3AkP6Cw8B9Woc58880Rxp8TqDvbfNLNqN4sg3RjTP1ae4MrVCqZZfhuns8ih7v9x8XY+3J7aLSAivYDOQAG6VyH3JEmMCCC/3H0vRJgWr8fVG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398655; c=relaxed/simple;
	bh=lPkrtCH3PJjnoX0U/IdH/1lq8CqqgobSQ57/S6/LeJI=;
	h=Date:To:From:Subject:Message-Id; b=mrzhf3sWulQ9P9PrVM6hG9/ayONAE3h4ghNLGaMFkuAAKB7qZR/TkJVlbvFiJonnmhFwao3UCACTrTkx1cCl0aEHlHaGAyZBlZ2Z5MSmvb6kbc2wL07GBgW2beVHtSt1WspWtdSHBWJschRS9ztdbbpq3MjSLH0gXC1JuSsaMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2FcXa5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2FcXa5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6205A1F000FF;
	Wed,  7 Oct 2026 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791398653;
	bh=Ev+4/KBlQxrmG8hIqrDOUjOzJhvBWOzFhgdK3O0GXgw=;
	h=Date:To:From:Subject;
	b=N2FcXa5LLDGKmIJ3/ewt05LATPyxuPBqLXY53QUENVIiPb6QM57Qt9yJb0A8llfo7
	 4aP+RtqV3zjw5xp9eX/y8m2itJQER5v1+iM3f6tVpq4Zs9GI234zkgHxtwFppAW/I1
	 caB671TdZFjlbSGuKHYPXXh68CNPuQGOHJW3WycM=
Date: Wed, 07 Oct 2026 11:44:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usama.arif@linux.dev,stable@vger.kernel.org,ryan.roberts@arm.com,nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kylebot@openai.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20261007184413.6205A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: flush deferred unmaps before dropping a failed folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kyle Zeng <kylebot@openai.com>
Subject: mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Tue,  6 Oct 2026 21:10:01 -0700

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU can
therefore retain a user translation to the freed folio.  This has been
reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Link: https://lore.kernel.org/20261007041001.43181-1-kylebot@openai.com
Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio
+++ a/mm/khugepaged.c
@@ -2478,6 +2478,11 @@ static enum scan_result collapse_file(st
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2488,9 +2493,8 @@ xa_locked:
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
_

Patches currently in -mm which might be from kylebot@openai.com are

mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch

