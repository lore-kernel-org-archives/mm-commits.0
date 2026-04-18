Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C646337106D
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499059; cv=none; b=kW2is/Y6bg523H1GSm+szPCUKKJP+HESKivTBrtLDGnMdekl4hBjw74PuT/ByLxesP1ThfLiY4WbY80Geew/OtrXlXETaLg2e9EQumMwSd6LUX3CQYPIP7bxh/4sSHruApWZWBwaogkbbOYWjaB4a6rT+JjIrfkU4Et0tXQd3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499059; c=relaxed/simple;
	bh=5xfsm3EZilybAi8OD9/PkJL4/SAiwMW0DHEUXzoPWLQ=;
	h=Date:To:From:Subject:Message-Id; b=dm8AKlyIyT3yTZ9ghQp1ztj4kh/90Pk7pCJRO7dXbuo6x8Yq/AMNf3QIbGDqocvyWpeO2fwsBkf3AlowtqEUWcI+qDxMdbYfZw/yzN0Gk8CV+sbGXv9adiMbaCP+rIimMZ3cfQFhhpXclBqeMsBH6vZCX1nPBnUESRGA777MJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LMuhBclD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LMuhBclD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05C8C19424;
	Sat, 18 Apr 2026 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499059;
	bh=5xfsm3EZilybAi8OD9/PkJL4/SAiwMW0DHEUXzoPWLQ=;
	h=Date:To:From:Subject:From;
	b=LMuhBclDwoaCW+wHKSg6TNSdbXwC3EmwDxad7M9ylbDJSn+AEZi2cAiUgX1Wq2A7V
	 xXqgVrYgH9iSbtOdGJIE2f0yy9jIgPoDrURU8gdORnIkpHdA8jD+4cVvcZJi4YyAdE
	 1JusZoR2Dqq1/atE/tIwz3LqmyrPiwoVI5jpAqog=
Date: Sat, 18 Apr 2026 00:57:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-mfill_atomic-remove-retry-logic.patch removed from -mm tree
Message-Id: <20260418075737.F05C8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: mfill_atomic(): remove retry logic
has been removed from the -mm tree.  Its filename was
     userfaultfd-mfill_atomic-remove-retry-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: mfill_atomic(): remove retry logic
Date: Thu, 2 Apr 2026 07:11:52 +0300

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

[rppt@kernel.org: remove safety measure of not returning ENOENT from _copy]
  Link: https://lore.kernel.org/ac5zcDUY8CFHr6Lw@kernel.org
Link: https://lore.kernel.org/20260402041156.1377214-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
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
Cc: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mfill_atomic-remove-retry-logic
+++ a/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -531,9 +530,6 @@ err_filemap_remove:
 		ops->filemap_remove(folio, state->vma);
 err_folio_put:
 	folio_put(folio);
-	/* Don't return -ENOENT so that our caller won't retry */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
 	return ret;
 }
 
@@ -899,7 +895,6 @@ static __always_inline ssize_t mfill_ato
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -926,26 +921,6 @@ retry:
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
@@ -960,8 +935,6 @@ retry:
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
_

Patches currently in -mm which might be from rppt@kernel.org are


