Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D717139BFE0
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695492; cv=none; b=XMa4MgevXMTtx/JUtB9p/vndFZOPzWA6+5wFSM4Vgy6yqO//p4Fwa6FguPjC9/3AT8ZbkPlau+QjoTk2wbAFtAA0bw5f1epVKJ5hnoHxCCKsHQqz/rW92xkZ0Ff6mko5f/IWw7zR4CEtIUBX/jb73PJI4iauTECKOChlJCt+Td0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695492; c=relaxed/simple;
	bh=RbrjE1oezGQ0SU+nCFnVdOqqZy+Q2Lk9c54MF8iullY=;
	h=Date:To:From:Subject:Message-Id; b=U+bhAq8JfTjr0mZ+srQ9urgGJZ+UKaktiPassSrdakUz4mXKVzrsDmJ697TwIJjppvvueneBYDxEwR52hO7xQ3eMxidoEtt4GuoCeTq1RBAzKqT9BEE5OG5z9tk6TLO1KGulqDvaQidPVJ7DMdlziLBiKe0v6GzB4Wou1Mgnw8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a0kny7Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a0kny7Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA2EC19425;
	Wed, 13 May 2026 18:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778695492;
	bh=RbrjE1oezGQ0SU+nCFnVdOqqZy+Q2Lk9c54MF8iullY=;
	h=Date:To:From:Subject:From;
	b=a0kny7Pe8zCx9yTZ7kP7J3l7CTZ1FywWdBP9kVAI3Bzw6b0dZkK3zy4FjcNdZwUaS
	 Oc7RI3E3uFC7yFNgvq8NEYEf6vy6oKWXAe162gImm2e2V8D8TPGmzrb6wt6B5yR5Nu
	 hf8oo692r/Dmxo1aUuTKa6hxX/3VUr4wlJ1JM4R4=
Date: Wed, 13 May 2026 11:04:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,seanjc@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,itazur@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch added to mm-new branch
Message-Id: <20260513180452.8FA2EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_notifier: fix a begin vs. start typo in the invalidate range comment
has been added to the -mm mm-new branch.  Its filename is
     mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch

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
From: Takahiro Itazuri <itazur@amazon.com>
Subject: mm/mmu_notifier: fix a begin vs. start typo in the invalidate range comment
Date: Wed, 13 May 2026 09:35:46 -0700

Fix a goof in the block comment for invalidate_range_{start,end}() where
start() is incorrectly referred to as begin().

No functional change intended.

[seanjc@google.com: split to separate patch, write changelog]
Link: https://lore.kernel.org/20260513163546.1176742-1-seanjc@google.com
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment
+++ a/include/linux/mmu_notifier.h
@@ -134,8 +134,8 @@ struct mmu_notifier_ops {
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
 	 * establishment of sptes is forbidden in the range passed to
-	 * invalidate_range_begin/end for the whole duration of the
-	 * invalidate_range_begin/end critical section.
+	 * invalidate_range_start/end for the whole duration of the
+	 * invalidate_range_start/end critical section.
 	 *
 	 * invalidate_range_start() is called when all pages in the
 	 * range are still mapped and have at least a refcount of one.
_

Patches currently in -mm which might be from itazur@amazon.com are

mm-mmu_notifier-fix-a-begin-vs-start-typo-in-the-invalidate-range-comment.patch

