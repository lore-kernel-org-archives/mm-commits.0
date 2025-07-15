Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95902BEFEA
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 21:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752615476; cv=none; b=XjbyPbCqukHmyh8Ixw3Rwl/+OS5LGVMX4KECEHlrx+gTUNiA5X6QF9EiBnuKdIe0QrXMxtbytGmD9Y385rQndqxD671+AFfI/YhNRdjgCW0pauqW6QbGIEtiKNvLHZzpa0eNSJftnqt1zizXcPHTcYBNjnMqHNVi7+JdtmlkGhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752615476; c=relaxed/simple;
	bh=ENT4KEgttBfyIJnrvAC43Kmj/znvF81ycr+TNwejXDY=;
	h=Date:To:From:Subject:Message-Id; b=IFRL/Ixbgu/2Z7i59CjYEfx3ZpBWC/+vAC74qAo7oA94A7zFTG8RPNDipEvMDn0fFXe+KI24cierHTPS3nS4UoPYQTd8tBKurw/IIbS1KnpZEzMv11+mJo6EQ1Wk4MNSbQ9uBCorx4oMcddEX7N+AY7SWfTweu1qJln4NXwtQZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1XL88CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1XL88CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0A4C4CEE3;
	Tue, 15 Jul 2025 21:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752615476;
	bh=ENT4KEgttBfyIJnrvAC43Kmj/znvF81ycr+TNwejXDY=;
	h=Date:To:From:Subject:From;
	b=L1XL88CSZEbUozrcKRe15YHqG+lfZULr0Vo93MT08BhNq7BlARoiT1//03FPkXN4U
	 XXJlspOCaAaMYeVo/GLvk2mNLDlFvvIZjOHjgA29QBZguutHtS4tlqEmCdO973ReB4
	 ZkAemMdbA0I5QSj5ac4//T8X1NDPJ2r0tj4hASyg=
Date: Tue, 15 Jul 2025 14:37:55 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch added to mm-new branch
Message-Id: <20250715213756.2B0A4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq() fix
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq() fix
Date: Tue, 15 Jul 2025 13:48:25 -0700 (PDT)

Delete the comment from above the deleted spin_lock_irq(): it was all to
justify the first iteration's spin_lock_irq(), none suitable for moving
down to where the parent's spin_lock_irq() is now done.

Link: https://lkml.kernel.org/r/dbf9352a-1ed9-a021-c0c7-9309ac73e174@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/swap.c~mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix
+++ a/mm/swap.c
@@ -259,13 +259,6 @@ void lru_note_cost_unlock_irq(struct lru
 	for (;;) {
 		unsigned long lrusize;
 
-		/*
-		 * Hold lruvec->lru_lock is safe here, since
-		 * 1) The pinned lruvec in reclaim, or
-		 * 2) From a pre-LRU page during refault (which also holds the
-		 *    rcu lock, so would be safe even if the page was on the LRU
-		 *    and could move simultaneously to a new lruvec).
-		 */
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost += cost;
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch
mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch

