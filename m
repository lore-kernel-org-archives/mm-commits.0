Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EC72FDC22
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768411120; cv=none; b=ERFK924QAdICraprPWffri0CqlnC3/yh0FXcniFfSJvAwI/+Zp0NgA+/mcBelnfR+/LdbDOwmufYT9BY2ivyMtLHgk7lacpkjpmO7E0g02MXmOwm6ighN6+4236RamCbmOI0t1I7k50hmZ0dONbt6XnKswJSvodNtOcWgZWsb+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768411120; c=relaxed/simple;
	bh=bpxjd725VW7Cq+d5E7UWVCRW3yA60wCNAPffiQgyHEc=;
	h=Date:To:From:Subject:Message-Id; b=oB68BwzcHHNwNd55+fnkO5nLSPstE03Mn9h61jWfylb6AZhxPeCoERJBIQ6bddXluBQfsnPoykQn6wHaGVwdKaXHzQo3j62wzbud4WzhKbKmcF7rfzku5aY5YMK4Pjee73zDYQK2vgI1yf45ohlGJWj0jCYhY+Vsd4/IWeYX2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bPhHwLEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPhHwLEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71DAC4CEF7;
	Wed, 14 Jan 2026 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768411119;
	bh=bpxjd725VW7Cq+d5E7UWVCRW3yA60wCNAPffiQgyHEc=;
	h=Date:To:From:Subject:From;
	b=bPhHwLEPvAaOkezCjNxPRJWIut8FDEa8GTVddHHTcH9ONLIjMRrvY6CD122jscsjB
	 uVRBfeS6FyYe3MicfxSLYjJWRTSizuCk9HlZ8YTfRI4B0FklcNJvbwnGwLLgLTMyh4
	 EooKWfGuRp4f91rrJhtHNiyj8T3hGYA5A17tBCZM=
Date: Wed, 14 Jan 2026 09:18:39 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,david@kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch added to mm-hotfixes-unstable branch
Message-Id: <20260114171839.B71DAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unnecessary and incorrect mmap lock assert
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove unnecessary and incorrect mmap lock assert
Date: Wed, 14 Jan 2026 11:56:19 +0000

This check was introduced by commit 42fc541404f2 ("mmap locking API: add
mmap_assert_locked() and mmap_assert_write_locked()") which replaced a
VM_BUG_ON_VMA() over rwsem_is_locked from commit a00cc7d9dd93 ("mm, x86:
add support for PUD-sized transparent hugepages"), i.e.  the commit that
introduced PUD THPs.

These seem to be careful asserts introduced to ensure that locks are held
in general, however for a zap we require that VMAs are kept stable, and
this is a requirement that has held perfectly well for a long time.

These were long before VMA locks and thus there appears to be no reason to
think this is assert is there for anything other than 'stabilised VMA'.

Asserting that the VMA under examination is stable only in the case of a
THP PUD is strange and unnecessary.  If we wish to be careful and assert
such things, we should do so at the zap level.

However in any case the current situation is already simply incorrect - a
VMA lock suffices here.

Remove the assert for now as it is unnecessarily, incorrect and unhelpful,
subsequent work can introduce an assert in general for zapping if
required.

Link: https://lkml.kernel.org/r/20260114115619.1087466-1-lorenzo.stoakes@oracle.com
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113220856.2358195-1-clm@meta.com/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-remove-unnecessary-and-incorrect-mmap-lock-assert
+++ a/mm/memory.c
@@ -1963,10 +1963,9 @@ static inline unsigned long zap_pud_rang
 	do {
 		next = pud_addr_end(addr, end);
 		if (pud_trans_huge(*pud)) {
-			if (next - addr != HPAGE_PUD_SIZE) {
-				mmap_assert_locked(tlb->mm);
+			if (next - addr != HPAGE_PUD_SIZE)
 				split_huge_pud(vma, pud, addr);
-			} else if (zap_huge_pud(tlb, vma, pud, addr))
+			else if (zap_huge_pud(tlb, vma, pud, addr))
 				goto next;
 			/* fall through */
 		}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

