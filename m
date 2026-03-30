Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722E39935D
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899250; cv=none; b=kbKYrUkRIDTIQjiPoHxMI36qa9Ss1qYo0YxJjK+NFCye/6zX8QxpFjEZuSssjKu2xps9Nvg9o0n0Equf1uF7EyHynJWfnHq2ynPTt/lSMcQwYjPXCIbIQocfAA1gnTFxDosecq0HBL2gy8YrZgnWVMj9M+ZqnFvs3qPOrZqTdqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899250; c=relaxed/simple;
	bh=AYNwcihJrqe6lX/aPkX84No03BettSb+Y6EwQudgM8w=;
	h=Date:To:From:Subject:Message-Id; b=Zeha3nEpP4La/mmgsywm3jUL270TlFn6o8OSfvgIUbMvZhjoufjzovb4zBFUcWYsIHUwhp0vQZAQ9UFSurTKqSlv+SIfgpgivMiPd6dmI7XjC0JMgA0eGl0+Bsq1JcaipbHXEuXM1r03S7L+GTP3czUJSCoQhFJ8q3sO1BvPTYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qe1xTprs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qe1xTprs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4523C4CEF7;
	Mon, 30 Mar 2026 19:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899250;
	bh=AYNwcihJrqe6lX/aPkX84No03BettSb+Y6EwQudgM8w=;
	h=Date:To:From:Subject:From;
	b=qe1xTprslYG4KxOORbB5MfdWcLuzeUpauaJZyiIqbx/UfN7MD+XHS86AtLRBwTWsC
	 5+U8Jbfz7IxUa+nNXAm3YBOs2/11RZaQUZs9A+DS69gjHWTttTpo8odGNYWSm9rWCp
	 GBEaUVO5lnCFW1YklCdmy/g3IzWLVtU0tliAqo+k=
Date: Mon, 30 Mar 2026 12:34:09 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-mfill_atomic-remove-retry-logic.patch removed from -mm tree
Message-Id: <20260330193409.E4523C4CEF7@smtp.kernel.org>
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
Date: Fri, 6 Mar 2026 19:18:11 +0200

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

Link: https://lkml.kernel.org/r/20260306171815.3160826-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
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
 
@@ -896,7 +895,6 @@ static __always_inline ssize_t mfill_ato
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -923,26 +921,6 @@ retry:
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
@@ -957,8 +935,6 @@ retry:
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
_

Patches currently in -mm which might be from rppt@kernel.org are


