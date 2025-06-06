Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B471FAA;
	Fri,  6 Jun 2025 05:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186173; cv=none; b=n8mFnuVlEjX/FMrXJeZTeK6/JS6w88MGd22/NSBXiL89CcFO73CTOUW5/kQc4uw0DAUL5MRJuh2uvBXwh1rpTdomuoFiKlhD7QZXYEu/1GQEzCKwsLi1uQCX6eYAnX/EJdK2XSrXg5KJCtM5nei7lHSKyNL/Z9mw+RgJ4KnrQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186173; c=relaxed/simple;
	bh=HgIQP+HgxwnYkrdf5pC+p9+9EWxGRHSb3vGaqT1ToAw=;
	h=Date:To:From:Subject:Message-Id; b=lOXg7Z/gAiWs5TStDO1CtmuAI3vJ8YY6bBvW2BWeklBCX37fh2+xIryGObLMKkct2ORsc+jgiqO8ty6gBhlp6YjBAHNZ6+PC8EdktbfNhjAlXrPqfbdqs0EF2KtSZrRRxMFCI8XGPz3rCl/VL1v7fEPk3U0ES0An2+dN2QBUr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDAi55eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDAi55eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4440C4CEEB;
	Fri,  6 Jun 2025 05:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186172;
	bh=HgIQP+HgxwnYkrdf5pC+p9+9EWxGRHSb3vGaqT1ToAw=;
	h=Date:To:From:Subject:From;
	b=NDAi55eqH9TfotA0ngF22pA5P/YlTFb0Hd+E0L2a452GrTRzMWSm1Zbn1NzEc3oRa
	 TlfGX9IVAIBN+XbiZMD0sSEEF8gNYqGeaIO+D65t23VeTsgBX2oXQznasW25qVlAET
	 /cjJMWyB6LEDZJMs+Z0chvZWk0mzn+CvfhWfDy8M=
Date: Thu, 05 Jun 2025 22:02:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch removed from -mm tree
Message-Id: <20250606050252.D4440C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: handle madvise_lock() failure during race unwinding
has been removed from the -mm tree.  Its filename was
     mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: handle madvise_lock() failure during race unwinding
Date: Mon, 2 Jun 2025 10:49:26 -0700

When unwinding race on -ERESTARTNOINTR handling of process_madvise(),
madvise_lock() failure is ignored.  Check the failure and abort remaining
works in the case.

Link: https://lkml.kernel.org/r/20250602174926.1074-1-sj@kernel.org
Fixes: 4000e3d0a367 ("mm/madvise: remove redundant mmap_lock operations from process_madvise()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Barry Song <21cnbao@gmail.com>
Closes: https://lore.kernel.org/CAGsJ_4xJXXO0G+4BizhohSZ4yDteziPw43_uF8nPXPWxUVChzw@mail.gmail.com
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-handle-madvise_lock-failure-during-race-unwinding
+++ a/mm/madvise.c
@@ -1881,7 +1881,9 @@ static ssize_t vector_madvise(struct mm_
 			/* Drop and reacquire lock to unwind race. */
 			madvise_finish_tlb(&madv_behavior);
 			madvise_unlock(mm, behavior);
-			madvise_lock(mm, behavior);
+			ret = madvise_lock(mm, behavior);
+			if (ret)
+				goto out;
 			madvise_init_tlb(&madv_behavior, mm);
 			continue;
 		}
@@ -1892,6 +1894,7 @@ static ssize_t vector_madvise(struct mm_
 	madvise_finish_tlb(&madv_behavior);
 	madvise_unlock(mm, behavior);
 
+out:
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
 
 	return ret;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

