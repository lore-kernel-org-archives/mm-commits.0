Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31763612F8
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103824; cv=none; b=rK54VbJBVIDfpT63qd8dBYDu/bI1XFc4Qm4DUUIpNZsyOqB56qhJFKQrbvQ4nTyBGYsL9UDRal3qlrWfx6y+nVJ3t4jT9cYNYDomQdSsMDrQA1gzn5tp44bC0TIvtvm7RLBDC5TEZPbfOIxS/Eoft5woFIt4gqkgk+vLqg/+cI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103824; c=relaxed/simple;
	bh=SIHfYdwfAyYJeabYo5zwGKgcRXRs+VRTiCEgJKku/w8=;
	h=Date:To:From:Subject:Message-Id; b=lYPitRUiUy8dqruR90ZWjpNc88ojzuxY1xYo1wgJCBgCQOx0NkkWBB3H5Pcbed0KgVx6KjmFePXqEBVCNhG0YBmU9uXQdAAh9RwF44EjVPcIqicV+PJBne7t5gn0mt2SWV/wWAnoem1BX6cqlxpRAqCq4Y32WJ166nOx/GtfytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhX7vzmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhX7vzmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89673C19423;
	Thu,  2 Apr 2026 04:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103824;
	bh=SIHfYdwfAyYJeabYo5zwGKgcRXRs+VRTiCEgJKku/w8=;
	h=Date:To:From:Subject:From;
	b=BhX7vzmuNbLeJJHq1H80xqVFVkWrsIH/VxgZ6LLNbPZjVuzlpJLaxozUk1m2KAoxp
	 IsECuKfWVXfXyvuzmCmGFAkR8791LpCJU7iSADi6nHmPcMVZP56nuXG42co5a7hoU9
	 DKMN2+EuehtsUUx8hsOpBlBTfZ8LEixOD5kmQQ1w=
Date: Wed, 01 Apr 2026 21:23:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-mfill_atomic-remove-retry-logic.patch removed from -mm tree
Message-Id: <20260402042344.89673C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: mfill_atomic(): remove retry logic
has been removed from the -mm tree.  Its filename was
     userfaultfd-mfill_atomic-remove-retry-logic.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: mfill_atomic(): remove retry logic
Date: Mon, 30 Mar 2026 13:11:12 +0300

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

Link: https://lkml.kernel.org/r/20260330101116.1117699-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mfill_atomic-remove-retry-logic
+++ a/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -899,7 +898,6 @@ static __always_inline ssize_t mfill_ato
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -926,26 +924,6 @@ retry:
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -960,8 +938,6 @@ retry:
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
_

Patches currently in -mm which might be from rppt@kernel.org are


