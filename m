Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E415B153
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854837; cv=none; b=EincKbqxfFVQSeGiWm7d2GfWVaECe942rCGnBkG+wRcFk5q96V7kRWYwZE1NxKptcz1BqAX382W6f5J/IyHVYCtdslJ7b/RFxeBMB3cKCLQLcWuSZQYCwOU7A2CoHmGD+FwGa+WUMi2o2blKqyc0zARACdVGKLnhFKKFBiQfBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854837; c=relaxed/simple;
	bh=eJBkCtbOh6nCKLZtHjXdvxqevclJtdSPuewCZh/uAIE=;
	h=Date:To:From:Subject:Message-Id; b=CMBWkond8NaFRWXM88llM+J0oq4oMnCneLPM0HfSUvs7quIdlkGym1EsB5lu39sGhTc0AFZEzb2o46tJqlFz0+1xtDSu/b9WEVixvwCpID8F6EqGkT+Oiv7Cr3a3OzE4USb9IMpY9ft5K3H9YtHVe0GaIwtKdFal7CMCNR/XZEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNE6uxKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNE6uxKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F8C4CECF;
	Wed,  6 Nov 2024 01:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854837;
	bh=eJBkCtbOh6nCKLZtHjXdvxqevclJtdSPuewCZh/uAIE=;
	h=Date:To:From:Subject:From;
	b=LNE6uxKmxDKMbGLvdnNSLHBSWOpComxOgQa0Djy0hcnHmmPXCaPZ54M3mSeOL+rH5
	 wu8gjnalTQpx2ezXNrjrua2L6zAkXTk7wd4mKcLHDmmURfUrbEH04j5q5leS5U1gA0
	 /iUwKwYTMY1wtD6jPb4HK/3rG+LBI0F8aCtWEeLY=
Date: Tue, 05 Nov 2024 17:00:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,skhan@linuxfoundation.org,peterx@redhat.com,anupnewsmail@gmail.com,manas18244@iiitd.ac.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-simplify-pfnmap_lockdep_assert.patch removed from -mm tree
Message-Id: <20241106010036.E81F8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory.c: simplify pfnmap_lockdep_assert
has been removed from the -mm tree.  Its filename was
     mm-memoryc-simplify-pfnmap_lockdep_assert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manas <manas18244@iiitd.ac.in>
Subject: mm/memory.c: simplify pfnmap_lockdep_assert
Date: Fri, 04 Oct 2024 23:12:16 +0530

Use local `mapping' to reduce the pointer chasing.

akpm: extracted from a bugfix which Linus fixed with b1b46751671be ("mm:
fix follow_pfnmap API lockdep assert").

Link: https://lkml.kernel.org/r/20241004-fix-null-deref-v4-1-d0a8ec01ac85@iiitd.ac.in
Signed-off-by: Manas <manas18244@iiitd.ac.in>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-simplify-pfnmap_lockdep_assert
+++ a/mm/memory.c
@@ -6388,7 +6388,7 @@ static inline void pfnmap_lockdep_assert
 	struct address_space *mapping = file ? file->f_mapping : NULL;
 
 	if (mapping)
-		lockdep_assert(lockdep_is_held(&vma->vm_file->f_mapping->i_mmap_rwsem) ||
+		lockdep_assert(lockdep_is_held(&mapping->i_mmap_rwsem) ||
 			       lockdep_is_held(&vma->vm_mm->mmap_lock));
 	else
 		lockdep_assert(lockdep_is_held(&vma->vm_mm->mmap_lock));
_

Patches currently in -mm which might be from manas18244@iiitd.ac.in are


